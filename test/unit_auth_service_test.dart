import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';

import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'utils/fake_firebase.dart';

void main() {
  late Isar testIsar;
  late Directory tempDir;
  late AuthService authService;
  late FakeFirebaseAuth fakeAuth;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: false);
    tempDir = Directory.systemTemp.createTempSync('isar_unit_auth_test');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    DatabaseService.instance.setTestIsar(testIsar);
  });

  tearDownAll(() async {
    testIsar.close();
    if(tempDir.existsSync()){try{tempDir.deleteSync(recursive:true);}catch(e){}}
  });

  setUp(() async {
    await testIsar.writeTxn(() async {
      await testIsar.userSessions.clear();
      await testIsar.localUserCredentials.clear();
    });

    fakeAuth = FakeFirebaseAuth();
    authService = AuthService(auth: fakeAuth);
  });

  group('AuthService Tests', () {
    test('register should create user in firebase and save session locally', () async {
      final credential = await authService.register(
        'test@who.int',
        'password123',
        isWhoStaff: true,
        displayName: 'Test Doctor',
      );

      expect(credential, isNotNull);
      expect(credential?.user?.uid, 'fake_uid_123');

      final session = await DatabaseService.instance.getCurrentSession();
      expect(session, isNotNull);
      expect(session?.email, 'test@who.int');
      expect(session?.displayName, 'Test Doctor');
      expect(session?.isWhoStaff, true);
      expect(session?.isLoggedIn, true);
    });

    test('login online should authenticate and save session', () async {
      final credential = await authService.login('doctor@who.int', 'password123');
      
      expect(credential, isNotNull);
      
      final session = await DatabaseService.instance.getCurrentSession();
      expect(session, isNotNull);
      expect(session?.email, 'doctor@who.int');
      expect(session?.isWhoStaff, true);
    });

    test('login offline should fallback to local credential if network fails', () async {
      // Create a local credential in the database to simulate an existing login
      final bytes = utf8.encode('pass123');
      final inputHash = sha256.convert(bytes).toString();
      
      final localCred = LocalUserCredential()
        ..email = 'offline@who.int'
        ..displayName = 'Offline Dr'
        ..isWhoStaff = true
        ..passwordHash = inputHash;
        
      await DatabaseService.instance.saveLocalCredential(localCred);
      
      // Tell fake Firebase to throw a network exception
      fakeAuth.shouldFail = true;

      // Try login -> Should fallback to local auth and succeed
      final credential = await authService.login('offline@who.int', 'pass123');
      
      // Credential is null when offline login succeeds
      expect(credential, isNull);

      // Verify a local session was created
      final session = await DatabaseService.instance.getCurrentSession();
      expect(session, isNotNull);
      expect(session?.email, 'offline@who.int');
      expect(session?.displayName, 'Offline Dr');
      expect(session?.uid, startsWith('local_'));
    });

    test('login offline should fail if local password does not match', () async {
      final bytes = utf8.encode('pass123');
      final inputHash = sha256.convert(bytes).toString();
      
      final localCred = LocalUserCredential()
        ..email = 'wrong@who.int'
        ..displayName = 'Dr'
        ..isWhoStaff = true
        ..passwordHash = inputHash;
        
      await DatabaseService.instance.saveLocalCredential(localCred);
      
      fakeAuth.shouldFail = true;

      expect(
        () => authService.login('wrong@who.int', 'wrongpassword'),
        throwsA(isA<FirebaseAuthException>()), // The original network error is rethrown if local auth fails
      );
    });
    
    test('logout should clear firebase user and local session', () async {
      await authService.login('test@who.int', 'pass123');
      
      await authService.logout();
      
      expect(fakeAuth.currentUser, isNull);
      final session = await DatabaseService.instance.getCurrentSession();
      expect(session, isNull);
    });
  });
}
