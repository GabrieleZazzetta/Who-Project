import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assessment_tool/services/sync_service.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/repositories/sync_repository.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'dart:io';

class FakePathProviderPlatform extends PathProviderPlatform {
  final Directory tempDir;
  FakePathProviderPlatform(this.tempDir);

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return tempDir.path;
  }
}

// AUTH SERVICE MOCK
class FakeAuthService implements AuthService {
  @override
  Future<void> syncPendingPasswordChanges() async {}

  @override
  Stream<User?> get authStateChanges => const Stream.empty();

  @override
  User? get currentUser => null;

  @override
  Future<UserSession?> getLocalSession() async => null;

  @override
  Future<UserCredential?> login(String email, String password) async => null;

  @override
  Future<void> logout() async {}

  @override
  Future<UserCredential?> register(String email, String password, {bool isWhoStaff = false, String? displayName}) async => null;
}

// SYNC REPOSITORY MOCK
class FakeSyncRepository implements SyncRepository {
  bool shouldFailPush = false;
  List<Map<String, dynamic>> pullResponse = [];
  
  @override
  Future<String?> pushAssessment(FacilityLayout facility) async {
    if (shouldFailPush) return null;
    return 'mock_remote_id';
  }

  @override
  Future<List<Map<String, dynamic>>> pullAssessments(DateTime? since) async {
    return pullResponse;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late ProviderContainer container;
  late FakeAuthService mockAuthService;
  late FakeSyncRepository mockSyncRepository;
  late DatabaseService dbService;
  late Directory tempDir;

  // TEST ENVIRONMENT SETUP
  setUpAll(() async {
    tempDir = Directory.systemTemp.createTempSync('sync_test_dir');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir);
    
    dbService = DatabaseService.instance;
    await dbService.init();
  });

  setUp(() async {
    mockAuthService = FakeAuthService();
    mockSyncRepository = FakeSyncRepository();
    
    // Clear database state
    final all = await dbService.getAllAssessments();
    for (var a in all) {
      await dbService.deleteAssessment(a.id);
    }

    container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuthService),
      ],
    );

    // Inject mock repository
    container.read(syncProvider.notifier).repository = mockSyncRepository;
  });

  tearDown(() {
    container.dispose();
  });

  // TEST SUITE: SYNC NOTIFIER
  group('SyncNotifier Tests', () {
    test('initial state is idle', () async {
      final state = await container.read(syncProvider.future);
      expect(state.status, SyncStatus.idle);
    });

    test('pushPendingData sets success state and updates dirty assessments', () async {
      // Provision dirty assessment
      final facility = FacilityLayout(
        facilityName: 'Dirty Clinic',
        emergencyType: EmergencyType.ebola,
      )..isDirty = true;
      
      await dbService.saveAssessment(facility);

      // Validate database persistence
      final dirtyList = await dbService.getDirtyAssessments();
      expect(dirtyList.length, 1);

      // Execute push sequence
      await container.read(syncProvider.notifier).pushPendingData();

      // Verify provider state
      final state = container.read(syncProvider).value!;
      expect(state.status, SyncStatus.success);

      // Verify database state
      final updatedList = await dbService.getDirtyAssessments();
      expect(updatedList.length, 0);
      
      final all = await dbService.getAllAssessments();
      expect(all.first.remoteId, 'mock_remote_id');
      expect(all.first.isDirty, false);
    });

    test('pushPendingData sets error state on exception', () async {
      // Inject push failure
      mockSyncRepository.shouldFailPush = true;

      final facility = FacilityLayout(
        facilityName: 'Failing Clinic',
        emergencyType: EmergencyType.sars,
      )..isDirty = true;
      await dbService.saveAssessment(facility);

      try {
        await container.read(syncProvider.notifier).pushPendingData();
      } catch (_) {}

      final state = container.read(syncProvider).value!;
      expect(state.status, SyncStatus.error);
      expect(state.errorMessage, isNotNull);
    });

    test('syncAll performs push and pull', () async {
      // Mock remote pull payload
      final fakeRemoteData = {
        'remoteId': 'remote_123',
        'updatedAt': DateTime.now().toUtc().toIso8601String(),
        'facilityName': 'Remote Clinic',
        'emergencyType': 'mpox',
        'zones': []
      };
      
      mockSyncRepository.pullResponse = [fakeRemoteData];

      // Execute sync cycle
      await container.read(syncProvider.notifier).syncAll();

      final state = container.read(syncProvider).value!;
      expect(state.status, SyncStatus.success);

      // Verify local database persistence
      final localAssessment = await dbService.getAssessmentByRemoteId('remote_123');
      expect(localAssessment, isNotNull);
      expect(localAssessment!.facilityName, 'Remote Clinic');
    });
  });
}
