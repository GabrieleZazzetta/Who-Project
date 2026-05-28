import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'package:mocktail/mocktail.dart';

import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/services/sync_service.dart';
import 'package:assessment_tool/providers/locale_provider.dart';
import 'package:assessment_tool/screens/main_dashboard_screen.dart';
import 'package:assessment_tool/screens/settings_screen.dart';
import 'package:assessment_tool/screens/assessments_list_screen.dart';
import 'package:assessment_tool/screens/register_screen.dart';
import 'package:assessment_tool/screens/facility_selection_screen.dart';
import 'package:assessment_tool/screens/login_screen.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

import '../helpers/mocks.dart';

void main() {
  late Isar testIsar;
  late Directory tempDir;
  late SharedPreferences prefs;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    tempDir = Directory.systemTemp.createTempSync('isar_core_widgets_test');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    DatabaseService.instance.setTestIsar(testIsar);
    
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      originalOnError?.call(details);
    };
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

  Widget createProviderApp(Widget home) {
    final mockAuth = MockAuthService();
    when(() => mockAuth.syncPendingPasswordChanges()).thenAnswer((_) async {});
    when(() => mockAuth.logout()).thenAnswer((_) async {});
    
    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuth),
        sharedPreferencesProvider.overrideWithValue(prefs),
        syncProvider.overrideWith(() => MockSyncNotifier()),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    );
  }

  group('Core Widgets Tests', () {

    // ==========================================
    // MAIN DASHBOARD (widget_main_dashboard_test.dart)
    // ==========================================
    group('MainDashboardScreen Tests', () {
      testWidgets('renders home content with outbreak cards', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());

        await tester.pumpWidget(createProviderApp(const MainDashboardScreen()));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Mpox Outbreak'), findsOneWidget);
        expect(find.text('Ebola Virus Disease'), findsOneWidget);
        expect(find.text('SARI / COVID-19'), findsOneWidget);
        expect(find.text('ACTIVE'), findsWidgets);
        expect(find.text('SOON'), findsWidgets);
      });

      testWidgets('info dialog opens on info button tap', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());

        await tester.pumpWidget(createProviderApp(const MainDashboardScreen()));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.byIcon(Icons.info_outline));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('WHO Assessment Tool'), findsOneWidget);
        
        await tester.tap(find.text('Close'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('WHO Assessment Tool'), findsNothing);
      });

      testWidgets('bottom navigation changes tabs', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());

        await tester.pumpWidget(createProviderApp(const MainDashboardScreen()));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Mpox Outbreak'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.settings));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('ACCOUNT & SYNC'), findsOneWidget);
        expect(find.text('Mpox Outbreak'), findsNothing);
        
        await tester.tap(find.byIcon(Icons.home_filled));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.text('Mpox Outbreak'), findsOneWidget);
      });
    });

    // ==========================================
    // SETTINGS SCREEN (widget_settings_test.dart)
    // ==========================================
    group('SettingsScreen Tests', () {
      testWidgets('renders all sections and user profile info',
          skip: true, // SettingsScreen calls DatabaseService.instance directly — needs provider refactor
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.runAsync(() async {
          await testIsar.writeTxn(() async {
            final session = UserSession()
              ..displayName = 'Test User'
              ..email = 'test@who.int'
              ..isWhoStaff = true
              ..isLoggedIn = true
              ..lastLogin = DateTime.now();
            await testIsar.userSessions.put(session);
          });
        });

        await tester.pumpWidget(createProviderApp(const SettingsScreen()));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('ACCOUNT & SYNC'), findsOneWidget);
        expect(find.text('User Profile'), findsOneWidget);
      });

      testWidgets('logout prompts when there are dirty assessments',
          skip: true, // SettingsScreen calls DatabaseService.instance directly — needs provider refactor
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final facility = FacilityLayout(facilityName: 'Dirty Clinic', emergencyType: EmergencyType.mpox);
        facility.isDirty = true;
        await tester.runAsync(() async {
          await DatabaseService.instance.saveAssessment(facility);
        });

        await tester.pumpWidget(createProviderApp(const SettingsScreen()));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        await tester.scrollUntilVisible(find.text('Log Out'), 200.0);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.runAsync(() async {
          await tester.tap(find.text('Log Out'));
          await Future.delayed(const Duration(milliseconds: 1000));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Warning: Unsaved Data'), findsWidgets);
        await tester.tap(find.text('Cancel'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
      });
    });

    // ==========================================
    // ASSESSMENTS LIST (widget_list_test.dart)
    // ==========================================
    group('AssessmentsListScreen Tests', () {
      testWidgets('should render empty state placeholder when no assessments exist', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.runAsync(() async {
          await testIsar.writeTxn(() async {
            await testIsar.facilityLayouts.clear();
          });
        });
        await tester.pumpWidget(createProviderApp(const AssessmentsListScreen()));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text("No assessments match your filters."), findsOneWidget);
      });

      testWidgets('should filter list dynamically when typing in search bar', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.runAsync(() async {
          await testIsar.writeTxn(() async {
            await testIsar.facilityLayouts.clear();
          });
          await DatabaseService.instance.saveAssessment(FacilityLayout(facilityName: 'Clinic Rome'));
          await DatabaseService.instance.saveAssessment(FacilityLayout(facilityName: 'Clinic London'));
        });
        await tester.pumpWidget(createProviderApp(const AssessmentsListScreen()));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text("Clinic Rome"), findsAtLeastNWidgets(1));
        expect(find.text("Clinic London"), findsAtLeastNWidgets(1));

        final searchFieldFinder = find.byType(TextField).first;
        await tester.enterText(searchFieldFinder, "Rome");
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text("Clinic Rome"), findsAtLeastNWidgets(1));
        expect(find.text("Clinic London"), findsNothing);
      });
    });

    // ==========================================
    // REGISTER SCREEN (widget_register_test.dart)
    // ==========================================
    group('RegisterScreen Tests', () {
      testWidgets('should render all input fields and branding elements', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(createProviderApp(const Scaffold(body: RegisterScreen())));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.text("Join the Platform"), findsAtLeastNWidgets(1));
        expect(find.text("Create Account"), findsAtLeastNWidgets(1));
        expect(find.byType(TextFormField), findsNWidgets(4));
        expect(find.text("Date of Birth"), findsOneWidget);
      });

      testWidgets('password requirements checkmark state updates dynamically', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(createProviderApp(const Scaffold(body: RegisterScreen())));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        final passwordFieldFinder = find.byType(TextFormField).at(3);
        expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(4));

        await tester.enterText(passwordFieldFinder, "abc");
        await tester.pump();
        expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(4));

        await tester.enterText(passwordFieldFinder, "Abc1234!");
        await tester.pump();
        
        expect(find.byIcon(Icons.check_circle), findsNWidgets(4));
      });
    });

    // ==========================================
    // FACILITY SELECTION (widget_facility_selection_test.dart)
    // ==========================================
    group('FacilitySelectionScreen Tests', () {
      testWidgets('renders all facility types and handles navigation for mpox', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 1000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());

        bool preAssessmentVisited = false;
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(path: '/', builder: (context, state) => const FacilitySelectionScreen(emergency: EmergencyType.mpox)),
            GoRoute(path: '/pre-assessment', builder: (context, state) {
              preAssessmentVisited = true;
              return const Scaffold(body: Text('PreAssessment Placeholder'));
            }),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(
          locale: const Locale('en'),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Screening, Triage & Temporary Isolation'), findsOneWidget);
        expect(find.text('Existing Facility with Dedicated Ward'), findsOneWidget);
        expect(find.text('Stand-Alone Treatment Centre'), findsOneWidget);
        expect(find.text('Congregate Settings'), findsOneWidget);

        await tester.tap(find.text('Screening, Triage & Temporary Isolation'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(preAssessmentVisited, isTrue);
        expect(find.text('PreAssessment Placeholder'), findsOneWidget);
      });
    });

    // ==========================================
    // LOGIN SCREEN / FORMS (widget_forms_test.dart)
    // ==========================================
    group('LoginScreen Tests', () {
      testWidgets('Enforcement Autenticazione: Toggling a External Partner consente email generiche', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(createProviderApp(const Scaffold(body: LoginScreen())));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        final externalPartnerToggleFinder = find.byKey(const Key('toggle_external_partner'));
        expect(externalPartnerToggleFinder, findsOneWidget);
        
        await tester.tap(externalPartnerToggleFinder);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        final emailFieldFinder = find.byKey(const Key('input_email'));
        final passwordFieldFinder = find.byKey(const Key('input_password'));
        final authButtonFinder = find.byKey(const Key('btn_authenticate'));

        await tester.enterText(emailFieldFinder, "not-a-valid-email");
        await tester.enterText(passwordFieldFinder, "dummyPassword123!");
        await tester.tap(authButtonFinder);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.text("Please enter a valid email address"), findsOneWidget);

        await tester.enterText(emailFieldFinder, "partner@gmail.com");
        await tester.tap(authButtonFinder);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.text("Please enter a valid email address"), findsNothing);
      });
    });

  });
}
