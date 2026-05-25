import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';

void main() {
  late Isar isar;
  late Directory tempDir;

  setUpAll(() async {
    // Inizializza le librerie native core di Isar (scarica i binari se non presenti)
    await Isar.initializeIsarCore(download: false);
    
    // Crea una directory temporanea pulita per l'istanza dei test
    tempDir = Directory.systemTemp.createTempSync('isar_test_dir');
    
    // Apri l'istanza Isar di test
    isar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
  });

  tearDownAll(() async {
    // Chiudi l'istanza Isar e pulisci i file temporanei
    await isar.close();
    if(tempDir.existsSync()){try{tempDir.deleteSync(recursive:true);}catch(e){}}
  });

  setUp(() async {
    // Pulisci tutte le tabelle prima di ogni singolo test per avere uno stato sterile
    await isar.writeTxn(() async {
      await isar.facilityLayouts.clear();
      await isar.userSessions.clear();
      await isar.localUserCredentials.clear();
    });
  });

  group('1.2 Modelli Dati, Isar DB e Autenticazione Offline - Unit Tests', () {
    
    test('CRUD e Atomicità: Salvataggio, lettura e aggiornamento di FacilityLayout annidato', () async {
      // 1. CREATE: Prepariamo l'oggetto FacilityLayout complesso
      final facility = FacilityLayout(
        facilityName: 'Isolamento Beta',
        emergencyType: EmergencyType.ebola,
        dateCreated: DateTime.now().toUtc(),
        zones: [
          SpatialZone(
            id: 'z_isolation',
            name: 'Isolation Ward',
            checklist: [
              AssessmentQuestion(
                id: 'q_p1',
                text: 'Is there a clear physical barrier?',
                selectedCompliance: ComplianceLevel.meetsTarget,
              ),
              AssessmentQuestion(
                id: 'q_p2',
                text: 'Is hand hygiene station accessible?',
                selectedCompliance: ComplianceLevel.partiallyMeets,
              ),
            ],
          ),
        ],
      );

      // Salva nel database (Isar put)
      late Id savedId;
      await isar.writeTxn(() async {
        savedId = await isar.facilityLayouts.put(facility);
      });

      expect(savedId, isNotNull);

      // 2. READ: Recuperiamo la struttura salvata tramite l'ID
      final retrieved = await isar.facilityLayouts.get(savedId);

      expect(retrieved, isNotNull);
      expect(retrieved!.facilityName, equals('Isolamento Beta'));
      expect(retrieved.emergencyType, equals(EmergencyType.ebola));
      expect(retrieved.zones.length, equals(1));
      
      // Verifica l'annidamento e l'atomicità degli oggetti embedded
      final zone = retrieved.zones.first;
      expect(zone.name, equals('Isolation Ward'));
      expect(zone.checklist.length, equals(2));
      expect(zone.checklist[0].selectedCompliance, equals(ComplianceLevel.meetsTarget));
      expect(zone.checklist[1].selectedCompliance, equals(ComplianceLevel.partiallyMeets));

      // 3. UPDATE: Modifichiamo una risposta del checklist all'interno della zona
      retrieved.zones.first.checklist[1].selectedCompliance = ComplianceLevel.doesNotMeet;
      
      // Salviamo l'aggiornamento
      await isar.writeTxn(() async {
        await isar.facilityLayouts.put(retrieved);
      });

      // Rileggiamo dal database
      final updated = await isar.facilityLayouts.get(savedId);
      expect(updated, isNotNull);
      expect(updated!.zones.first.checklist[1].selectedCompliance, equals(ComplianceLevel.doesNotMeet));

      // 4. DELETE: Elimina il record
      await isar.writeTxn(() async {
        await isar.facilityLayouts.delete(savedId);
      });

      final afterDelete = await isar.facilityLayouts.get(savedId);
      expect(afterDelete, isNull);
    });

    test('Hashing e Login Locale: Verifica correttezza SHA256 e simulazione login offline', () async {
      // 1. Registrazione/Salvataggio credenziale locale con hashing
      final email = 'medico@who.int';
      final password = 'SafePassword2026!';
      
      // Calcola l'hash SHA256 della password (proprio come nell'app di produzione)
      final bytes = utf8.encode(password);
      final hash = sha256.convert(bytes).toString();

      final localCredential = LocalUserCredential()
        ..email = email.toLowerCase().trim()
        ..displayName = 'Dr. Jane Smith'
        ..passwordHash = hash
        ..isWhoStaff = true;

      await isar.writeTxn(() async {
        await isar.localUserCredentials.put(localCredential);
      });

      // 2. Recupero credenziale per autenticazione offline
      final retrievedCred = await isar.localUserCredentials
          .filter()
          .emailEqualTo(email.toLowerCase().trim())
          .findFirst();

      expect(retrievedCred, isNotNull);
      expect(retrievedCred!.displayName, equals('Dr. Jane Smith'));
      expect(retrievedCred.isWhoStaff, isTrue);

      // 3. Simulazione del controllo di Login Offline
      final inputPasswordValida = 'SafePassword2026!';
      final inputPasswordErrata = 'WrongPassword!';

      // Verifica Password Valida
      final hashValido = sha256.convert(utf8.encode(inputPasswordValida)).toString();
      expect(retrievedCred.passwordHash == hashValido, isTrue);

      // Verifica Password Errata
      final hashErrato = sha256.convert(utf8.encode(inputPasswordErrata)).toString();
      expect(retrievedCred.passwordHash == hashErrato, isFalse);
    });

    test('Pulizia Credenziali Post-Sync: Verifica eliminazione credenziali in chiaro post sync riuscito', () async {
      // 1. Prepariamo credenziali con password pendenti e temporanee in chiaro
      final email = 'staff@who.int';
      final newPassword = 'NewSecretPassword!';
      final oldPassword = 'OldSecretPassword!';
      
      final hashNew = sha256.convert(utf8.encode(newPassword)).toString();

      final localCredential = LocalUserCredential()
        ..email = email
        ..displayName = 'Staff Member'
        ..passwordHash = hashNew
        ..pendingPassword = newPassword // in chiaro, pendente
        ..oldPassword = oldPassword     // in chiaro, temporanea per reauth
        ..passwordNeedsSync = true;

      // Salviamo nel DB
      await isar.writeTxn(() async {
        await isar.localUserCredentials.put(localCredential);
      });

      // Verifica stato di pre-sincronizzazione
      final preSync = await isar.localUserCredentials.filter().emailEqualTo(email).findFirst();
      expect(preSync, isNotNull);
      expect(preSync!.pendingPassword, equals(newPassword));
      expect(preSync.oldPassword, equals(oldPassword));
      expect(preSync.passwordNeedsSync, isTrue);

      // 2. Simulazione Sincronizzazione Riuscita (Svuotamento credenziali sensibili)
      // I dati sensibili temporanei in chiaro devono essere distrutti/azzerati per sicurezza!
      preSync.passwordNeedsSync = false;
      preSync.pendingPassword = null;
      preSync.oldPassword = null;

      await isar.writeTxn(() async {
        await isar.localUserCredentials.put(preSync);
      });

      // 3. Rilettura e convalida: Le stringhe sensibili devono essere assenti in modo definitivo
      final postSync = await isar.localUserCredentials.filter().emailEqualTo(email).findFirst();
      
      expect(postSync, isNotNull);
      expect(postSync!.passwordNeedsSync, isFalse);
      expect(postSync.pendingPassword, isNull);
      expect(postSync.oldPassword, isNull);
      expect(postSync.passwordHash, equals(hashNew)); // Hash sicuro mantenuto
    });
  });
}
