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

    test('pullAssessments retrieves assessments from Firestore', () async {
      await fakeFirestore.collection('assessments').doc('doc1').set({
        'ownerId': 'test_user_id',
        'facilityName': 'Remote Facility',
        'updatedAt': Timestamp.now(),
      });

      final pulled = await repository.pullAssessments(null);
      expect(pulled.length, 1);
      expect(pulled.first['facilityName'], 'Remote Facility');
      expect(pulled.first['remoteId'], 'doc1');
    });
  });
}
