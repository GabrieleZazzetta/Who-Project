import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';

void main() {
  late Isar isar;
  late Directory tempDir;

  setUpAll(() async {
    // Inizializza core di Isar
    await Isar.initializeIsarCore(download: false);
    
    // Crea directory temporanea
    tempDir = Directory.systemTemp.createTempSync('isar_acid_test_dir');
    
    // Apri istanza Isar
    isar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
  });

  tearDownAll(() async {
    await isar.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  setUp(() async {
    await isar.writeTxn(() async {
      await isar.facilityLayouts.clear();
    });
  });

  group('3.4 Test Interruzione Transazione (ACID Rollback)', () {
    
    test('Consistenza e Atomicità: Un fallimento a metà writeTxn deve eseguire il rollback ed escludere record corrotti o parziali', () async {
      // 1. Inseriamo una struttura iniziale integra e coerente
      final originalFacility = FacilityLayout(
        facilityName: 'Gaza Northern Hospital (Consistent)',
        emergencyType: EmergencyType.sars,
        dateCreated: DateTime.utc(2026, 5, 18, 10, 0, 0),
        zones: [
          SpatialZone(
            id: 'z_triage',
            name: 'Emergency Triage',
            checklist: [
              AssessmentQuestion(
                id: 'q_t1',
                text: 'Is PPE readily available?',
                selectedCompliance: ComplianceLevel.meetsTarget,
              ),
            ],
          ),
        ],
      );

      late Id savedId;
      await isar.writeTxn(() async {
        savedId = await isar.facilityLayouts.put(originalFacility);
      });

      expect(savedId, isNotNull);

      // Verifichiamo che sia stata salvata correttamente
      final initialRecord = await isar.facilityLayouts.get(savedId);
      expect(initialRecord, isNotNull);
      expect(initialRecord!.facilityName, 'Gaza Northern Hospital (Consistent)');
      expect(initialRecord.zones.first.checklist.first.selectedCompliance, ComplianceLevel.meetsTarget);

      // 2. Avviamo una nuova transazione di scrittura che tenta di modificare il record ed inserire dati,
      // ma subisce un errore fatale imprevisto prima del completamento (es. crash di rete, eccezione di memoria, etc.)
      bool exceptionThrown = false;
      try {
        await isar.writeTxn(() async {
          // Modifichiamo il nome e una risposta
          initialRecord.facilityName = 'Gaza Northern Hospital (CORRUPTED NAME)';
          initialRecord.zones.first.checklist.first.selectedCompliance = ComplianceLevel.doesNotMeet;
          
          // Eseguiamo il put a metà transazione
          await isar.facilityLayouts.put(initialRecord);

          // Inseriamo anche una seconda struttura temporanea all'interno della stessa transazione
          final temporaryFacility = FacilityLayout(
            facilityName: 'Temporary Tent (Should be rolled back)',
            emergencyType: EmergencyType.ebola,
          );
          await isar.facilityLayouts.put(temporaryFacility);

          // Forziamo un crash letale prima della fine della transazione
          throw Exception('Fatal native thread interruption or unhandled memory crash simulated');
        });
      } catch (e) {
        exceptionThrown = true;
        expect(e.toString(), contains('Fatal native thread interruption'));
      }

      // Verifichiamo che l'eccezione sia stata sollevata
      expect(exceptionThrown, isTrue);

      // 3. VERIFICA ACID ROLLBACK:
      // A. Il record originario non deve aver subito modifiche permanenti (il nome e le risposte devono essere quelli iniziali)
      final afterCrashRecord = await isar.facilityLayouts.get(savedId);
      expect(afterCrashRecord, isNotNull);
      expect(afterCrashRecord!.facilityName, 'Gaza Northern Hospital (Consistent)');
      expect(afterCrashRecord.zones.first.checklist.first.selectedCompliance, ComplianceLevel.meetsTarget);

      // B. La seconda struttura (inserita parzialmente all'interno della stessa writeTxn) non deve essere presente in Isar
      final allLayouts = await isar.facilityLayouts.where().findAll();
      expect(allLayouts.length, 1); // C'è solo l'originale!
      expect(allLayouts.any((f) => f.facilityName.contains('Temporary Tent')), isFalse);
    });
  });
}
