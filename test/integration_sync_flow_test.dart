import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'dart:io';

import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/services/sync_service.dart';
import 'package:assessment_tool/repositories/sync_repository.dart';

// Mock del Repository per evitare chiamate reali a Firebase durante i test
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

  // Helper method for tests
  void clearCloud() => _cloudData.clear();
  void addCloudData(Map<String, dynamic> data) => _cloudData.add(data);
  int get cloudCount => _cloudData.length;
}

void main() {
  late Isar testIsar;
  late MockSyncRepository mockRepo;
  late ProviderContainer container;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: '',
    );
    DatabaseService.instance.setTestIsar(testIsar);

    mockRepo = MockSyncRepository();
    container = ProviderContainer();
    
    // Inject mock repo into the notifier
    container.read(syncProvider.notifier).repository = mockRepo;
  });

  tearDown(() async {
    await testIsar.close(deleteFromDisk: true);
    container.dispose();
  });

  group('Integration Test - Sync Flow & Login/Logout Scenarios', () {
    
    test('1. forcePullAll pulls all data ignoring local lastSyncedAt state', () async {
      // Simulate existing data on cloud
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

      // Verify local DB is empty
      var localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.isEmpty, isTrue);

      // Simulate a previous sync that set the lastSyncedAt to now
      // We manually build the state to simulate a cached state in SyncNotifier
      container.read(syncProvider.notifier).state = AsyncData(
        SyncState(status: SyncStatus.success, lastSyncedAt: DateTime.now().toUtc())
      );

      // Wait a moment so time passes
      await Future.delayed(const Duration(milliseconds: 50));

      // Call syncAll with forcePullAll: false
      // This should NOT pull the old cloud data because lastSyncedAt is more recent than cloud records
      await container.read(syncProvider.notifier).syncAll(forcePullAll: false);
      
      localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.isEmpty, isTrue, reason: "Without forcePullAll, the old records should be ignored due to lastSyncedAt");

      // Call syncAll with forcePullAll: true (Simulating Login Behavior)
      await container.read(syncProvider.notifier).syncAll(forcePullAll: true);
      
      localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.length, 2, reason: "forcePullAll MUST pull all records regardless of lastSyncedAt");
      expect(localAssessments.map((e) => e.facilityName).toList(), containsAll(['Cloud Hospital 1', 'Cloud Clinic 2']));
    });

    test('2. Complete End-to-End: Create, Push, Logout (Clear), Login (Pull)', () async {
      final syncNotifier = container.read(syncProvider.notifier);

      // STEP 1: User creates a local assessment while online/offline
      final facility = FacilityLayout(
        facilityName: 'My Assessment',
        emergencyType: EmergencyType.sars,
        isDirty: true,
      );
      await DatabaseService.instance.saveAssessment(facility);
      
      var localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.length, 1);
      expect(localAssessments.first.isDirty, isTrue);

      // STEP 2: User syncs data to cloud (Push)
      await syncNotifier.syncAll();
      
      // Verify pushed to MockRepo
      expect(mockRepo.cloudCount, 1);
      
      // Verify local is no longer dirty and has remoteId
      localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.first.isDirty, isFalse);
      expect(localAssessments.first.remoteId, isNotNull);

      // Wait a bit to ensure timestamps are distinctly different
      await Future.delayed(const Duration(milliseconds: 50));

      // STEP 3: User logs out
      // Logout clears local DB
      await DatabaseService.instance.clearAllLocalData();
      
      // Verify local DB is completely empty for assessments
      localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.isEmpty, isTrue);

      // Note: SyncNotifier state is still alive in the ProviderContainer with its lastSyncedAt!
      final stateBeforeLogin = container.read(syncProvider).value;
      expect(stateBeforeLogin?.lastSyncedAt, isNotNull);

      // STEP 4: User logs back in
      // Login triggers syncAll(forcePullAll: true)
      await syncNotifier.syncAll(forcePullAll: true);
      
      // Verify assessments are fully restored locally!
      localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.length, 1, reason: "Assessment should be restored from the cloud after login");
      expect(localAssessments.first.facilityName, 'My Assessment');
      expect(localAssessments.first.remoteId, isNotNull);
      expect(localAssessments.first.isDirty, isFalse, reason: "Restored assessments should not be dirty");
    });
    
    test('3. Push pending data does not pull and only pushes (Logout offline prep)', () async {
      // Simulate some existing data on cloud that hasn't been pulled yet
      mockRepo.addCloudData({
        'remoteId': 'cloud_only_1',
        'facilityName': 'Cloud Only',
        'emergencyType': 'mpox',
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      // User creates local data offline
      final facility = FacilityLayout(
        facilityName: 'Local Offline',
        emergencyType: EmergencyType.ebola,
        isDirty: true,
      );
      await DatabaseService.instance.saveAssessment(facility);

      // User presses "Logout", which triggers pushPendingData() first
      final syncNotifier = container.read(syncProvider.notifier);
      await syncNotifier.pushPendingData();

      // Verify cloud has BOTH records now (cloud_only_1 + the new pushed one)
      expect(mockRepo.cloudCount, 2);

      // Verify local DB STILL ONLY HAS ONE (Local Offline).
      // pushPendingData should NOT pull "Cloud Only".
      final localAssessments = await DatabaseService.instance.getAllAssessments();
      expect(localAssessments.length, 1);
      expect(localAssessments.first.facilityName, 'Local Offline');
      expect(localAssessments.first.isDirty, isFalse); // Successfully pushed
    });
  });
}
