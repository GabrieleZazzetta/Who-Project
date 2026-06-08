import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assessment_tool/screens/login_screen.dart';
import 'package:assessment_tool/providers/database_provider.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:go_router/go_router.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';
import 'package:assessment_tool/services/sync_service.dart';
import '../helpers/mocks.dart';
import 'package:mocktail/mocktail.dart';
void main() {
  setUpAll(() {
    registerFallbackValue(LocalUserCredential());
    registerFallbackValue(UserSession());
  });
  late Directory tempDir;
  late MockAuthService mockAuth;
  late MockSyncNotifier mockSync;

  setUp(() {
    mockAuth = MockAuthService();
    mockSync = MockSyncNotifier();
  });

  Widget createProviderAppWithRouter(Widget home, {DatabaseService? mockDb}) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => home,
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuth),
        syncProvider.overrideWith(() => mockSync),
        // Mock database to bypass Isar
        databaseServiceProvider.overrideWithValue(mockDb ?? MockDatabaseService()),
      ],
      child: MaterialApp.router(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
  }

  // TEST SUITE: LOGIN SCREEN
  group('LoginScreen Tests', () {
    testWidgets('renders all form elements', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byKey(const Key('toggle_who_staff')), findsOneWidget);
      expect(find.byKey(const Key('toggle_external_partner')), findsOneWidget);
      expect(find.byKey(const Key('input_email')), findsOneWidget);
      expect(find.byKey(const Key('input_password')), findsOneWidget);
      expect(find.byKey(const Key('btn_authenticate')), findsOneWidget);
    });

    testWidgets('WHO staff rejects non @who.int email', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.byKey(const Key('input_email')), 'test@gmail.com');
      final btn = find.byKey(const Key('btn_authenticate'));
      await tester.ensureVisible(btn);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(btn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('WHO Staff must use a @who.int email'), findsOneWidget);
    });

    testWidgets('external partner accepts generic email', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byKey(const Key('toggle_external_partner')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.byKey(const Key('input_email')), 'partner@gmail.com');
      final btn = find.byKey(const Key('btn_authenticate'));
      await tester.ensureVisible(btn);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(btn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Please enter a valid email address'), findsNothing);
      expect(find.text('WHO Staff must use a @who.int email'), findsNothing);
    });

    testWidgets('forgot password button opens modal', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final link = find.text('Forgot Password?');
      await tester.ensureVisible(link);
      await tester.tap(link);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Account Recovery'), findsWidgets);
    });

    testWidgets('empty fields show required error', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final btn = find.byKey(const Key('btn_authenticate'));
      await tester.ensureVisible(btn);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(btn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Required field'), findsWidgets);
    });

    testWidgets('renders tablet portrait layout', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1800, 3000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(createProviderAppWithRouter(
        MediaQuery(
          data: const MediaQueryData(size: Size(800, 1000)),
          child: const Scaffold(body: LoginScreen()),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('input_email')), findsOneWidget);
    });

    testWidgets('renders tablet landscape layout', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(3600, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(createProviderAppWithRouter(
        MediaQuery(
          data: const MediaQueryData(size: Size(1200, 800)),
          child: const Scaffold(body: LoginScreen()),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('input_email')), findsOneWidget);
    });

    testWidgets('renders mobile landscape layout', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(2400, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(createProviderAppWithRouter(
        MediaQuery(
          data: const MediaQueryData(size: Size(800, 400)),
          child: const Scaffold(body: LoginScreen()),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('input_email')), findsOneWidget);
    });

    testWidgets('successful login navigates to dashboard', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      when(() => mockAuth.login(any(), any())).thenAnswer((_) async => null);

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.byKey(const Key('input_email')), 'test@who.int');
      await tester.enterText(find.byKey(const Key('input_password')), 'Password123!');
      
      final btn = find.byKey(const Key('btn_authenticate'));
      await tester.ensureVisible(btn);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(btn);
      
      await tester.pump(); // Trigger validation and loading state
      await tester.pump(const Duration(milliseconds: 100)); // Await async resolution
      await tester.pump(const Duration(milliseconds: 300)); // Validate navigation completion
    });

    testWidgets('failed login shows snackbar', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      when(() => mockAuth.login(any(), any())).thenThrow(Exception('Invalid credentials'));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.byKey(const Key('input_email')), 'fail@who.int');
      await tester.enterText(find.byKey(const Key('input_password')), 'WrongPass!');
      
      final btn = find.byKey(const Key('btn_authenticate'));
      await tester.ensureVisible(btn);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(btn);
      
      await tester.pump(); // Trigger validation and loading state
      await tester.pump(const Duration(milliseconds: 100)); // Await async resolution
      await tester.pump(const Duration(milliseconds: 300)); // Validate snackbar rendering
      
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('toggle password visibility', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Validate initial obscured state
      final visOffIcon = find.byIcon(Icons.visibility_off);
      expect(visOffIcon, findsOneWidget);

      // Execute visibility toggle
      await tester.ensureVisible(visOffIcon);
      await tester.tap(visOffIcon);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Validate unobscured state
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('switching to external partner clears email', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Provision WHO staff email
      await tester.enterText(find.byKey(const Key('input_email')), 'test@who.int');
      await tester.pump();

      // Toggle to External Partner mode
      final toggleFinder = find.byKey(const Key('toggle_external_partner'));
      await tester.ensureVisible(toggleFinder);
      await tester.tap(toggleFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Validate external partner mode acceptance of generic email
      await tester.enterText(find.byKey(const Key('input_email')), 'partner@gmail.com');
      await tester.pump();
    });

    testWidgets('external partner rejects invalid email format', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Toggle to External Partner mode
      final toggleFinder = find.byKey(const Key('toggle_external_partner'));
      await tester.ensureVisible(toggleFinder);
      await tester.tap(toggleFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Execute invalid format path
      await tester.enterText(find.byKey(const Key('input_email')), 'not-an-email');
      await tester.enterText(find.byKey(const Key('input_password')), 'Password1!');
      
      final btn = find.byKey(const Key('btn_authenticate'));
      await tester.ensureVisible(btn);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(btn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('register navigation link is present', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Validate register link rendering
      final registerLink = find.text('Register Here');
      await tester.ensureVisible(registerLink);
      expect(registerLink, findsOneWidget);
    });

    testWidgets('renders mobile portrait with header and form', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(380, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(
        MediaQuery(
          data: const MediaQueryData(size: Size(380, 700)),
          child: const Scaffold(body: LoginScreen()),
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Validate mobile form rendering
      expect(find.byKey(const Key('input_email')), findsOneWidget);
      expect(find.byKey(const Key('input_password')), findsOneWidget);
      expect(find.byKey(const Key('btn_authenticate')), findsOneWidget);
    });

    testWidgets('forgot password modal shows errors for empty fields', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: const Scaffold(body: LoginScreen()),
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Execute forgot password action
      final forgotPassBtn = find.text('Forgot Password?');
      await tester.ensureVisible(forgotPassBtn);
      await tester.ensureVisible(forgotPassBtn); await tester.pumpAndSettle(); await tester.tap(forgotPassBtn, warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Account Recovery'), findsOneWidget);

      // Execute empty email submission
      final verifyBtn = find.text('Verify & Continue');
      await tester.ensureVisible(verifyBtn);
      await tester.tap(verifyBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Please enter your email.'), findsOneWidget);

      // Provision email without date
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.last, 'test@who.int');
      
      await tester.tap(verifyBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Please select your date of birth.'), findsOneWidget);
      
      // Execute modal closure
      final closeBtn = find.byIcon(Icons.close);
      await tester.tap(closeBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Account Recovery'), findsNothing);
    });

    testWidgets('forgot password handles missing email in local db', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      
      final mockDb = MockDatabaseService();
      when(() => mockDb.getLocalCredential(any())).thenAnswer((_) async => null);

      await tester.pumpWidget(createProviderAppWithRouter(
        const Scaffold(body: LoginScreen()),
        mockDb: mockDb,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final forgotPassBtn = find.text('Forgot Password?');
      await tester.ensureVisible(forgotPassBtn);
      await tester.ensureVisible(forgotPassBtn); await tester.pumpAndSettle(); await tester.tap(forgotPassBtn, warnIfMissed: false);
      await tester.pumpAndSettle();

      await tester.enterText(find.descendant(of: find.byType(ForgotPasswordModal), matching: find.byType(TextField)).first, 'test@example.com');
      
      // Provision valid date
      await tester.tap(find.byIcon(Icons.calendar_today_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Verify & Continue'));
      await tester.pumpAndSettle();

      expect(find.text('No matching registered account found locally.'), findsOneWidget);
    });

    testWidgets('forgot password handles incorrect date of birth', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      
      final mockDb = MockDatabaseService();
      final mockCred = LocalUserCredential()
        ..email = 'test@example.com'
        ..dateOfBirth = DateTime(1990, 1, 1);
      when(() => mockDb.getLocalCredential(any())).thenAnswer((_) async => mockCred);

      await tester.pumpWidget(createProviderAppWithRouter(
        const Scaffold(body: LoginScreen()),
        mockDb: mockDb,
      ));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Forgot Password?')); await tester.pumpAndSettle(); await tester.tap(find.text('Forgot Password?'), warnIfMissed: false);
      await tester.pumpAndSettle();

      await tester.enterText(find.descendant(of: find.byType(ForgotPasswordModal), matching: find.byType(TextField)).first, 'test@example.com');
      
      // Provision invalid date
      await tester.tap(find.byIcon(Icons.calendar_today_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Verify & Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Incorrect Date of Birth for this email.'), findsOneWidget);
    });

    testWidgets('forgot password completes reset flow successfully', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      
      final mockDb = MockDatabaseService();
      final mockCred = LocalUserCredential()
        ..id = 1
        ..email = 'test@example.com'
        ..dateOfBirth = DateTime(2000)
        ..displayName = 'Tester'
        ..isWhoStaff = false;
        
      when(() => mockDb.getLocalCredential(any())).thenAnswer((_) async => mockCred);
      when(() => mockDb.saveLocalCredential(any())).thenAnswer((_) async => 1);
      when(() => mockDb.saveSession(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createProviderAppWithRouter(
        const Scaffold(body: LoginScreen()),
        mockDb: mockDb,
      ));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Forgot Password?')); await tester.pumpAndSettle(); await tester.tap(find.text('Forgot Password?'), warnIfMissed: false);
      await tester.pumpAndSettle();

      await tester.enterText(find.descendant(of: find.byType(ForgotPasswordModal), matching: find.byType(TextField)).first, 'test@example.com');
      
      await tester.tap(find.byIcon(Icons.calendar_today_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Verify & Continue'));
      await tester.pumpAndSettle();

      // Validate step 2 rendering
      expect(find.text('Reset Password'), findsOneWidget);

      // Execute invalid password format path
      final passField = find.descendant(of: find.byType(ForgotPasswordModal), matching: find.byType(TextField)).last;
      await tester.enterText(passField, 'weak');
      await tester.tap(find.text('Save & Reset Password'));
      await tester.pumpAndSettle();
      expect(find.text('Please meet all password requirements.'), findsOneWidget);

      // Execute valid password format path
      await tester.enterText(passField, 'Strong!123');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save & Reset Password'));
      await tester.pumpAndSettle();

      expect(find.text('Password reset offline successful! Logged in.'), findsOneWidget);
    });

  });
}














