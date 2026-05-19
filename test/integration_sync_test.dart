import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/services/sync_service.dart';
import 'package:assessment_tool/repositories/sync_repository.dart';

// REPOSITORY SIMULATO PER I TEST DI INTEGRAZIONE
class FakeSyncRepository extends SyncRepository {
  bool failPush = false;
  int pushCount = 0;
  int pullCount = 0;

  final List<Map<String, dynamic>> pulledAssessments = [];
  final List<FacilityLayout> pushedAssessments = [];

  @override
  Future<String?> pushAssessment(FacilityLayout facility) async {
    pushCount++;
    if (failPush) {
      throw Exception('Server unreachable');
    }
    pushedAssessments.add(facility);
    return facility.remoteId ?? 'remote_${facility.id}';
  }

  @override
  Future<List<Map<String, dynamic>>> pullAssessments(DateTime? lastSync) async {
    pullCount++;
    return pulledAssessments;
  }
}

// AUTH SERVICE SIMULATO PER EVITARE BLOCCHI DI FIREBASE AUTH IN AMBIENTE DI TEST
class FakeAuthService implements AuthService {
  @override
  Stream<User?> get authStateChanges => const Stream.empty();

  @override
  User? get currentUser => null;

  @override
  Future<UserCredential?> register(String email, String password, {bool isWhoStaff = false, String? displayName}) async {
    return null;
  }

