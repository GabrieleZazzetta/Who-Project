import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/services/sync_service.dart';
import 'package:assessment_tool/repositories/sync_repository.dart';
import 'package:assessment_tool/services/auth_service.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FakeAuthService implements AuthService {
  @override
  Stream<User?> get authStateChanges => Stream.empty();
  
  @override
  User? get currentUser => null;
  
  @override
  Future<UserCredential?> login(String email, String password) async => null;
  
  @override
  Future<void> logout() async {}
  
  @override
  Future<UserCredential?> register(String email, String password, {bool isWhoStaff = false, String? displayName}) async => null;
  
  @override
  Future<void> syncPendingPasswordChanges() async {}
  
  @override
  Future<UserSession?> getLocalSession() async {
    return UserSession()..email = 'test@who.int'..displayName = 'Test Staff'..isWhoStaff = true;
  }
}

class FakeSyncRepository extends SyncRepository {
  int pushCount = 0;
  bool failPush = false;
  List<FacilityLayout> pushedAssessments = [];
  List<Map<String, dynamic>> pulledAssessments = [];

  @override
  Future<String?> pushAssessment(FacilityLayout facility) async {
    pushCount++;
    if (failPush) {
      throw Exception('Fake network failure');
    }
    pushedAssessments.add(facility);
    return facility.remoteId ?? 'remote_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<List<Map<String, dynamic>>> pullAssessments(DateTime? lastSync) async {
    return pulledAssessments;
  }
}
class MockSyncRepository extends SyncRepository {
  final List<Map<String, dynamic>> _cloudData = [];

  @override
  Future<String?> pushAssessment(FacilityLayout facility) async {
    final data = {
      'remoteId': facility.remoteId ?? 'remote_${DateTime.now().millisecondsSinceEpoch}',
      'facilityName': facility.facilityName,
      'emergencyType': facility.emergencyType.name,
      'updatedAt': (facility.updatedAt ?? DateTime.now().toUtc()).toIso8601String(),
    };

    final index = _cloudData.indexWhere((doc) => doc['remoteId'] == data['remoteId']);
    if (index >= 0) {
      _cloudData[index] = data;
    } else {
      _cloudData.add(data);
    }
    return data['remoteId'] as String;
  }

  @override
  Future<List<Map<String, dynamic>>> pullAssessments(DateTime? lastSync) async {
    if (lastSync == null) {
      return List<Map<String, dynamic>>.from(_cloudData);
    } else {
      return _cloudData.where((doc) {
        final updatedAt = DateTime.parse(doc['updatedAt'] as String);
        return updatedAt.isAfter(lastSync);
      }).toList();
    }
  }

  void clearCloud() => _cloudData.clear();
  void addCloudData(Map<String, dynamic> data) => _cloudData.add(data);
  int get cloudCount => _cloudData.length;
}

