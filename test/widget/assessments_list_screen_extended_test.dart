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
    if(tempDir.existsSync()){try{tempDir.deleteSync(recursive:true);}catch(e){}}
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

  group('AssessmentsListScreen Extended Tests', () {
    testWidgets('Offline Sync indicator shows correct state based on isDirty', (tester) async {
      // Add a dirty facility
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

      expect(find.textContaining('Dirty Clinic'), findsWidgets);

      // Should find the cloud_upload_outlined icon for isDirty = true
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

      // Fling down on the list
      await tester.fling(find.byType(CustomScrollView), const Offset(0, 500), 1000.0);
      await tester.pump(const Duration(milliseconds: 100)); // Start refresh
      await tester.pump(const Duration(milliseconds: 500)); // Finish refresh
      await tester.pump(const Duration(milliseconds: 500)); // Settle

      expect(find.byType(RefreshIndicator), findsWidgets);
    });

    testWidgets('Swipe to delete confirmation dialog', (tester) async {
      // Add a facility to the DB
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

      // Tap the delete icon
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pump(const Duration(milliseconds: 300)); // wait for dialog

      // Expect dialog to appear
      expect(find.text('Delete Assessment'), findsOneWidget);

      // Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.textContaining('Clinic Rome').first, findsWidgets); // Still there
    });

    testWidgets('No results found placeholder for empty search', (tester) async {
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

      // Enter search text
      await tester.enterText(find.byType(TextField), 'NonExistentClinic');
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('No assessments match your filters.'), findsOneWidget);
    });
  });
}
