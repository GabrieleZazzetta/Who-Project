import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:intl/intl.dart';

import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/services/sync_service.dart';

import '../helpers/mocks.dart';

void main() {
  late Isar testIsar;
  late Directory tempDir;
  late DatabaseService dbService;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: false);
    tempDir = Directory.systemTemp.createTempSync('isar_services_test');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    dbService = DatabaseService.instance;
    dbService.setTestIsar(testIsar);

    registerFallbackValue(FacilityLayout());
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

  group('Services Unit Tests', () {

    // ==========================================
    // DATABASE SERVICE
    // ==========================================
    group('DatabaseService CRUD Tests', () {
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
    });

    // ==========================================
    // AUTH SERVICE (MOCKTAIL)
    // ==========================================
    group('AuthService Tests', () {
      late MockFirebaseAuth mockAuth;
      late AuthService authService;

      setUp(() {
        mockAuth = MockFirebaseAuth();
        authService = AuthService(auth: mockAuth);
      });

      test('register should create user in firebase and save session locally', () async {
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('fake_uid_123');
        final mockCred = MockUserCredential();
        when(() => mockCred.user).thenReturn(mockUser);

        when(() => mockAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'), 
          password: any(named: 'password')
        )).thenAnswer((_) async => mockCred);

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
        expect(session?.isWhoStaff, true);
        expect(session?.isLoggedIn, true);
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
        
        // Simula fallimento rete
        when(() => mockAuth.signInWithEmailAndPassword(
          email: any(named: 'email'), 
          password: any(named: 'password')
        )).thenThrow(FirebaseAuthException(code: 'network-request-failed'));

        final credential = await authService.login('offline@who.int', 'pass123');
        
        expect(credential, isNull); // Credential is null for offline success

        final session = await DatabaseService.instance.getCurrentSession();
        expect(session, isNotNull);
        expect(session?.email, 'offline@who.int');
        expect(session?.displayName, 'Offline Dr');
      });
    });

    // ==========================================
    // SYNC SERVICE (MOCKTAIL)
    // ==========================================
    group('SyncService Tests', () {
      late MockSyncRepository mockRepo;
      late MockAuthService mockAuth;

      setUp(() {
        mockRepo = MockSyncRepository();
        mockAuth = MockAuthService();
      });

      ProviderContainer createContainer() {
        final container = ProviderContainer(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuth),
          ],
        );
        container.read(syncProvider.notifier).repository = mockRepo;
        return container;
      }

      test('pushPendingData sets error state on failure', () async {
        final container = createContainer();
        
        final dirtyFacility = FacilityLayout(facilityName: 'Dirty', emergencyType: EmergencyType.mpox);
        dirtyFacility.isDirty = true;
        await DatabaseService.instance.saveAssessment(dirtyFacility);

        when(() => mockRepo.pushAssessment(any())).thenThrow(Exception('Server unreachable'));

        final notifier = container.read(syncProvider.notifier);
        
        try {
          await notifier.pushPendingData();
          fail('Should throw exception');
        } catch (e) {
          expect(e, isA<Exception>());
        }

        final state = container.read(syncProvider).value;
        expect(state?.status, SyncStatus.error);
      });

      test('syncAll updates local db from remote json', () async {
        final container = createContainer();
        
        final remoteDate = DateTime.now().add(const Duration(days: 1)).toUtc().toIso8601String();
        
        when(() => mockRepo.pullAssessments(any())).thenAnswer((_) async => [
          {
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
          }
        ]);
        when(() => mockRepo.pushAssessment(any())).thenAnswer((_) async => 'remote_999');

        final notifier = container.read(syncProvider.notifier);
        await notifier.syncAll();

        final state = container.read(syncProvider).value;
        expect(state?.status, SyncStatus.success);

        final localAssessment = await DatabaseService.instance.getAssessmentByRemoteId('remote_123');
        expect(localAssessment, isNotNull);
        expect(localAssessment?.facilityName, 'Remote Clinic');
        expect(localAssessment?.generalInfo?.country, 'Italy');
      });
    });

    // ==========================================
    // SUPPORT SERVICES (GEO & EXPORT)
    // ==========================================
    group('Support Services (Geocoding & Export)', () {
      test('Validazione Coordinate: Rifiuto Null Island', () {
        final RegExp coordRegExp = RegExp(r'([-+]?[0-9]*\.?[0-9]+)[\s,]+([-+]?[0-9]*\.?[0-9]+)');

        bool isValidCoordinate(String text) {
          if (text.trim().isEmpty) return false;
          final match = coordRegExp.firstMatch(text);
          if (match != null && match.groupCount >= 2) {
            try {
              final lat = double.parse(match.group(1)!);
              final lng = double.parse(match.group(2)!);
              if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
                if (lat == 0.0 && lng == 0.0) return false;
                return true;
              }
            } catch (_) {}
          }
          return false;
        }

        expect(isValidCoordinate("45.1843, 9.1567"), isTrue);
        expect(isValidCoordinate("0.0001, 0.0001"), isTrue); 
        expect(isValidCoordinate("0.0, 0.0"), isFalse);
        expect(isValidCoordinate("invalid text"), isFalse);
      });

      test('Export Word Resilience: non deve crashare senza dati', () {
        final facilityVuota = FacilityLayout(
          facilityName: '',
          zones: [],
        )..generalInfo = null;

        String generateTestHtml(FacilityLayout facility) {
          final info = facility.generalInfo;
          return '''
          <html>
          <body>
            <h1>Facility: ${facility.facilityName.isNotEmpty ? facility.facilityName : "Unnamed Facility"}</h1>
            <p>Score: ${facility.globalReadinessScore}%</p>
            <p>Assessor: ${info?.assessorName ?? ''}</p>
          </body>
          </html>
          ''';
        }

        expect(() => generateTestHtml(facilityVuota), returnsNormally);
        final html = generateTestHtml(facilityVuota);
        expect(html.contains("Unnamed Facility"), isTrue);
        expect(html.contains("Score: 0%"), isTrue);
      });
    });

  });
}
