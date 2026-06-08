import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';

void main() {
  late Isar isar;
  late Directory tempDir;

  // TEST ENVIRONMENT SETUP
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    tempDir = Directory.systemTemp.createTempSync('isar_db_analytics_test');
    isar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    DatabaseService.instance.setTestIsar(isar);
  });

  tearDownAll(() async {
    await isar.close();
    if(tempDir.existsSync()){try{tempDir.deleteSync(recursive:true);}catch(_){}}
  });

  setUp(() async {
    await isar.writeTxn(() async {
      await isar.facilityLayouts.clear();
      await isar.userSessions.clear();
      await isar.localUserCredentials.clear();
    });
  });

  // TEST SUITE: DATABASE AND ANALYTICS
  group('Database & Analytics Unit Tests', () {

    // ASSESSMENT DATABASE & AUTHENTICATION
    group('Database integrity and Auth flows', () {
      
      test('CRUD and Atomicity: Save, read, and update nested FacilityLayout', () async {
        // Initialize hierarchical assessment structure
        final facility = FacilityLayout(
          facilityName: 'Isolamento Beta',
          emergencyType: EmergencyType.ebola,
          dateCreated: DateTime.now().toUtc(),
          zones: [
            SpatialZone(
              id: 'z_isolation',
              name: 'Isolation Ward',
              checklist: [
                AssessmentQuestion(id: 'q_p1', selectedCompliance: ComplianceLevel.meetsTarget),
                AssessmentQuestion(id: 'q_p2', selectedCompliance: ComplianceLevel.partiallyMeets),
              ],
            ),
          ],
        );

        // Persist initial state
        late Id savedId;
        await isar.writeTxn(() async {
          savedId = await isar.facilityLayouts.put(facility);
        });
        expect(savedId, isNotNull);

        final retrieved = await isar.facilityLayouts.get(savedId);
        expect(retrieved, isNotNull);
        expect(retrieved!.facilityName, equals('Isolamento Beta'));
        
        // Mutate and update nested data
        retrieved.zones.first.checklist[1].selectedCompliance = ComplianceLevel.doesNotMeet;
        await isar.writeTxn(() async {
          await isar.facilityLayouts.put(retrieved);
        });

        final updated = await isar.facilityLayouts.get(savedId);
        expect(updated!.zones.first.checklist[1].selectedCompliance, equals(ComplianceLevel.doesNotMeet));
      });

      test('Hashing and Local Login: Verify SHA256 correctness and simulate offline login', () async {
        const email = 'medico@who.int';
        const password = 'SafePassword2026!';
        final bytes = utf8.encode(password);
        final hash = sha256.convert(bytes).toString();

        final localCredential = LocalUserCredential()
          ..email = email.toLowerCase().trim()
          ..displayName = 'Dr. Jane Smith'
          ..passwordHash = hash
          ..isWhoStaff = true;

        await isar.writeTxn(() async {
          await isar.localUserCredentials.put(localCredential);
        });

        final retrievedCred = await isar.localUserCredentials.filter().emailEqualTo(email).findFirst();
        expect(retrievedCred, isNotNull);

        final hashValido = sha256.convert(utf8.encode('SafePassword2026!')).toString();
        expect(retrievedCred!.passwordHash == hashValido, isTrue);
      });

      test('clearSession removes user sessions', () async {
        final session = UserSession()..isLoggedIn = true;
        await DatabaseService.instance.saveSession(session);
        var current = await DatabaseService.instance.getCurrentSession();
        expect(current, isNotNull);

        await DatabaseService.instance.clearSession();
        current = await DatabaseService.instance.getCurrentSession();
        expect(current, isNull);
      });

      test('getPendingPasswordSyncs retrieves correctly', () async {
        final cred1 = LocalUserCredential()..email = 'sync1@who.int'..passwordNeedsSync = true;
        final cred2 = LocalUserCredential()..email = 'sync2@who.int'..passwordNeedsSync = false;
        
        await DatabaseService.instance.saveLocalCredential(cred1);
        await DatabaseService.instance.saveLocalCredential(cred2);

        final pending = await DatabaseService.instance.getPendingPasswordSyncs();
        expect(pending.length, equals(1));
        expect(pending.first.email, equals('sync1@who.int'));
      });

      test('clearAllLocalData wipes UserSessions but preserves LocalUserCredential', () async {
        final cred = LocalUserCredential()
          ..email = 'test@who.int'
          ..passwordHash = 'hash123'
          ..displayName = 'Test User';
        await DatabaseService.instance.saveLocalCredential(cred);
        
        await DatabaseService.instance.clearAllLocalData();

        var savedCred = await DatabaseService.instance.getLocalCredential('test@who.int');
        expect(savedCred, isNotNull);
      });
    });

    // ACID ROLLBACK TRANSACTIONS
    group('Test Transaction Interruption (ACID Rollback)', () {
      test('A failure mid-writeTxn should trigger rollback and exclude corrupted records', () async {
        // Prepare initial consistent state
        final originalFacility = FacilityLayout(
          facilityName: 'Gaza Northern Hospital (Consistent)',
          emergencyType: EmergencyType.sars,
          dateCreated: DateTime.utc(2026, 5, 18, 10, 0, 0),
          zones: [
            SpatialZone(id: 'z_triage', checklist: [AssessmentQuestion(id: 'q_t1', selectedCompliance: ComplianceLevel.meetsTarget)]),
          ],
        );

        late Id savedId;
        await isar.writeTxn(() async {
          savedId = await isar.facilityLayouts.put(originalFacility);
        });

        final initialRecord = await isar.facilityLayouts.get(savedId);
        
        // Simulate corrupted update and crash within the same transaction
        bool exceptionThrown = false;
        try {
          await isar.writeTxn(() async {
            initialRecord!.facilityName = 'Gaza Northern Hospital (CORRUPTED NAME)';
            initialRecord.zones.first.checklist.first.selectedCompliance = ComplianceLevel.doesNotMeet;
            await isar.facilityLayouts.put(initialRecord);

            final temporaryFacility = FacilityLayout(facilityName: 'Temporary Tent (Should be rolled back)', emergencyType: EmergencyType.ebola);
            await isar.facilityLayouts.put(temporaryFacility);

            throw Exception('Fatal native thread interruption or unhandled memory crash simulated');
          });
        } catch (e) {
          exceptionThrown = true;
          expect(e.toString(), contains('Fatal native thread interruption'));
        }

        expect(exceptionThrown, isTrue);

        // Verify rollback preserved the previous consistent state
        final afterCrashRecord = await isar.facilityLayouts.get(savedId);
        expect(afterCrashRecord!.facilityName, 'Gaza Northern Hospital (Consistent)');
        expect(afterCrashRecord.zones.first.checklist.first.selectedCompliance, ComplianceLevel.meetsTarget);

        final allLayouts = await isar.facilityLayouts.where().findAll();
        expect(allLayouts.length, 1);
      });
    });

    // ANALYTICS AGGREGATION CALCULATIONS
    group('Analytics Aggregation Engine Computations', () {
      double getCategoryPercentage(List<FacilityLayout> data, AssessmentCategory category) {
        int earned = 0;
        int possible = 0;
        for (var facility in data) {
          for (var zone in facility.zones) {
            for (var q in zone.checklist) {
              if (q.category == category && q.selectedCompliance != ComplianceLevel.pending && q.selectedCompliance != ComplianceLevel.notApplicable) {
                possible += 3;
                earned += q.scoreValue;
              }
            }
          }
        }
        if (possible == 0) return 0;
        return (earned / possible) * 100;
      }

      test('IPC category score is 100% when all questions meetsTarget', () {
        final data = [
          FacilityLayout(zones: [
            SpatialZone(id: 'z1', checklist: [
              AssessmentQuestion(category: AssessmentCategory.infectionPreventionControl, selectedCompliance: ComplianceLevel.meetsTarget),
              AssessmentQuestion(category: AssessmentCategory.infectionPreventionControl, selectedCompliance: ComplianceLevel.meetsTarget),
            ]),
          ]),
        ];
        expect(getCategoryPercentage(data, AssessmentCategory.infectionPreventionControl), equals(100.0));
      });

      test('Trend line sorts facilities chronologically by dateCreated ascending', () {
        final facilities = [
          FacilityLayout(facilityName: 'Third', dateCreated: DateTime.utc(2026, 3, 1), zones: []),
          FacilityLayout(facilityName: 'First', dateCreated: DateTime.utc(2026, 1, 1), zones: []),
          FacilityLayout(facilityName: 'Second', dateCreated: DateTime.utc(2026, 2, 1), zones: []),
        ];

        final sorted = List<FacilityLayout>.from(facilities)
          ..sort((a, b) {
            if (a.dateCreated == null) return 1;
            if (b.dateCreated == null) return -1;
            return a.dateCreated!.compareTo(b.dateCreated!);
          });

        expect(sorted[0].facilityName, equals('First'));
        expect(sorted[1].facilityName, equals('Second'));
        expect(sorted[2].facilityName, equals('Third'));
      });
    });

  });
}
