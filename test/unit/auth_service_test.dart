import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

class FakePathProviderPlatform extends PathProviderPlatform {
  final Directory tempDir;
  FakePathProviderPlatform(this.tempDir);

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return tempDir.path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthService authService;
  late MockFirebaseAuth mockAuth;
  late DatabaseService dbService;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    tempDir = Directory.systemTemp.createTempSync('auth_test_dir');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir);
    
    dbService = DatabaseService.instance;
    await dbService.init();
  });

  setUp(() async {
    // Crea un nuovo mock auth per ogni test
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'test@who.int',
      displayName: 'Test User',
    );
    mockAuth = MockFirebaseAuth(mockUser: user);
    
    authService = AuthService(auth: mockAuth);

    // Ripulisci DB
    await dbService.clearAllLocalData();
  });

  group('AuthService Tests', () {
    test('register creates user and saves local session', () async {
      final cred = await authService.register('test@who.int', 'password', isWhoStaff: true, displayName: 'Test User');
      
      expect(cred, isNotNull);
      expect(cred!.user!.email, 'test@who.int');

      // Verifica che la sessione sia salvata localmente
      final session = await authService.getLocalSession();
      expect(session, isNotNull);
      expect(session!.email, 'test@who.int');
      expect(session.isWhoStaff, true);
    });

    test('login authenticates and updates local session', () async {
      final cred = await authService.login('test@who.int', 'password');
      
      expect(cred, isNotNull);
      expect(cred!.user!.uid, 'someuid');

      // Verifica sessione
      final session = await authService.getLocalSession();
      expect(session, isNotNull);
      expect(session!.isWhoStaff, true); // Identificato dall'email @who.int
    });

    test('login fallback to local auth when firebase fails', () async {
      // 1. Preparazione: salviamo credenziali offline valide
      final cleanEmail = 'offline@test.com';
      final password = 'mySecretPassword';
      final bytes = utf8.encode(password);
      final hash = sha256.convert(bytes).toString();

      final localCred = LocalUserCredential()
        ..email = cleanEmail
        ..passwordHash = hash
        ..displayName = 'Offline User'
        ..isWhoStaff = false;
        
      await dbService.saveLocalCredential(localCred);

      // 2. Facciamo fallire FirebaseAuth lanciando una FirebaseAuthException
      // Creiamo un FirebaseAuth fasullo per questo specifico test
      final failingAuth = FailingFirebaseAuth();
      final offlineAuthService = AuthService(auth: failingAuth);

      // 3. Effettuiamo il login (Firebase fallirà, ma localCred avrà successo)
      final cred = await offlineAuthService.login(cleanEmail, password);
      
      // Quando il login locale ha successo, ritorna null (come da implementazione)
      expect(cred, isNull);

      // Verifica che la sessione locale offline sia stata creata
      final session = await offlineAuthService.getLocalSession();
      expect(session, isNotNull);
      expect(session!.email, cleanEmail);
      expect(session.uid, startsWith('local_'));
    });
  });
}

// Classe per forzare l'eccezione di rete
class FailingFirebaseAuth implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) async {
    throw FirebaseAuthException(code: 'network-request-failed', message: 'No internet');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
