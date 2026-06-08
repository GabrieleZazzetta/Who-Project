import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';

import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/providers/database_provider.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/services/sync_service.dart';
import 'package:assessment_tool/screens/assessments_list_screen.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';
import 'package:assessment_tool/providers/locale_provider.dart';

import '../helpers/mocks.dart';

// SYNC NOTIFIER MOCK
class CustomSyncNotifier extends AsyncNotifier<SyncState> implements SyncNotifier {
  final SyncStatus initialStatus;
  CustomSyncNotifier(this.initialStatus);

  @override
  Future<SyncState> build() async => SyncState(status: initialStatus);

  @override
  Future<void> syncAll({int attempt = 0, bool forcePullAll = false}) async {}

  @override
  Future<void> pushPendingData() async {}

  @override
  Future<void> clearAllData() async {}

  @override
  void resetState() {}
  
  @override
  Future<void> cancelSync() async {}

  @override
  set repository(dynamic repo) {}
}


void main() {
  late Isar testIsar;
  late Directory tempDir;
  late SharedPreferences prefs;

  // TEST ENVIRONMENT SETUP
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    tempDir = Directory.systemTemp.createTempSync('isar_assessments_extended_test');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    DatabaseService.instance.setTestIsar(testIsar);
    
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDownAll(() async {
    testIsar.close();
    if(tempDir.existsSync()){try{tempDir.deleteSync(recursive:true);}catch(_){}}
  });

  setUp(() async {
    await testIsar.writeTxn(() async {
      await testIsar.facilityLayouts.clear();
    });
  });

  Widget createTestWidget(SyncStatus syncStatus) {
    final mockAuth = MockAuthService();
    when(() => mockAuth.syncPendingPasswordChanges()).thenAnswer((_) async {});
    
    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuth),
        sharedPreferencesProvider.overrideWithValue(prefs),
        syncProvider.overrideWith(() => CustomSyncNotifier(syncStatus)),
        databaseServiceProvider.overrideWithValue(DatabaseService.instance),
      ],
      child: const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: AssessmentsListScreen()),
      ),
    );
  }

  // TEST SUITE: ASSESSMENTS LIST EXTENDED
  group('AssessmentsListScreen Extended Tests', () {
    
    testWidgets('Offline Sync indicator shows correct state based on isDirty', (tester) async {
      // Provision dirty facility state
      await tester.runAsync(() async {
        await testIsar.writeTxn(() async {
          final facility = FacilityLayout(
            facilityName: 'Dirty Clinic',
            mapImagePath: '',
            emergencyType: EmergencyType.mpox,
            zones: [],
            isDirty: true,
          )..updatedAt = DateTime.now();
          await testIsar.facilityLayouts.put(facility);
        });
      });

      await tester.runAsync(() async {
        await tester.pumpWidget(createTestWidget(SyncStatus.idle));
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Validate widget rendering
      expect(find.textContaining('Dirty Clinic'), findsWidgets);

      // Validate sync icon presence
      final syncIcon = find.byIcon(Icons.cloud_upload_outlined);
      expect(syncIcon, findsWidgets);
    });

    testWidgets('Pull to refresh using fling', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(createTestWidget(SyncStatus.idle));
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Execute pull-to-refresh gesture
      await tester.fling(find.byType(CustomScrollView), const Offset(0, 500), 1000.0);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Validate refresh indicator rendering
      expect(find.byType(RefreshIndicator), findsWidgets);
    });

    testWidgets('Swipe to delete confirmation dialog', (tester) async {
      // Provision facility for deletion
      await tester.runAsync(() async {
        await testIsar.writeTxn(() async {
          final facility = FacilityLayout(
            facilityName: 'Clinic Rome',
            mapImagePath: '',
            emergencyType: EmergencyType.mpox,
            zones: [],
            isDirty: false,
          )..updatedAt = DateTime.now();
          await testIsar.facilityLayouts.put(facility);
        });
      });

      await tester.runAsync(() async {
        await tester.pumpWidget(createTestWidget(SyncStatus.idle));
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('Clinic Rome'), findsWidgets);

      // Execute delete action
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pump(const Duration(milliseconds: 300));

      // Validate dialog rendering
      expect(find.text('Delete Assessment'), findsOneWidget);

      // Execute cancel action
      await tester.tap(find.text('Cancel'));
      await tester.pump(const Duration(milliseconds: 500));

      // Validate entity persistence
      expect(find.textContaining('Clinic Rome').first, findsWidgets);
    });

    testWidgets('No results found placeholder for empty search', (tester) async {
      // Provision initial state
      await tester.runAsync(() async {
        await testIsar.writeTxn(() async {
          final facility = FacilityLayout(
            facilityName: 'Clinic Rome',
            mapImagePath: '',
            emergencyType: EmergencyType.mpox,
            zones: [],
            isDirty: false,
          )..updatedAt = DateTime.now();
          await testIsar.facilityLayouts.put(facility);
        });
      });

      await tester.runAsync(() async {
        await tester.pumpWidget(createTestWidget(SyncStatus.idle));
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Execute search query
      await tester.enterText(find.byType(TextField), 'NonExistentClinic');
      await tester.pump(const Duration(milliseconds: 500));

      // Validate placeholder rendering
      expect(find.text('No assessments match your filters.'), findsOneWidget);
    });

    testWidgets('Filter popup interactions and Geographical Overview', (tester) async {
      // Provision state with regional data
      await tester.runAsync(() async {
        await testIsar.writeTxn(() async {
          final facility = FacilityLayout(
            facilityName: 'Clinic Africa',
            mapImagePath: '',
            emergencyType: EmergencyType.mpox,
            zones: [
              SpatialZone(
                name: 'Zone 1',
                checklist: [
                  AssessmentQuestion(
                    id: 'q1',
                    category: AssessmentCategory.infectionPreventionControl,
                    text: 'Q1',
                    selectedCompliance: ComplianceLevel.meetsTarget,
                  )
                ],
              )
            ],
            isDirty: false,
          )
            ..updatedAt = DateTime.now()
            ..generalInfo = (GeneralFacilityInfo()..region = 'AFRO');
          await testIsar.facilityLayouts.put(facility);
        });
      });

      await tester.runAsync(() async {
        await tester.pumpWidget(createTestWidget(SyncStatus.idle));
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Validate overview rendering
      expect(find.text('Geographical Overview (Average Readiness)'), findsOneWidget);
      expect(find.text('AFRO'), findsOneWidget);
      expect(find.text('100%'), findsWidgets);

      // Execute filter action
      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pumpAndSettle();

      // Select filter criteria
      await tester.tap(find.text('Highest Score').last, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Open filter popup again
      await tester.tap(find.byIcon(Icons.tune_rounded), warnIfMissed: false);
      await tester.pumpAndSettle();
      
      // Select date filter
      await tester.tap(find.byIcon(Icons.date_range_rounded).last, warnIfMissed: false);
      await tester.pumpAndSettle();
      
      // Confirm date selection
      await tester.tap(find.text('OK').last, warnIfMissed: false);
      await tester.pumpAndSettle();
      
      // Clear date filter
      await tester.tap(find.byIcon(Icons.tune_rounded), warnIfMissed: false);
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Clear Date Filter').last, warnIfMissed: false);
      await tester.pumpAndSettle();
    });
  });
}