void main() {
  late Isar testIsar;
  late MockSyncRepository mockRepo;
  late FakeSyncRepository fakeRepo;
  late ProviderContainer container;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    tempDir = Directory.systemTemp.createTempSync('isar_integration_sync_dir');
  });

  setUp(() async {
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    DatabaseService.instance.setTestIsar(testIsar);
    
    await testIsar.writeTxn(() async {
      await testIsar.facilityLayouts.clear();
      await testIsar.userSessions.clear();
      await testIsar.localUserCredentials.clear();
    });

    mockRepo = MockSyncRepository();
    fakeRepo = FakeSyncRepository();
    container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWith((ref) => FakeAuthService()),
      ]
    );
    
    container.read(syncProvider.notifier).repository = mockRepo;
  });

  tearDown(() async {
    testIsar.close(deleteFromDisk: true);
    container.dispose();
  });

  tearDownAll(() async {
    if(tempDir.existsSync()){try{tempDir.deleteSync(recursive:true);}catch(e){}}
  });

  group('Sync Flow & Login/Logout Scenarios (MockRepo)', () {
    
    test('forcePullAll pulls all data ignoring local lastSyncedAt state', () async {
      mockRepo.addCloudData({
        'remoteId': 'remote_1',
        'facilityName': 'Cloud Hospital 1',
        'emergencyType': 'mpox',
        'updatedAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      });
      mockRepo.addCloudData({
        'remoteId': 'remote_2',
        'facilityName': 'Cloud Clinic 2',
        'emergencyType': 'ebola',
        'updatedAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      });

      var localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.isEmpty, isTrue);

      container.read(syncProvider.notifier).state = AsyncData(
        SyncState(status: SyncStatus.success, lastSyncedAt: DateTime.now().toUtc())
      );
      await Future.delayed(const Duration(milliseconds: 50));

      await container.read(syncProvider.notifier).syncAll(forcePullAll: false);
      localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.isEmpty, isTrue);

      await container.read(syncProvider.notifier).syncAll(forcePullAll: true);
      
      localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.length, 2);
      expect(localAssessments.map((e) => e.facilityName).toList(), containsAll(['Cloud Hospital 1', 'Cloud Clinic 2']));
    });

    test('Complete End-to-End: Create, Push, Logout (Clear), Login (Pull)', () async {
      final syncNotifier = container.read(syncProvider.notifier);

      final facility = FacilityLayout(facilityName: 'My Assessment', emergencyType: EmergencyType.sars, isDirty: true);
      await DatabaseService.instance.saveAssessment(facility);
      
      var localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.length, 1);
      expect(localAssessments.first.isDirty, isTrue);

      await syncNotifier.syncAll();
      expect(mockRepo.cloudCount, 1);
      
      localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.first.isDirty, isFalse);
      expect(localAssessments.first.remoteId, isNotNull);

      await Future.delayed(const Duration(milliseconds: 50));
      await DatabaseService.instance.clearAllLocalData();
      
      localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.isEmpty, isTrue);

      await syncNotifier.syncAll(forcePullAll: true);
      
      localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.length, 1);
      expect(localAssessments.first.facilityName, 'My Assessment');
      expect(localAssessments.first.remoteId, isNotNull);
      expect(localAssessments.first.isDirty, isFalse);
    });
    
    test('Push pending data does not pull and only pushes (Logout offline prep)', () async {
      mockRepo.addCloudData({
        'remoteId': 'cloud_only_1',
        'facilityName': 'Cloud Only',
        'emergencyType': 'mpox',
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      final facility = FacilityLayout(facilityName: 'Local Offline', emergencyType: EmergencyType.ebola, isDirty: true);
      await DatabaseService.instance.saveAssessment(facility);

      final syncNotifier = container.read(syncProvider.notifier);
      await syncNotifier.pushPendingData();

      expect(mockRepo.cloudCount, 2);

      final localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.length, 1);
      expect(localAssessments.first.facilityName, 'Local Offline');
      expect(localAssessments.first.isDirty, isFalse);
    });
  });

  group('Stress Testing - Offline Flow & Resilience (FakeRepo)', () {
    
    test('Offline-to-Online: Create offline, save and auto-sync on connectivity restore', () async {
      final notifier = container.read(syncProvider.notifier);
      notifier.repository = fakeRepo; // Switch to fakeRepo

      final offlineFacility = FacilityLayout(facilityName: 'Gaza Rural Clinic', emergencyType: EmergencyType.ebola);
      offlineFacility.isDirty = true;
      offlineFacility.updatedAt = DateTime.now().toUtc();

      final savedId = await DatabaseService.instance.saveAssessment(offlineFacility);
      expect(savedId, isNotNull);

      final dirtyBefore = await DatabaseService.instance.getDirtyAssessments();
      expect(dirtyBefore.length, 1);
      expect(dirtyBefore.first.isDirty, isTrue);

      await notifier.syncAll();

      expect(fakeRepo.pushCount, 1);
      expect(fakeRepo.pushedAssessments.length, 1);

      final syncedFacility = await DatabaseService.instance.getAssessmentById(savedId);
      expect(syncedFacility, isNotNull);
      expect(syncedFacility!.isDirty, isFalse); 
      expect(syncedFacility.remoteId, 'remote_$savedId'); 
    });

    test('Exponential Backoff & Retry Resilience: 3 consecutive attempts before failure', () async {
      final notifier = container.read(syncProvider.notifier);
      notifier.repository = fakeRepo;

      final facility = FacilityLayout(facilityName: 'Retry Facility', emergencyType: EmergencyType.mpox);
      facility.isDirty = true;
      facility.updatedAt = DateTime.now().toUtc();
      await DatabaseService.instance.saveAssessment(facility);

      fakeRepo.failPush = true;
      await notifier.syncAll();
      await Future.delayed(const Duration(milliseconds: 200));

      expect(fakeRepo.pushCount, 4); 

      final syncState = container.read(syncProvider).value;
      expect(syncState?.status, SyncStatus.error);
    });

    test('Last-Write-Wins (LWW) Conflict Resolution', () async {
      final notifier = container.read(syncProvider.notifier);
      notifier.repository = fakeRepo;

      // CASE A: Server record is newer
      final localOutdated = FacilityLayout(facilityName: 'Local Hospital V1', emergencyType: EmergencyType.sars);
      localOutdated.remoteId = 'remote_conf_1';
      localOutdated.isDirty = false;
      localOutdated.updatedAt = DateTime.utc(2026, 5, 18, 12, 0, 0);
      await DatabaseService.instance.saveFromSync(localOutdated);

      fakeRepo.pulledAssessments.add({
        'remoteId': 'remote_conf_1',
        'facilityName': 'Server Hospital V2 (New)',
        'emergencyType': 'sars',
        'updatedAt': '2026-05-18T14:00:00Z',
      });

      await notifier.syncAll();

      final resolvedLocalA = await DatabaseService.instance.getAssessmentByRemoteId('remote_conf_1');
      expect(resolvedLocalA, isNotNull);
      expect(resolvedLocalA!.facilityName, 'Server Hospital V2 (New)');
      expect(resolvedLocalA.updatedAt!.toUtc(), DateTime.utc(2026, 5, 18, 14, 0, 0));

      // CASE B: Local record is newer
      fakeRepo.pulledAssessments.clear();
      fakeRepo.pushCount = 0;

      final localNewer = FacilityLayout(facilityName: 'Local Hospital V3 (Newer)', emergencyType: EmergencyType.mpox);
      localNewer.remoteId = 'remote_conf_2';
      localNewer.isDirty = false;
      localNewer.updatedAt = DateTime.utc(2026, 5, 18, 16, 0, 0);
      await DatabaseService.instance.saveFromSync(localNewer);

      fakeRepo.pulledAssessments.add({
        'remoteId': 'remote_conf_2',
        'facilityName': 'Server Hospital V1 (Outdated)',
        'emergencyType': 'mpox',
        'updatedAt': '2026-05-18T10:00:00Z',
      });

      await notifier.syncAll();

      final resolvedLocalB = await DatabaseService.instance.getAssessmentByRemoteId('remote_conf_2');
      expect(resolvedLocalB, isNotNull);
      expect(resolvedLocalB!.facilityName, 'Local Hospital V3 (Newer)'); 
      expect(resolvedLocalB.updatedAt!.toUtc(), DateTime.utc(2026, 5, 18, 16, 0, 0));
    });
  });
}
