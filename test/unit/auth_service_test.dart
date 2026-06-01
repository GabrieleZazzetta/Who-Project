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

  setUpAll(() async {
    // NON chiamare Isar.initializeIsarCore qui.
    // DatabaseService è mockato, Isar non è necessario.
    tempDir = Directory.systemTemp.createTempSync('auth_test_dir');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir);
    registerFallbackValues();
  });

  tearDownAll(() async {
    if (tempDir.existsSync()) {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (e) {}
    }
  });

  setUp(() async {
    // Crea MockDatabaseService — nessun Isar richiesto
    mockDb = MockDatabaseService();

    // Default stubs: saveSession, clearAllLocalData → no-op
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

    // Inietta sia il MockFirebaseAuth che il MockDatabaseService
    authService = AuthService(auth: mockFirebaseAuth, db: mockDb);
  });

  group('AuthService Tests', () {
    test('register creates user and saves local session', () async {
      final cred = await authService.register(
        'test@who.int',
        'password',
        isWhoStaff: true,
        displayName: 'Test User',
      );

      expect(cred, isNotNull);
      expect(cred!.user!.email, 'test@who.int');

      // Verifica che saveSession sia stato chiamato con i dati corretti
      verify(() => mockDb.saveSession(any())).called(1);
    });

    test('login authenticates and updates local session', () async {
      // Mock getCurrentSession per restituire una sessione dopo il login
      final fakeSession = UserSession()
        ..uid = 'someuid'
        ..email = 'test@who.int'
        ..isWhoStaff = true
        ..isLoggedIn = true;
      when(() => mockDb.getCurrentSession()).thenAnswer((_) async => fakeSession);

      final cred = await authService.login('test@who.int', 'password');

      expect(cred, isNotNull);
      expect(cred!.user!.uid, 'someuid');

      // Verifica che saveSession sia stato chiamato
      verify(() => mockDb.saveSession(any())).called(1);

      // Verifica la sessione tramite il mock
      final session = await authService.getLocalSession();
      expect(session, isNotNull);
      expect(session!.isWhoStaff, true);
    });

    test('login fallback to local auth when firebase fails', () async {
      // Prepara una credenziale locale valida nel mock
      const cleanEmail = 'offline@test.com';
      const password = 'mySecretPassword';
      final hash = sha256.convert(utf8.encode(password)).toString();

      final localCred = LocalUserCredential()
        ..email = cleanEmail
        ..passwordHash = hash
        ..displayName = 'Offline User'
        ..isWhoStaff = false;

      // MockDB restituisce la credenziale locale quando richiesta
      when(() => mockDb.getLocalCredential(cleanEmail))
          .thenAnswer((_) async => localCred);

      // Auth con Firebase che fallisce
      final failingAuth = FailingFirebaseAuth();
      final offlineService = AuthService(auth: failingAuth, db: mockDb);

      // Login offline: Firebase fallisce, localCred ha successo
      final cred = await offlineService.login(cleanEmail, password);

      // Ritorna null = successo offline (come da implementazione)
      expect(cred, isNull);

      // Verifica che saveSession sia stato chiamato per la sessione offline
      verify(() => mockDb.saveSession(any())).called(1);
    });

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

    test('logout clears local data and signs out from firebase', () async {
      await authService.logout();
      
      // verify che clearAllLocalData sia stato chiamato
      verify(() => mockDb.clearAllLocalData()).called(1);
    });

    test('syncPendingPasswordChanges syncs successfully when user is logged in', () async {
      final cred = LocalUserCredential()
        ..email = 'test@who.int'
        ..pendingPassword = 'newPassword123'
        ..passwordNeedsSync = true;
        
      when(() => mockDb.getPendingPasswordSyncs()).thenAnswer((_) async => [cred]);

      // authService usa mockFirebaseAuth che ha test@who.int loggato
      await authService.syncPendingPasswordChanges();

      // Verifica che il mock aggiorni la password
      // Purtroppo MockFirebaseAuth non traccia le chiamate interne a updatePassword in modo semplice,
      // ma possiamo verificare che il LocalUserCredential sia stato aggiornato per ripulire la pendingPassword.
      verify(() => mockDb.saveLocalCredential(any(that: predicate<LocalUserCredential>((c) {
        return c.passwordNeedsSync == false && c.pendingPassword == null;
      })))).called(1);
    });

    test('syncPendingPasswordChanges does nothing if list is empty', () async {
      when(() => mockDb.getPendingPasswordSyncs()).thenAnswer((_) async => []);
      
      await authService.syncPendingPasswordChanges();
      
      // Assicurati che non tenti di salvare credenziali
      verifyNever(() => mockDb.saveLocalCredential(any()));
    });
  });
}

/// Classe per forzare l'eccezione di rete Firebase
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