  @override
  Future<UserCredential?> login(String email, String password) async {
    return null;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> syncPendingPasswordChanges() async {}

  @override
  Future<UserSession?> getLocalSession() async {
    return null;
  }
}

void main() {
  late Isar testIsar;
  late Directory tempDir;

  // Inizializzazione di Isar in memoria prima di lanciare i test
  setUpAll(() async {
    await Isar.initializeIsarCore(download: false);
    tempDir = Directory.systemTemp.createTempSync('isar_integration_dir');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    // Iniettiamo l'istanza Isar di test nel singleton DatabaseService
    DatabaseService.instance.setTestIsar(testIsar);
  });

  tearDownAll(() async {
    await testIsar.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  // Ripuliamo il database tra un test e l'altro
  setUp(() async {
    final db = DatabaseService.instance;
    final all = await db.getAllAssessments();
    for (var f in all) {
      await db.deleteAssessment(f.id);
    }
  });

  group('3.1 Integration & Stress Testing - Flusso Rurale & Sync', () {
    
    test('Flusso E2E Offline-to-Online: Creazione offline, salvataggio e sincronizzazione automatica al ripristino connettività', () async {
      // Creiamo il ProviderContainer sovrascrivendo l'authServiceProvider
      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(FakeAuthService()),
        ],
      );
      addTearDown(container.dispose);

      // Attendiamo che l'inizializzazione del provider termini
      await container.read(syncProvider.future);

      final db = DatabaseService.instance;
      final fakeRepo = FakeSyncRepository();

      // Iniettiamo il repository simulato nel notifier di sync
      final notifier = container.read(syncProvider.notifier);
      notifier.repository = fakeRepo;

      // 1. Simula l'operatore offline che crea un pre-assessment
      final offlineFacility = FacilityLayout(
        facilityName: 'Gaza Rural Clinic',
        emergencyType: EmergencyType.ebola,
      );
      offlineFacility.isDirty = true; // Salvataggio offline imposta a true
      offlineFacility.updatedAt = DateTime.now().toUtc();

      // Salvataggio locale nel DB Isar
      final savedId = await db.saveAssessment(offlineFacility);
      expect(savedId, isNotNull);

      // Verifica che il record sia marcato come sporco localmente
      final dirtyBefore = await db.getDirtyAssessments();
      expect(dirtyBefore.length, 1);
      expect(dirtyBefore.first.facilityName, 'Gaza Rural Clinic');
      expect(dirtyBefore.first.isDirty, isTrue);

      // 2. Simula il ritorno della connettività (disattivazione modalità aereo)
      // Chiamiamo direttamente syncAll() che è il metodo innescato dal Connectivity listener
      await notifier.syncAll();

      // 3. Verifiche E2E:
      // A. Il repository simulato deve aver ricevuto il record
      expect(fakeRepo.pushCount, 1);
      expect(fakeRepo.pushedAssessments.length, 1);
      expect(fakeRepo.pushedAssessments.first.facilityName, 'Gaza Rural Clinic');

      // B. Il record locale nel DB Isar deve essere aggiornato
      final syncedFacility = await db.getAssessmentById(savedId);
      expect(syncedFacility, isNotNull);
      expect(syncedFacility!.isDirty, isFalse); // Deve essere pulito!
      expect(syncedFacility.remoteId, 'remote_$savedId'); // Deve contenere il remoteId assegnato
      expect(syncedFacility.lastSyncedAt, isNotNull); // Deve contenere la data di sincronizzazione locale
    });

    test('Exponential Backoff & Retry Resilience: Effettua esattamente 3 tentativi consecutivi con ritardi prima di arrendersi', () async {
      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(FakeAuthService()),
        ],
      );
      addTearDown(container.dispose);

      // Attendiamo l'inizializzazione del provider
      await container.read(syncProvider.future);

      final db = DatabaseService.instance;
      final fakeRepo = FakeSyncRepository();

      final notifier = container.read(syncProvider.notifier);
      notifier.repository = fakeRepo;

      // Creiamo un record sporco da inviare
      final facility = FacilityLayout(
        facilityName: 'Retry Facility',
        emergencyType: EmergencyType.mpox,
      );
      facility.isDirty = true;
      facility.updatedAt = DateTime.now().toUtc();
      await db.saveAssessment(facility);

      // Configura il fake repo per fallire permanentemente (simula server spento)
      fakeRepo.failPush = true;

      // Avvia la sincronizzazione (Attempt 0)
      await notifier.syncAll();

      // Poiché la sincronizzazione dei retry asincrona innesca Future.delayed(Duration(milliseconds: 1)),
      // attendiamo brevemente in tempo reale reale affinché i 3 tentativi abbiano luogo consecutivamente.
      await Future.delayed(const Duration(milliseconds: 30));

      // Il pushCount è 4: tentativo iniziale (Attempt 0) + 3 retry consecutivi (Attempt 1, 2, 3)
      expect(fakeRepo.pushCount, 4);

      // Lo stato deve essere transitato in SyncStatus.error
      final syncState = container.read(syncProvider).value;
      expect(syncState?.status, SyncStatus.error);
      expect(syncState?.errorMessage, 'Sync failed after multiple attempts. Please check connection.');
    });

    test('Last-Write-Wins (LWW) Conflict Resolution: Il record remoto più recente sovrascrive quello locale; il record remoto obsoleto viene ignorato', () async {
      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(FakeAuthService()),
        ],
      );
      addTearDown(container.dispose);

      // Attendiamo l'inizializzazione del provider
      await container.read(syncProvider.future);

      final db = DatabaseService.instance;
      final fakeRepo = FakeSyncRepository();

      final notifier = container.read(syncProvider.notifier);
      notifier.repository = fakeRepo;

      // ----------------------------------------------------
      // CASO A: Il record del Server è PIÙ RECENTE di quello Locale
      // ----------------------------------------------------
      final localOutdated = FacilityLayout(
        facilityName: 'Local Hospital V1',
        emergencyType: EmergencyType.sars,
      );
      localOutdated.remoteId = 'remote_conf_1';
      localOutdated.isDirty = false;
      // Impostiamo l'updatedAt localmente alle ore 12:00 UTC
      localOutdated.updatedAt = DateTime.utc(2026, 5, 18, 12, 0, 0);
      await db.saveFromSync(localOutdated);

      // Aggiungiamo al pull un record remoto delle ore 14:00 UTC (più recente)
      fakeRepo.pulledAssessments.add({
        'remoteId': 'remote_conf_1',
        'facilityName': 'Server Hospital V2 (New)',
        'emergencyType': 'sars',
        'updatedAt': '2026-05-18T14:00:00Z', // Ore 14:00 UTC
      });

      // Eseguiamo la sincronizzazione
      await notifier.syncAll();

      // Il record locale deve essersi aggiornato alle informazioni del server (LWW)
      final resolvedLocalA = await db.getAssessmentByRemoteId('remote_conf_1');
      expect(resolvedLocalA, isNotNull);
      expect(resolvedLocalA!.facilityName, 'Server Hospital V2 (New)');
      // Confrontiamo convertendo a UTC per neutralizzare i fusi orari dei vari PC di test
      expect(resolvedLocalA.updatedAt!.toUtc(), DateTime.utc(2026, 5, 18, 14, 0, 0));
      expect(resolvedLocalA.isDirty, isFalse);

      // ----------------------------------------------------
      // CASO B: Il record Locale è PIÙ RECENTE di quello del Server
      // ----------------------------------------------------
      fakeRepo.pulledAssessments.clear();
      fakeRepo.pushCount = 0;

      final localNewer = FacilityLayout(
        facilityName: 'Local Hospital V3 (Newer)',
        emergencyType: EmergencyType.mpox,
      );
      localNewer.remoteId = 'remote_conf_2';
      localNewer.isDirty = false;
      // Impostiamo l'updatedAt localmente alle ore 16:00 UTC
      localNewer.updatedAt = DateTime.utc(2026, 5, 18, 16, 0, 0);
      await db.saveFromSync(localNewer);

      // Aggiungiamo al pull un record remoto delle ore 10:00 UTC (obsoleto)
      fakeRepo.pulledAssessments.add({
        'remoteId': 'remote_conf_2',
        'facilityName': 'Server Hospital V1 (Outdated)',
        'emergencyType': 'mpox',
        'updatedAt': '2026-05-18T10:00:00Z', // Ore 10:00 UTC
      });

      // Eseguiamo la sincronizzazione
      await notifier.syncAll();

      // Il record locale NON deve essere modificato perché ha la priorità temporale (LWW)
      final resolvedLocalB = await db.getAssessmentByRemoteId('remote_conf_2');
      expect(resolvedLocalB, isNotNull);
      expect(resolvedLocalB!.facilityName, 'Local Hospital V3 (Newer)'); // Preservato locale
      expect(resolvedLocalB.updatedAt!.toUtc(), DateTime.utc(2026, 5, 18, 16, 0, 0));
    });
  });
}
