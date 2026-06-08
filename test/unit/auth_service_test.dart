import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import '../helpers/mocks.dart' hide MockFirebaseAuth, MockUser, MockUserCredential;

// TEST UTILITIES
class FakePathProviderPlatform extends PathProviderPlatform {
  final Directory tempDir;
  FakePathProviderPlatform(this.tempDir);

  @override
  Future<String?> getApplicationDocumentsPath() async => tempDir.path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockDatabaseService mockDb;
  late Directory tempDir;

  // TEST ENVIRONMENT SETUP
  setUpAll(() async {
    tempDir = Directory.systemTemp.createTempSync('auth_test_dir');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir);
    registerFallbackValues();
  });

  tearDownAll(() async {
    if (tempDir.existsSync()) {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    }
  });

  setUp(() async {
    mockDb = MockDatabaseService();

    when(() => mockDb.saveSession(any())).thenAnswer((_) async {});
    when(() => mockDb.clearAllLocalData()).thenAnswer((_) async {});
    when(() => mockDb.getCurrentSession()).thenAnswer((_) async => null);
    when(() => mockDb.getLocalCredential(any())).thenAnswer((_) async => null);
    when(() => mockDb.saveLocalCredential(any())).thenAnswer((_) async {});
    when(() => mockDb.getPendingPasswordSyncs()).thenAnswer((_) async => []);

    final mockUser = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'test@who.int',
      displayName: 'Test User',
    );
    mockFirebaseAuth = MockFirebaseAuth(mockUser: mockUser);

    authService = AuthService(auth: mockFirebaseAuth, db: mockDb);
  });

  // TEST SUITE: AUTHENTICATION FLOWS
  group('AuthService Tests', () {

    // REGISTRATION
    test('register creates user and saves local session', () async {
      final cred = await authService.register(
        'test@who.int',
        'password',
        isWhoStaff: true,
        displayName: 'Test User',
      );

      expect(cred, isNotNull);
      expect(cred!.user!.email, 'test@who.int');
      verify(() => mockDb.saveSession(any())).called(1);
    });

    // STANDARD LOGIN
    test('login authenticates and updates local session', () async {
      final fakeSession = UserSession()
        ..uid = 'someuid'
        ..email = 'test@who.int'
        ..isWhoStaff = true
        ..isLoggedIn = true;
      when(() => mockDb.getCurrentSession()).thenAnswer((_) async => fakeSession);

      final cred = await authService.login('test@who.int', 'password');

      expect(cred, isNotNull);
      expect(cred!.user!.uid, 'someuid');
      verify(() => mockDb.saveSession(any())).called(1);

      final session = await authService.getLocalSession();
      expect(session, isNotNull);
      expect(session!.isWhoStaff, true);
    });

    // OFFLINE LOGIN FALLBACK
    test('login fallback to local auth when firebase fails', () async {
      // Provision valid offline credential with pre-hashed password
      const cleanEmail = 'offline@test.com';
      const password = 'mySecretPassword';
      final hash = sha256.convert(utf8.encode(password)).toString();

      final localCred = LocalUserCredential()
        ..email = cleanEmail
        ..passwordHash = hash
        ..displayName = 'Offline User'
        ..isWhoStaff = false;

      // Mock local database to intercept the offline fallback lookup
      when(() => mockDb.getLocalCredential(cleanEmail))
          .thenAnswer((_) async => localCred);

      // Inject network failure via mock and trigger login
      final failingAuth = FailingFirebaseAuth();
      final offlineService = AuthService(auth: failingAuth, db: mockDb);

      final cred = await offlineService.login(cleanEmail, password);

      // Validate that fallback successfully intercepted the failure and authenticated locally
      expect(cred, isNull);
      verify(() => mockDb.saveSession(any())).called(1);
    });

    // INVALID OFFLINE LOGIN
    test('login fallback fails if offline password is wrong', () async {
      const cleanEmail = 'offline@test.com';
      const password = 'wrongPassword';
      final localCred = LocalUserCredential()
        ..email = cleanEmail
        ..passwordHash = 'someOtherHash'
        ..displayName = 'Offline User'
        ..isWhoStaff = false;

      when(() => mockDb.getLocalCredential(cleanEmail))
          .thenAnswer((_) async => localCred);

      final failingAuth = FailingFirebaseAuth();
      final offlineService = AuthService(auth: failingAuth, db: mockDb);

      expect(
        () async => await offlineService.login(cleanEmail, password),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    // LOGOUT
    test('logout clears local data and signs out from firebase', () async {
      await authService.logout();
      verify(() => mockDb.clearAllLocalData()).called(1);
    });

    // PASSWORD SYNC
    test('syncPendingPasswordChanges syncs successfully when user is logged in', () async {
      // Mock an existing pending password change request
      final cred = LocalUserCredential()
        ..email = 'test@who.int'
        ..pendingPassword = 'newPassword123'
        ..passwordNeedsSync = true;
        
      when(() => mockDb.getPendingPasswordSyncs()).thenAnswer((_) async => [cred]);

      // Trigger synchronization loop
      await authService.syncPendingPasswordChanges();

      // Verify that sync loop successfully resolved and cleared the pending flag
      verify(() => mockDb.saveLocalCredential(any(that: predicate<LocalUserCredential>((c) {
        return c.passwordNeedsSync == false && c.pendingPassword == null;
      })))).called(1);
    });

    test('syncPendingPasswordChanges does nothing if list is empty', () async {
      when(() => mockDb.getPendingPasswordSyncs()).thenAnswer((_) async => []);
      
      await authService.syncPendingPasswordChanges();
      verifyNever(() => mockDb.saveLocalCredential(any()));
    });
  });
}

// MOCK FIREBASE ERROR INJECTOR
class FailingFirebaseAuth implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw FirebaseAuthException(
        code: 'network-request-failed', message: 'No internet');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
