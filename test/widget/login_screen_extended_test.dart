import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assessment_tool/screens/login_screen.dart';
import 'package:assessment_tool/providers/database_provider.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:assessment_tool/services/sync_service.dart';
import '../helpers/mocks.dart';

void main() {
  late MockAuthService mockAuth;
  late MockSyncNotifier mockSync;

  setUp(() {
    mockAuth = MockAuthService();
    mockSync = MockSyncNotifier();
  });

  Widget createTestWidget(Widget home) {
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
        databaseServiceProvider.overrideWithValue(MockDatabaseService()),
        authServiceProvider.overrideWithValue(mockAuth),
        syncProvider.overrideWith(() => mockSync),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  group('LoginScreen Extended Tests', () {
    testWidgets('renders desktop layout using MediaQuery override', (tester) async {
      final desktopMediaQuery = const MediaQueryData(
        size: Size(1200, 800),
        devicePixelRatio: 1.0,
      );

      await tester.pumpWidget(createTestWidget(
        MediaQuery(
          data: desktopMediaQuery,
          child: const LoginScreen(),
        ),
      ));

      await tester.pump(const Duration(milliseconds: 300));
      // Should find the text form fields
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('renders mobile landscape layout using MediaQuery override', (tester) async {
      final mobileLandscapeMediaQuery = const MediaQueryData(
        size: Size(800, 360), // Width > height for landscape
        devicePixelRatio: 1.0,
      );

      await tester.pumpWidget(createTestWidget(
        MediaQuery(
          data: mobileLandscapeMediaQuery,
          child: const LoginScreen(),
        ),
      ));

      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('Forgot Password modal submit and cancel buttons', (tester) async {
      final mobileMediaQuery = const MediaQueryData(
        size: Size(400, 1200), // very tall to avoid scroll issues in modal
        devicePixelRatio: 1.0,
      );

      await tester.pumpWidget(createTestWidget(
        MediaQuery(
          data: mobileMediaQuery,
          child: const LoginScreen(),
        ),
      ));

      await tester.pump(const Duration(milliseconds: 300));

      // Scroll to forgot password button
      final forgotPasswordButton = find.text('Forgot Password?');
      await tester.ensureVisible(forgotPasswordButton);
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(forgotPasswordButton);
      await tester.pump(const Duration(milliseconds: 500)); // wait for bottom sheet animation

      expect(find.text('Account Recovery'), findsOneWidget);

      // Tap Verify & Continue to trigger email validation
      final verifyButton = find.text('Verify & Continue');
      await tester.ensureVisible(verifyButton);
      await tester.tap(verifyButton, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 300));

      // Enter email
      await tester.enterText(find.byType(TextFormField).last, 'test@who.int');
      await tester.pump(const Duration(milliseconds: 300));

      // Tap Verify & Continue to trigger DOB validation
      await tester.tap(verifyButton, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 300)); 

      // Close it using the close icon
      final closeButton = find.byIcon(Icons.close);
      await tester.ensureVisible(closeButton);
      await tester.tap(closeButton, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 500)); // wait for bottom sheet close
    });
  });
}
