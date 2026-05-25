import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/services/sync_service.dart';
import 'package:assessment_tool/services/auth_service.dart';

import 'utils/fake_services.dart';

void main() {
  late Isar testIsar;
  late Directory tempDir;
  late FakeSyncRepository fakeRepo;
  late FakeAuthService fakeAuth;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: false);
  });

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('sync_service_add_test');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    DatabaseService.instance.setTestIsar(testIsar);

    fakeRepo = FakeSyncRepository();
    fakeAuth = FakeAuthService();
  });

  tearDown(() async {
    testIsar.close();
    if(tempDir.existsSync()){try{tempDir.deleteSync(recursive:true);}catch(e){}}
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(fakeAuth),
      ],
    );
    container.read(syncProvider.notifier).repository = fakeRepo;
    return container;
  }

  group('SyncNotifier Additional Tests', () {
    test('pushPendingData sets error state on failure', () async {
      final container = createContainer();
      
      final dirtyFacility = FacilityLayout(facilityName: 'Dirty', emergencyType: EmergencyType.mpox);
      dirtyFacility.isDirty = true;
      await DatabaseService.instance.saveAssessment(dirtyFacility);

      fakeRepo.failPush = true;

      final notifier = container.read(syncProvider.notifier);
      
      try {
        await notifier.pushPendingData();
        fail('Should throw exception');
      } catch (e) {
        expect(e, isA<Exception>());
      }

      final state = container.read(syncProvider).value;
      expect(state?.status, SyncStatus.error);
      expect(state?.errorMessage, isNotNull);
    });

    test('syncAll retries and ultimately fails after attempts if push fails', () async {
      final container = createContainer();
      
      final dirtyFacility = FacilityLayout(facilityName: 'Dirty', emergencyType: EmergencyType.mpox);
      dirtyFacility.isDirty = true;
      await DatabaseService.instance.saveAssessment(dirtyFacility);

      fakeRepo.failPush = true;

      final notifier = container.read(syncProvider.notifier);
      
      await notifier.syncAll();
      
      // Let async retries complete
      await Future.delayed(const Duration(milliseconds: 100));

      expect(fakeRepo.pushCount, greaterThanOrEqualTo(3));
      
      final state = container.read(syncProvider).value;
      expect(state?.status, SyncStatus.error);
    });

    test('syncAll updates local db from remote json (handleIncomingAssessment)', () async {
      final container = createContainer();
      
      final remoteDate = DateTime.now().add(const Duration(days: 1)).toUtc().toIso8601String();
      
      fakeRepo.pulledAssessments.add({
        'remoteId': 'remote_123',
        'facilityName': 'Remote Clinic',
        'emergencyType': 'mpox',
        'updatedAt': remoteDate,
        'dateCreated': DateTime.now().toUtc().toIso8601String(),
        'generalInfo': {
          'country': 'Italy'
        },
        'zones': [
          {
            'id': 'z1',
            'name': 'Zone 1',
            'checklist': [
              {
                'id': 'q1',
                'text': 'Q1 Text',
                'category': 'infectionPreventionControl',
                'selectedCompliance': 'meetsTarget'
              }
            ]
          }
        ]
      });

      final notifier = container.read(syncProvider.notifier);
      await notifier.syncAll();

      final state = container.read(syncProvider).value;
      expect(state?.status, SyncStatus.success);

      final localAssessment = await DatabaseService.instance.getAssessmentByRemoteId('remote_123');
      expect(localAssessment, isNotNull);
      expect(localAssessment?.facilityName, 'Remote Clinic');
      expect(localAssessment?.generalInfo?.country, 'Italy');
      expect(localAssessment?.zones.first.checklist.first.selectedCompliance, ComplianceLevel.meetsTarget);
    });
  });
}
