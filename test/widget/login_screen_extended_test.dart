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
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/mocks.dart';

void main() {
  late MockAuthService mockAuth;
  late MockSyncNotifier mockSync;
  late MockDatabaseService mockDb;

  setUp(() {
    mockAuth = MockAuthService();
    mockSync = MockSyncNotifier();
    mockDb = MockDatabaseService();
    registerFallbackValues();
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
        databaseServiceProvider.overrideWithValue(mockDb),
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

    testWidgets('Forgot Password modal step 1 and step 2 navigation', (tester) async {
      // Mock db response for _verifyIdentity
      when(() => mockDb.getLocalCredential(any())).thenAnswer((_) async {
        return LocalUserCredential()
          ..email = 'test@who.int'
          ..dateOfBirth = DateTime(2000)
          ..passwordHash = 'hash';
      });

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

      // Enter email
      final emailField = find.descendant(
        of: find.byType(Container),
        matching: find.byType(TextField),
      ).first;
      await tester.enterText(emailField, 'test@who.int');
      
      // Tap Date picker
      final dobField = find.byIcon(Icons.calendar_today_outlined);
      await tester.ensureVisible(dobField);
      await tester.pumpAndSettle();
      await tester.tap(dobField, warnIfMissed: false);
      await tester.pumpAndSettle();
      
      // Pick date
      await tester.tap(find.text('OK'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Tap Verify & Continue to trigger _verifyIdentity()
      final verifyButton = find.text('Verify & Continue');
      await tester.ensureVisible(verifyButton);
      await tester.tap(verifyButton, warnIfMissed: false);
      
      // Pump to let async mock resolve
      await tester.pump();
      // Pump to let the widget rebuild (switching to step 2)
      await tester.pump(const Duration(milliseconds: 500)); 

      // Should now see the new password input (Step 2)
      expect(find.text('New WIMS Password'), findsOneWidget);
      expect(find.text('Password must contain:'), findsOneWidget);
      expect(find.text('Reset Password'), findsWidgets); // Either app bar or button
    });
  });
}
