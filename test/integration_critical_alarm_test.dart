import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/services/report_export_service.dart';

// MOCK BUILD CONTEXT PER EVITARE IL PUMP DI WIDGET NEI TEST DI SERVIZIO ASINCRONI
class MockBuildContext implements BuildContext {
  @override
  RenderObject? findRenderObject() => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  // Inizializza i binding di test di Flutter per consentire il MethodChannel mocking in test standard
  TestWidgetsFlutterBinding.ensureInitialized();

  late Isar testIsar;
  late Directory tempDir;
  final List<MethodCall> shareMethodCalls = [];

  setUpAll(() async {
    // Inizializzazione Isar in memoria
    await Isar.initializeIsarCore(download: false);
    tempDir = Directory.systemTemp.createTempSync('isar_alarm_test_dir');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    DatabaseService.instance.setTestIsar(testIsar);

    // Mock del canale 'plugins.flutter.io/path_provider' per ritornare il nostro tempDir
    const MethodChannel pathChannel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathChannel, (MethodCall methodCall) async {
      if (methodCall.method == 'getTemporaryDirectory') {
        return tempDir.path;
      }
      return null;
    });

    // Mock del canale di piattaforma 'dev.fluttercommunity.plus/share'
    const MethodChannel shareChannel = MethodChannel('dev.fluttercommunity.plus/share');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(shareChannel, (MethodCall methodCall) async {
      shareMethodCalls.add(methodCall);
      // Ritorna una stringa compatibile con il tipo String? atteso da share_plus
      return 'success';
    });
  });

  tearDownAll(() async {
    await testIsar.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  // Ripuliamo il database tra un test e l'altro
  setUp(() async {
    shareMethodCalls.clear();
    final db = DatabaseService.instance;
    final all = await db.getAllAssessments();
    for (var f in all) {
      await db.deleteAssessment(f.id);
    }
  });

  group('3.2 Flusso Allarme Critico e Report', () {
    
    test('Flusso E2E Allarme e Generazione Report: transizione istantanea a Rosso ed Export Word con condivisione nativa', () async {
      final db = DatabaseService.instance;

      // 1. Creiamo una struttura inizialmente a punteggio pieno (Verde)
      final facility = FacilityLayout(
        facilityName: 'Gaza Al-Shifa Hospital',
        emergencyType: EmergencyType.sars,
        dateCreated: DateTime.now().toUtc(),
        zones: [
          SpatialZone(
            id: 'z_screening',
            name: 'Screening and Triage Area',
            checklist: [
              AssessmentQuestion(
                id: 'q_s1',
                text: 'Are suspected cases physically isolated immediately?',
                selectedCompliance: ComplianceLevel.meetsTarget, // Punteggio massimo (3/3)
              ),
            ],
          ),
        ],
      );

      // Metadati anagrafici compilati
      facility.generalInfo = GeneralFacilityInfo()
        ..assessorName = 'Dr. John Doe'
        ..assessorEmail = 'john.doe@who.int'
        ..city = 'Gaza City'
        ..country = 'Palestine'
        ..facilityAddressOrGps = '31.5, 34.4';

      final savedId = await db.saveAssessment(facility);
      expect(savedId, isNotNull);

      // Carichiamo la struttura dal database
      var loaded = await db.getAssessmentById(savedId);
      expect(loaded, isNotNull);

      // La conformità della zona e della struttura deve essere inizialmente 100% (Verde)
      expect(loaded!.globalReadinessScore, equals(100.0));
      expect(loaded.zones.first.statusColor, equals(Colors.green.shade600));

      // 2. Simuliamo la modifica di una risposta impostandola su "Does Not Meet" (Violazione Critica)
      loaded.zones.first.checklist.first.selectedCompliance = ComplianceLevel.doesNotMeet;
      
      // Salviamo l'aggiornamento nel database Isar
      await db.saveAssessment(loaded);

      // Ricarichiamo per verificare la propagazione
      var updated = await db.getAssessmentById(savedId);
      expect(updated, isNotNull);

      // VERIFICA ALLARME CRITICO:
      // A. Il punteggio matematico scende al 33.33%
      expect(updated!.globalReadinessScore, closeTo(33.33, 0.01));
      // B. La conformità della zona passa istantaneamente a Rosso (Critical Failure)
      expect(updated.zones.first.statusColor, equals(Colors.red.shade600));
      // C. Il colore calcolato per il pin della mappa 2D deve passare a Rosso
      bool hasCritical = updated.zones.any((z) => z.checklist.any((q) => q.isCriticalFailure));
      expect(hasCritical, isTrue);

      // 3. Eseguiamo il trigger della generazione del report Word (.doc) e condivisione nativa
      // Passiamo il MockBuildContext che evita la necessità di pompare widget reali
      final mockContext = MockBuildContext();
      await ReportExportService.exportAssessmentToEditableWord(mockContext, updated);

      // 4. VERIFICA GENERAZIONE DEL FILE E CONDIVISIONE NATIVA:
      // A. Verifichiamo che il canale MethodChannel abbia intercettato una chiamata
      expect(shareMethodCalls, isNotEmpty);
      
      // B. Ispezioniamo gli argomenti passati a shareXFiles per trovare il percorso del file generato
      final call = shareMethodCalls.first;
      expect(call.method, contains('share')); // Verifica che stia chiamando il metodo di condivisione
      
      // Estraiamo la lista dei file dai parametri
      final Map<dynamic, dynamic> arguments = call.arguments as Map<dynamic, dynamic>;
      final List<dynamic> paths = arguments['tokens'] ?? arguments['paths'] ?? [];
      expect(paths, isNotEmpty);

      // Estraiamo il file path
      final String filePath = paths.first.toString();
      expect(filePath, contains('WHO_Report_Gaza_Al-Shifa_Hospital.doc'));
      
      // C. Verifichiamo la presenza fisica del file generato sul filesystem di test
      final generatedFile = File(filePath);
      expect(generatedFile.existsSync(), isTrue);

      // D. Verifichiamo il contenuto interno del file generato
      final content = await generatedFile.readAsString();
      expect(content, contains('WHO Assessment Report'));
      expect(content, contains('Gaza Al-Shifa Hospital'));
      expect(content, contains('Dr. John Doe'));
      expect(content, contains('john.doe@who.int'));
      expect(content, contains('Screening and Triage Area'));
      expect(content, contains('33%')); // Tabella dei punteggi deve riflettere lo stato
    });
  });
}
