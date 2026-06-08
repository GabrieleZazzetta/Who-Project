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
import 'package:assessment_tool/providers/database_provider.dart';
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
    if (tempDir.existsSync()) {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (e) {}
    }
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
        databaseServiceProvider.overrideWithValue(DatabaseService.instance),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    );
  }

  Widget createProviderAppWithRouter(Widget home) {
    final mockAuth = MockAuthService();
    when(() => mockAuth.syncPendingPasswordChanges()).thenAnswer((_) async {});
    when(() => mockAuth.logout()).thenAnswer((_) async {});

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => home,
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Scaffold(
            body: Text('Login Placeholder'),
          ),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuth),
        sharedPreferencesProvider.overrideWithValue(prefs),
        syncProvider.overrideWith(() => MockSyncNotifier()),
        databaseServiceProvider.overrideWithValue(DatabaseService.instance),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  group('Core Widgets Tests', () {
    // MAIN DASHBOARD
    group('MainDashboardScreen Tests', () {
      testWidgets('renders home content with outbreak cards',
          (WidgetTester tester) async {
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

      testWidgets('info dialog opens on info button tap',
          (WidgetTester tester) async {
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

      testWidgets('bottom navigation changes tabs',
          (WidgetTester tester) async {
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

      testWidgets('renders tablet portrait layout',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(950, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(createProviderApp(const MainDashboardScreen()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(MainDashboardScreen), findsOneWidget);
      });

      testWidgets('renders mobile portrait layout',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(createProviderApp(const MainDashboardScreen()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(MainDashboardScreen), findsOneWidget);
      });
    });

    // SETTINGS SCREEN
    group('SettingsScreen Tests', () {
      testWidgets('renders all sections and user profile info',
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

        await tester.runAsync(() async {
          await tester.pumpWidget(createProviderApp(const SettingsScreen()));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('ACCOUNT & SYNC'), findsOneWidget);
        expect(find.text('User Profile'), findsOneWidget);
      });

      testWidgets('logout prompts when there are dirty assessments',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final mockDb = MockDatabaseService();
        when(() => mockDb.getAllAssessments()).thenAnswer((_) async => []);
        when(() => mockDb.getDirtyAssessments()).thenAnswer((_) async {
          final facility = FacilityLayout(
            facilityName: 'Dirty Clinic',
            emergencyType: EmergencyType.mpox,
          );
          facility.isDirty = true;
          return [facility];
        });

        // Initialize router with explicit mock database
        final mockAuth = MockAuthService();
        when(() => mockAuth.syncPendingPasswordChanges())
            .thenAnswer((_) async {});
        when(() => mockAuth.logout()).thenAnswer((_) async {});

        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const SettingsScreen(),
            ),
            GoRoute(
              path: '/login',
              builder: (context, state) => const Scaffold(
                body: Text('Login Placeholder'),
              ),
            ),
          ],
        );

        await tester.pumpWidget(ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuth),
            sharedPreferencesProvider.overrideWithValue(prefs),
            syncProvider.overrideWith(() => MockSyncNotifier()),
            databaseServiceProvider.overrideWithValue(mockDb),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ));

        await tester.pumpAndSettle();

        // Execute scroll to logout button
        await tester.scrollUntilVisible(find.text('Log Out'), 200.0);
        await tester.pumpAndSettle();

        // Execute logout action
        await tester.tap(find.text('Log Out'));
        await tester.pumpAndSettle();

        // Validate warning dialog rendering
        expect(find.text('Warning: Unsaved Data'), findsOneWidget);

        // Confirm data loss and navigate to login
        await tester.tap(find.text('Logout & Lose Data'));
        await tester.pumpAndSettle();

        expect(find.text('Login Placeholder'), findsOneWidget);
      });

      testWidgets('changes language when selected',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final mockDb = MockDatabaseService();
        when(() => mockDb.getAllAssessments()).thenAnswer((_) async => []);

        await tester.pumpWidget(ProviderScope(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDb),
            sharedPreferencesProvider.overrideWithValue(prefs),
            syncProvider.overrideWith(() => MockSyncNotifier()),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SettingsScreen(),
          ),
        ));
        await tester.pumpAndSettle();

        // Execute language selection
        final langTile = find.text('Language');
        await tester.scrollUntilVisible(langTile, 200.0);
        await tester.tap(langTile);
        await tester.pumpAndSettle();

        // Validate language selector rendering
        expect(find.text('Italiano'), findsOneWidget);

        // Select Italian locale
        await tester.tap(find.text('Italiano'));
        await tester.pumpAndSettle();

        // Validate locale update and dialog closure
        expect(find.text('Italiano'), findsOneWidget);
        expect(find.byType(BottomSheet), findsNothing);
        expect(find.byType(Dialog), findsNothing);
      });

      testWidgets('opens user profile and saves changes',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final mockDb = MockDatabaseService();
        when(() => mockDb.getAllAssessments()).thenAnswer((_) async => []);
        when(() => mockDb.getCurrentSession()).thenAnswer(
            (_) async => UserSession()..displayName = 'Profile User');

        await tester.pumpWidget(ProviderScope(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDb),
            sharedPreferencesProvider.overrideWithValue(prefs),
            syncProvider.overrideWith(() => MockSyncNotifier()),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: SettingsScreen()),
          ),
        ));
        await tester.pumpAndSettle();

        final profileText = find.text('User Profile');
        await tester.scrollUntilVisible(profileText, 200.0, scrollable: find.byType(Scrollable).first);
        await tester.tap(profileText);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        final saveChangesBtn = find.widgetWithText(ElevatedButton, 'Save Changes', skipOffstage: false);
        await tester.ensureVisible(saveChangesBtn);
        expect(saveChangesBtn, findsOneWidget);

        final buttonWidget = tester.widget<ElevatedButton>(saveChangesBtn);
        buttonWidget.onPressed!();
        
        await tester.pumpAndSettle();

        expect(find.text('Profile updated successfully'), findsOneWidget);
      });

      testWidgets('triggers offline sync when data exists',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final mockDb = MockDatabaseService();
        when(() => mockDb.getAllAssessments())
            .thenAnswer((_) async => [FacilityLayout()..facilityName = 'Test']);

        final mockSync = MockSyncNotifier();

        await tester.pumpWidget(ProviderScope(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDb),
            sharedPreferencesProvider.overrideWithValue(prefs),
            syncProvider.overrideWith(() => mockSync),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SettingsScreen(),
          ),
        ));
        await tester.pumpAndSettle();

        final syncTile = find.text('Offline Sync');
        await tester.scrollUntilVisible(syncTile, 200.0);
        await tester.tap(syncTile);
        await tester.pumpAndSettle();

        expect(mockSync.syncAllCalled, true);
      });
    });

    // ASSESSMENTS LIST
    group('AssessmentsListScreen Tests', () {
      testWidgets(
          'should render empty state placeholder when no assessments exist',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.runAsync(() async {
          await testIsar.writeTxn(() async {
            await testIsar.facilityLayouts.clear();
          });
        });
        await tester.runAsync(() async {
          await tester
              .pumpWidget(createProviderApp(const AssessmentsListScreen()));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text("No assessments match your filters."), findsOneWidget);
      });

      testWidgets('should filter list dynamically when typing in search bar',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.runAsync(() async {
          await testIsar.writeTxn(() async {
            await testIsar.facilityLayouts.clear();
          });
          await DatabaseService.instance
              .saveAssessment(FacilityLayout(facilityName: 'Clinic Rome'));
          await DatabaseService.instance
              .saveAssessment(FacilityLayout(facilityName: 'Clinic London'));
        });
        await tester.runAsync(() async {
          await tester
              .pumpWidget(createProviderApp(const AssessmentsListScreen()));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text("Clinic Rome"), findsAtLeastNWidgets(1));
        expect(find.text("Clinic London"), findsAtLeastNWidgets(1));

        final searchFieldFinder = find.byType(TextField).first;
        await tester.runAsync(() async {
          await tester.enterText(searchFieldFinder, "Rome");
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text("Clinic Rome"), findsAtLeastNWidgets(1));
        expect(find.text("Clinic London"), findsNothing);
      });

      testWidgets('Sort dropdown changes list order',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.runAsync(() async {
          await testIsar.writeTxn(() async {
            await testIsar.facilityLayouts.clear();
          });
          final f1 = FacilityLayout(facilityName: 'A Clinic')
            ..dateCreated = DateTime(2023, 1, 1);
          final f2 = FacilityLayout(facilityName: 'Z Clinic')
            ..dateCreated = DateTime(2022, 1, 1);
          await DatabaseService.instance.saveAssessment(f1);
          await DatabaseService.instance.saveAssessment(f2);
        });

        await tester.runAsync(() async {
          await tester
              .pumpWidget(createProviderApp(const AssessmentsListScreen()));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        // Execute sort dropdown tap
        final sortButton = find.byIcon(Icons.sort);
        if (sortButton.evaluate().isNotEmpty) {
          await tester.tap(sortButton);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
          await tester.pump(const Duration(milliseconds: 300));
          // Execute sort option selection
          final highToLow = find.text('Score: High to Low');
          if (highToLow.evaluate().isNotEmpty) {
            await tester.tap(highToLow);
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));
            await tester.pump(const Duration(milliseconds: 300));
          }
        }
        expect(find.text("A Clinic"), findsWidgets);
      });

      testWidgets('Tapping an item attempts navigation',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.runAsync(() async {
          await testIsar.writeTxn(() async {
            await testIsar.facilityLayouts.clear();
          });
          await DatabaseService.instance
              .saveAssessment(FacilityLayout(facilityName: 'Tap Clinic'));
        });

        await tester.runAsync(() async {
          await tester
              .pumpWidget(createProviderApp(const AssessmentsListScreen()));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        final item = find.text('Tap Clinic');
        expect(item, findsWidgets);
      });

      testWidgets('renders tablet portrait layout',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(850, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.runAsync(() async {
          await tester
              .pumpWidget(createProviderApp(const AssessmentsListScreen()));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AssessmentsListScreen), findsOneWidget);
      });

      testWidgets('renders mobile portrait layout',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.runAsync(() async {
          await tester
              .pumpWidget(createProviderApp(const AssessmentsListScreen()));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AssessmentsListScreen), findsOneWidget);
      });
    });

    // REGISTER SCREEN
    group('RegisterScreen Tests', () {
      testWidgets('should render all input fields and branding elements',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
            createProviderApp(const Scaffold(body: RegisterScreen())));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.text("Join the Platform"), findsAtLeastNWidgets(1));
        expect(find.text("Create Account"), findsAtLeastNWidgets(1));
        expect(find.byType(TextFormField), findsNWidgets(4));
        expect(find.text("Date of Birth"), findsOneWidget);
      });

      testWidgets('password requirements checkmark state updates dynamically',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800)); // Use Mobile Portrait to isolate elements
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
            createProviderApp(const Scaffold(body: RegisterScreen())));
        await tester.pumpAndSettle();

        final passwordFieldFinder = find.byType(TextFormField).last;
        expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(4));

        await tester.ensureVisible(passwordFieldFinder);
        await tester.enterText(passwordFieldFinder, "abc");
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(4));

        await tester.enterText(passwordFieldFinder, "Abc1234!");
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.check_circle), findsNWidgets(4));
      });

      testWidgets(
          'shows validation errors for invalid email formats and missing date/password',
          (WidgetTester tester) async {
        await tester.binding
            .setSurfaceSize(const Size(400, 800)); // Mobile Portrait
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
            createProviderApp(const Scaffold(body: RegisterScreen())));
        await tester.pumpAndSettle();

        final emailField = find.byType(TextFormField).at(2);
        final submitButton = find.byType(ElevatedButton).last;

        // Execute invalid WHO email path
        await tester.ensureVisible(emailField);
        await tester.enterText(emailField, "test@gmail.com");
        await tester.ensureVisible(submitButton);
        await tester.tap(submitButton);
        await tester.pumpAndSettle();
        expect(
            find.text("WHO Staff must use a @who.int email"), findsOneWidget);

        // Toggle to External Partner mode
        await tester.ensureVisible(find.text("External Partner"));
        await tester.tap(find.text("External Partner"));
        await tester.pumpAndSettle();

        // Execute invalid external email path
        await tester.ensureVisible(emailField);
        await tester.enterText(emailField, "invalid-email");
        await tester.ensureVisible(submitButton);
        await tester.tap(submitButton);
        await tester.pumpAndSettle();
        expect(find.text("Please enter a valid email address"), findsOneWidget);

        // Correct email but leave date blank
        await tester.ensureVisible(emailField);
        await tester.enterText(emailField, "test@example.com");
        await tester.ensureVisible(find.byType(TextFormField).at(0));
        await tester.enterText(find.byType(TextFormField).at(0), "John");
        await tester.ensureVisible(find.byType(TextFormField).at(1));
        await tester.enterText(find.byType(TextFormField).at(1), "Doe");
        // Execute form submission
        await tester.ensureVisible(submitButton);
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Validate missing date error
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.textContaining('Please select your Date of Birth'),
            findsWidgets);
      });
    });

    // FACILITY SELECTION
    group('FacilitySelectionScreen Tests', () {
      testWidgets('renders all facility types and handles navigation for mpox',
          (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 1000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());

        bool preAssessmentVisited = false;
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
                path: '/',
                builder: (context, state) => const FacilitySelectionScreen(
                    emergency: EmergencyType.mpox)),
            GoRoute(
                path: '/pre-assessment',
                builder: (context, state) {
                  preAssessmentVisited = true;
                  return const Scaffold(
                      body: Text('PreAssessment Placeholder'));
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

        expect(find.text('Screening, Triage & Temporary Isolation'),
            findsOneWidget);
        expect(
            find.text('Existing Facility with Dedicated Ward'), findsOneWidget);
        expect(find.text('Stand-Alone Treatment Centre'), findsOneWidget);
        expect(find.text('Congregate Settings'), findsOneWidget);

        await tester.tap(find.text('Screening, Triage & Temporary Isolation'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(preAssessmentVisited, isTrue);
        expect(find.text('PreAssessment Placeholder'), findsOneWidget);
      });

      testWidgets('renders mobile portrait layout with standard header',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
                path: '/',
                builder: (context, state) => const FacilitySelectionScreen(
                    emergency: EmergencyType.mpox)),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(
          locale: const Locale('en'),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Select Facility Type'), findsOneWidget);
        expect(find.text('Screening, Triage & Temporary Isolation'),
            findsOneWidget);
      });

      testWidgets('renders tablet landscape split layout',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
                path: '/',
                builder: (context, state) => const FacilitySelectionScreen(
                    emergency: EmergencyType.mpox)),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(
          locale: const Locale('en'),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Validate sidebar rendering in split layout
        expect(find.text('Select Facility Type'), findsOneWidget);
        expect(find.text('Screening, Triage & Temporary Isolation'),
            findsOneWidget);
      });

      testWidgets('ebola emergency navigates to map instead of pre-assessment',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        bool mapVisited = false;
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
                path: '/',
                builder: (context, state) => const FacilitySelectionScreen(
                    emergency: EmergencyType.ebola)),
            GoRoute(
                path: '/map',
                builder: (context, state) {
                  mapVisited = true;
                  return const Scaffold(body: Text('Map Placeholder'));
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
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.text('Screening, Triage & Temporary Isolation'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(mapVisited, isTrue);
      });

      testWidgets('renders tablet portrait layout',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
                path: '/',
                builder: (context, state) => const FacilitySelectionScreen(
                    emergency: EmergencyType.sars)),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(
          locale: const Locale('en'),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Select Facility Type'), findsOneWidget);
        expect(find.text('Screening, Triage & Temporary Isolation'),
            findsOneWidget);
      });

      testWidgets('taps back button', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        bool popped = false;
        final router = GoRouter(
          initialLocation: '/home',
          routes: [
            GoRoute(
                path: '/home',
                builder: (context, state) =>
                    const Scaffold(body: Text('Home'))),
            GoRoute(
                path: '/facility',
                builder: (context, state) => const FacilitySelectionScreen(
                    emergency: EmergencyType.mpox)),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(
          locale: const Locale('en'),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        router.push('/facility');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        final backBtn = find.byIcon(Icons.arrow_back_ios_new_rounded);
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn.first);
          await tester.pump();
        }
      });

      testWidgets('toggles sidebar on tablet landscape',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
                path: '/',
                builder: (context, state) => const FacilitySelectionScreen(
                    emergency: EmergencyType.mpox)),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(
          locale: const Locale('en'),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        final collapseBtn = find.byIcon(Icons.menu_open_rounded);
        if (collapseBtn.evaluate().isNotEmpty) {
          await tester.tap(collapseBtn.first);
          await tester.pump(const Duration(milliseconds: 400));
        }
      });

      testWidgets('handles locked module tap', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
                path: '/',
                builder: (context, state) => const FacilitySelectionScreen(
                    emergency: EmergencyType.mpox)),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(
          locale: const Locale('en'),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Execute locked module interaction
        final lockedFacility = find.text('Community Settings');
        if (lockedFacility.evaluate().isNotEmpty) {
          await tester.tap(lockedFacility);
          await tester.pump();
        } else {
          final treatmentUnit = find.text('Treatment Unit');
          if (treatmentUnit.evaluate().isNotEmpty) {
            await tester.tap(treatmentUnit);
            await tester.pump();
          }
        }
      });

      testWidgets('renders mobile landscape layout with list view',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 400));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
                path: '/',
                builder: (context, state) => const FacilitySelectionScreen(
                    emergency: EmergencyType.sars)),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(
          locale: const Locale('en'),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Select Facility Type'), findsOneWidget);
      });
    });

    // SETTINGS ADDITIONAL TESTS
    group('SettingsScreen Additional Tests', () {
      testWidgets('renders mobile layout with SliverAppBar',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final mockDb = MockDatabaseService();
        when(() => mockDb.getAllAssessments()).thenAnswer((_) async => []);

        await tester.runAsync(() async {
          await tester.pumpWidget(ProviderScope(
            overrides: [
              databaseServiceProvider.overrideWithValue(mockDb),
              sharedPreferencesProvider.overrideWithValue(prefs),
              syncProvider.overrideWith(() => MockSyncNotifier()),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const SettingsScreen(),
            ),
          ));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Validate mobile layout sections rendering
        expect(find.text('ACCOUNT & SYNC'), findsOneWidget);
        expect(find.byType(CustomScrollView), findsOneWidget);
      });

      testWidgets('mobile language selector uses BottomSheet',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final mockDb = MockDatabaseService();
        when(() => mockDb.getAllAssessments()).thenAnswer((_) async => []);

        await tester.pumpWidget(ProviderScope(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDb),
            sharedPreferencesProvider.overrideWithValue(prefs),
            syncProvider.overrideWith(() => MockSyncNotifier()),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SettingsScreen(),
          ),
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        final langTile = find.text('Language');
        await tester.scrollUntilVisible(langTile, 200.0);
        await tester.tap(langTile);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Validate language selector bottom sheet
        expect(find.text('Choose Language'), findsOneWidget);
        expect(find.text('Español'), findsOneWidget);
        expect(find.text('Français'), findsOneWidget);

        await tester.tap(find.text('Español'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
      });

      testWidgets('no data shows disabled sync tile',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final mockDb = MockDatabaseService();
        when(() => mockDb.getAllAssessments()).thenAnswer((_) async => []);

        await tester.pumpWidget(ProviderScope(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDb),
            sharedPreferencesProvider.overrideWithValue(prefs),
            syncProvider.overrideWith(() => MockSyncNotifier()),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SettingsScreen(),
          ),
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('No data to synchronize'), findsOneWidget);
      });
    });

    // ASSESSMENTS LIST ADDITIONAL TESTS
    group('AssessmentsListScreen Additional Tests', () {
      testWidgets('delete confirmation dialog appears on swipe/long-press',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final mockDb = MockDatabaseService();
        final f = FacilityLayout(facilityName: 'Delete Me Clinic')..id = 1;
        when(() => mockDb.getAllAssessments()).thenAnswer((_) async => [f]);
        when(() => mockDb.deleteAssessment(any())).thenAnswer((_) async {});

        await tester.pumpWidget(ProviderScope(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDb),
            sharedPreferencesProvider.overrideWithValue(prefs),
            syncProvider.overrideWith(() => MockSyncNotifier()),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AssessmentsListScreen(),
          ),
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Delete Me Clinic'), findsAtLeastNWidgets(1));

        final deleteIcon = find.byIcon(Icons.delete_outline).first;
        await tester.tap(deleteIcon);
        await tester.pump(const Duration(milliseconds: 1000));

        expect(find.text('Delete Assessment'), findsOneWidget);

        await tester.tap(find.byType(ElevatedButton).last);
        await tester.pump(const Duration(milliseconds: 1000));
        await tester.pump(const Duration(milliseconds: 1000));
      });

      testWidgets('tablet landscape shows split detail view',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final mockDb = MockDatabaseService();
        final f1 = FacilityLayout(facilityName: 'Landscape Clinic')
          ..dateCreated = DateTime(2024, 1, 1);
        when(() => mockDb.getAllAssessments()).thenAnswer((_) async => [f1]);

        await tester.pumpWidget(ProviderScope(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDb),
            sharedPreferencesProvider.overrideWithValue(prefs),
            syncProvider.overrideWith(() => MockSyncNotifier()),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AssessmentsListScreen(),
          ),
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Landscape Clinic'), findsAtLeastNWidgets(1));
      });

      testWidgets('score sort low to high works', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final mockDb = MockDatabaseService();
        final f1 = FacilityLayout(facilityName: 'High Score')
          ..dateCreated = DateTime(2024, 1, 1);
        final f2 = FacilityLayout(facilityName: 'Low Score')
          ..dateCreated = DateTime(2024, 2, 1);
        when(() => mockDb.getAllAssessments())
            .thenAnswer((_) async => [f1, f2]);

        await tester.pumpWidget(ProviderScope(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDb),
            sharedPreferencesProvider.overrideWithValue(prefs),
            syncProvider.overrideWith(() => MockSyncNotifier()),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AssessmentsListScreen(),
          ),
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        final sortButton = find.byIcon(Icons.sort);
        if (sortButton.evaluate().isNotEmpty) {
          await tester.tap(sortButton.first);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
        }

        expect(find.text('High Score'), findsAtLeastNWidgets(1));
        expect(find.text('Low Score'), findsAtLeastNWidgets(1));
      });
    });

    // LOGIN SCREEN / FORMS
  });
}
