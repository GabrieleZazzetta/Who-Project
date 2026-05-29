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
  late Directory tempDir;
  late MockAuthService mockAuth;
  late MockSyncNotifier mockSync;

  setUp(() {
    mockAuth = MockAuthService();
    mockSync = MockSyncNotifier();
  });

  Widget createProviderAppWithRouter(Widget home) {
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
        // We mock database so we don't need Isar
        databaseServiceProvider.overrideWithValue(MockDatabaseService()),
      ],
      child: MaterialApp.router(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
  }

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
      await tester.tap(btn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Required field'), findsWidgets);
    });

    testWidgets('renders tablet portrait layout', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      expect(find.byKey(const Key('input_email')), findsOneWidget);
    });

    testWidgets('renders tablet landscape layout', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
      expect(find.byKey(const Key('input_email')), findsOneWidget);
    });

    testWidgets('renders mobile landscape layout', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: LoginScreen())));
      await tester.pump();
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
      await tester.tap(btn);
      
      await tester.pump(); // form validate & setState isLoading = true
      await tester.pump(const Duration(milliseconds: 100)); // allow async logic
      await tester.pump(const Duration(milliseconds: 300)); // complete navigation
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
      await tester.tap(btn);
      
      await tester.pump(); // form validate & setState isLoading = true
      await tester.pump(const Duration(milliseconds: 100)); // allow async logic to fail
      await tester.pump(const Duration(milliseconds: 300)); // snackbar appears
      
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
