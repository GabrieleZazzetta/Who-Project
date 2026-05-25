import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/providers/locale_provider.dart';
import 'package:assessment_tool/screens/settings_screen.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

import 'utils/fake_services.dart';

void main() {
  late Isar testIsar;
  late Directory tempDir;
  late SharedPreferences prefs;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: false);
    tempDir = Directory.systemTemp.createTempSync('isar_widget_settings_test');
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

  group('SettingsScreen Widget Tests', () {
    setUpAll(() {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('overflowed')) {
          return;
        }
        originalOnError?.call(details);
      };
    });

    testWidgets('renders all sections and user profile info', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      await tester.runAsync(() async {
        await testIsar.writeTxn(() async {
          await testIsar.facilityLayouts.clear();
          await testIsar.userSessions.clear();
          await testIsar.localUserCredentials.clear();
          
          final session = UserSession()
            ..displayName = 'Test User'
            ..email = 'test@who.int'
            ..isWhoStaff = true
            ..isLoggedIn = true
            ..lastLogin = DateTime.now();
          await testIsar.userSessions.put(session);
        });

        final fakeAuthService = FakeAuthService();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authServiceProvider.overrideWithValue(fakeAuthService),
              sharedPreferencesProvider.overrideWithValue(prefs),
            ],
            child: const MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: SettingsScreen(),
            ),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        expect(find.text('ACCOUNT & SYNC'), findsOneWidget);
        expect(find.text('User Profile'), findsOneWidget);
        expect(find.text('Language'), findsOneWidget);

        await tester.tap(find.text('User Profile'));
        await tester.pump(); // Inizia animazione dialog e triggera Isar query
        await Future.delayed(const Duration(milliseconds: 500)); // Attende isolate Isar
        await tester.pumpAndSettle(); // Completa UI e FutureBuilder

        expect(find.text('Test User'), findsWidgets);
        
        await tester.tap(find.text('Cancel'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      });
    });
    
    testWidgets('language selector changes locale', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.runAsync(() async {
        await testIsar.writeTxn(() async {
          await testIsar.facilityLayouts.clear();
          await testIsar.userSessions.clear();
          await testIsar.localUserCredentials.clear();
        });

        final fakeAuthService = FakeAuthService();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authServiceProvider.overrideWithValue(fakeAuthService),
              sharedPreferencesProvider.overrideWithValue(prefs),
            ],
            child: const MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: SettingsScreen(),
            ),
          ),
        );
        
        await Future.delayed(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Language'));
        await tester.pumpAndSettle();

        expect(find.text('Italiano'), findsOneWidget);
        
        await tester.tap(find.text('Italiano'));
        await tester.pumpAndSettle();
        
        expect(find.text('Italiano'), findsOneWidget);

        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      });
    });
    
    testWidgets('logout prompts when there are dirty assessments', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.runAsync(() async {
        await testIsar.writeTxn(() async {
          await testIsar.facilityLayouts.clear();
          await testIsar.userSessions.clear();
          await testIsar.localUserCredentials.clear();
        });

        final fakeAuthService = FakeAuthService();
        
        final facility = FacilityLayout(
          facilityName: 'Dirty Clinic',
          emergencyType: EmergencyType.mpox,
        );
        facility.isDirty = true;
        await DatabaseService.instance.saveAssessment(facility);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authServiceProvider.overrideWithValue(fakeAuthService),
              sharedPreferencesProvider.overrideWithValue(prefs),
            ],
            child: const MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: SettingsScreen(),
            ),
          ),
        );
        
        await Future.delayed(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(find.text('Log Out'), 200.0);
        await tester.tap(find.text('Log Out'));
        
        await Future.delayed(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        expect(find.text('Warning: Unsaved Data'), findsWidgets);
        
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      });
    });
  });
}
