import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';

void main() {
  late Isar testIsar;
  late Directory tempDir;
  late DatabaseService dbService;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: false);
    tempDir = Directory.systemTemp.createTempSync('isar_db_services_test');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    dbService = DatabaseService.instance;
    dbService.setTestIsar(testIsar);
  });

  tearDownAll(() async {
    testIsar.close();
    if(tempDir.existsSync()){try{tempDir.deleteSync(recursive:true);}catch(e){}}
  });

  setUp(() async {
    await testIsar.writeTxn(() async {
      await testIsar.facilityLayouts.clear();
      await testIsar.userSessions.clear();
      await testIsar.localUserCredentials.clear();
    });
  });

  group('DatabaseService CRUD & Session Unit Tests', () {
    test('saveAssessment should persist layout and auto-mark as dirty', () async {
      final facility = FacilityLayout(
        facilityName: 'Clinic Gamma',
        emergencyType: EmergencyType.mpox,
      );

      final id = await dbService.saveAssessment(facility);
      expect(id, isNotNull);
      expect(facility.id, equals(id));
      expect(facility.isDirty, isTrue);
      expect(facility.updatedAt, isNotNull);

      final retrieved = await dbService.getAssessmentById(id);
      expect(retrieved, isNotNull);
      expect(retrieved!.facilityName, equals('Clinic Gamma'));
      expect(retrieved.isDirty, isTrue);
    });

    test('saveFromSync should persist layout WITHOUT marking as dirty', () async {
      final facility = FacilityLayout(
        facilityName: 'Remote Hospital',
        emergencyType: EmergencyType.ebola,
        isDirty: false,
        remoteId: 'rem_01',
      );

      await dbService.saveFromSync(facility);
      
      final retrieved = await dbService.getAssessmentByRemoteId('rem_01');
      expect(retrieved, isNotNull);
      expect(retrieved!.facilityName, equals('Remote Hospital'));
      expect(retrieved.isDirty, isFalse);
    });

    test('getAllAssessments should retrieve all saved layouts', () async {
      final f1 = FacilityLayout(facilityName: 'H1');
      final f2 = FacilityLayout(facilityName: 'H2');

      await dbService.saveAssessment(f1);
      await dbService.saveAssessment(f2);

      final all = await dbService.getAllAssessments();
      expect(all.length, equals(2));
      expect(all.any((f) => f.facilityName == 'H1'), isTrue);
      expect(all.any((f) => f.facilityName == 'H2'), isTrue);
    });

    test('getDirtyAssessments should return only modified local layouts', () async {
      final f1 = FacilityLayout(facilityName: 'Local Change');
      final f2 = FacilityLayout(facilityName: 'Synced Change');

      await dbService.saveAssessment(f1); // marked dirty automatically
      
      f2.isDirty = false;
      await dbService.saveFromSync(f2); // remains clean

      final dirty = await dbService.getDirtyAssessments();
      expect(dirty.length, equals(1));
      expect(dirty.first.facilityName, equals('Local Change'));
    });

    test('deleteAssessment should permanently remove layout', () async {
      final facility = FacilityLayout(facilityName: 'Delete Me');
      final id = await dbService.saveAssessment(facility);

      var check = await dbService.getAssessmentById(id);
      expect(check, isNotNull);

      await dbService.deleteAssessment(id);
      
      check = await dbService.getAssessmentById(id);
      expect(check, isNull);
    });

    test('Session management operations (saveSession, getCurrentSession, clearSession)', () async {
      var current = await dbService.getCurrentSession();
      expect(current, isNull);

      final session = UserSession()
        ..uid = 'user_01'
        ..email = 'test@who.int'
        ..isLoggedIn = true;

      await dbService.saveSession(session);
      
      current = await dbService.getCurrentSession();
      expect(current, isNotNull);
      expect(current!.uid, equals('user_01'));
      expect(current.email, equals('test@who.int'));
      expect(current.isLoggedIn, isTrue);

      await dbService.clearSession();
      
      current = await dbService.getCurrentSession();
      expect(current, isNull);
    });

    test('Local credentials management (saveLocalCredential, getLocalCredential, getPendingPasswordSyncs)', () async {
      var cred = await dbService.getLocalCredential('User@Domain.Com');
      expect(cred, isNull);

      final newCred = LocalUserCredential()
        ..email = 'User@Domain.Com'
        ..displayName = 'User One'
        ..passwordHash = 'hash123'
        ..passwordNeedsSync = true;

      await dbService.saveLocalCredential(newCred);
      
      // Verification (lowercase and trim should be applied)
      cred = await dbService.getLocalCredential('user@domain.com');
      expect(cred, isNotNull);
      expect(cred!.email, equals('user@domain.com'));
      expect(cred.displayName, equals('User One'));
      expect(cred.passwordHash, equals('hash123'));

      final pending = await dbService.getPendingPasswordSyncs();
      expect(pending.length, equals(1));
      expect(pending.first.email, equals('user@domain.com'));
    });
  });
}
