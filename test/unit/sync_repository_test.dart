import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:assessment_tool/repositories/sync_repository.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('SyncRepository Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MockFirebaseAuth mockAuth;
    late MockFirebaseStorage mockStorage;
    late SyncRepository repository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      final user = MockUser(isAnonymous: false, uid: 'test_user_id');
      mockAuth = MockFirebaseAuth(mockUser: user, signedIn: true);
      mockStorage = MockFirebaseStorage();

      repository = SyncRepository(
        firestore: fakeFirestore,
        storage: mockStorage,
        auth: mockAuth,
      );
    });

    test('pushAssessment creates a document in Firestore', () async {
      final facility = FacilityLayout(
        facilityName: 'Test Facility',
        emergencyType: EmergencyType.mpox,
      );
      
      final remoteId = await repository.pushAssessment(facility);
      expect(remoteId, isNotNull);

      final doc = await fakeFirestore.collection('assessments').doc(remoteId).get();
      expect(doc.exists, true);
      final data = doc.data()!;
      expect(data['facilityName'], 'Test Facility');
      expect(data['ownerId'], 'test_user_id');
    });

    test('pushAssessment returns null if firestore is not initialized', () async {
      final repoNull = SyncRepository(firestore: null, storage: null, auth: mockAuth);
      final facility = FacilityLayout(facilityName: 'F', emergencyType: EmergencyType.mpox);
      
      final remoteId = await repoNull.pushAssessment(facility);
      expect(remoteId, isNull);
    });

    test('pullAssessments retrieves assessments from Firestore with lastSync', () async {
      final now = DateTime.now();
      await fakeFirestore.collection('assessments').doc('doc1').set({
        'ownerId': 'test_user_id',
        'facilityName': 'Remote Facility',
        'updatedAt': Timestamp.fromDate(now.subtract(const Duration(days: 1))),
      });
      await fakeFirestore.collection('assessments').doc('doc2').set({
        'ownerId': 'test_user_id',
        'facilityName': 'Remote Facility 2',
        'updatedAt': Timestamp.fromDate(now.add(const Duration(days: 1))),
      });

      // Se usiamo lastSync = now, dovrebbe recuperare solo doc2
      final pulled = await repository.pullAssessments(now);
      expect(pulled.length, 1);
      expect(pulled.first['remoteId'], 'doc2');
    });

    test('pullAssessments returns empty list if firestore is not initialized', () async {
      final repoNull = SyncRepository(firestore: null, storage: null, auth: mockAuth);
      final pulled = await repoNull.pullAssessments(null);
      expect(pulled, isEmpty);
    });

    test('pushAssessment uploads local images and replaces with remote URLs', () async {
      final tempDir = Directory.systemTemp.createTempSync('sync_test_images');
      final tempFile = File('${tempDir.path}/test_image.png');
      tempFile.writeAsBytesSync([1, 2, 3]);

      final facility = FacilityLayout(
        facilityName: 'Upload Facility',
        emergencyType: EmergencyType.mpox,
      );
      final zone = SpatialZone(id: 'zone1', name: 'Zone', checklist: [
        AssessmentQuestion(
          id: 'q1',
          text: 'Upload test',
          category: AssessmentCategory.infectionPreventionControl,
          mediaPaths: [tempFile.path, 'http://existing-url.com/img.png'],
        )
      ]);
      facility.zones = [zone];

      final remoteId = await repository.pushAssessment(facility);
      expect(remoteId, isNotNull);

      final doc = await fakeFirestore.collection('assessments').doc(remoteId).get();
      final data = doc.data()!;
      final savedZones = data['zones'] as List;
      final savedChecklist = savedZones[0]['checklist'] as List;
      final savedMedia = savedChecklist[0]['mediaPaths'] as List;

      expect(savedMedia.length, 2);
      expect(savedMedia[0].toString().startsWith('http'), true, reason: 'Local path should be replaced with Storage URL');
      expect(savedMedia[1], 'http://existing-url.com/img.png', reason: 'Existing HTTP urls should not be touched');

      try { tempDir.deleteSync(recursive: true); } catch (_) {}
    });
  });
}
