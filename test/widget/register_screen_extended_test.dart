import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assessment_tool/screens/register_screen.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/mocks.dart';

void main() {
  late MockAuthService mockAuth;

  setUpAll(() {
    mockAuth = MockAuthService();
  });

  Widget createProviderAppWithRouter(Widget home) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => home,
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Scaffold(body: Text('Login Screen')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuth),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  group('RegisterScreen Extended Tests', () {


    testWidgets('Firebase email-already-in-use shows error snackbar', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Configure mock to simulate Firebase email collision error
      when(() => mockAuth.register(any(), any(), isWhoStaff: any(named: 'isWhoStaff'), displayName: any(named: 'displayName')))
          .thenThrow(Exception('email-already-in-use'));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: RegisterScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Execute valid form submission
      await tester.enterText(find.byKey(const Key('input_firstname')), 'New');
      await tester.enterText(find.byKey(const Key('input_lastname')), 'User');
      await tester.enterText(find.byKey(const Key('input_email')), 'newuser@who.int');
      await tester.enterText(find.byKey(const Key('input_password')), 'StrongPass1!');
      
      final dateInput = find.byIcon(Icons.calendar_today_outlined);
      await tester.ensureVisible(dateInput);
      await tester.tap(dateInput);
      await tester.pump();
      await tester.tap(find.text('OK')); // Execute date selection
      await tester.pump();

      final registerBtn = find.byKey(const Key('btn_create_account'));
      await tester.ensureVisible(registerBtn);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(registerBtn);

      await tester.pump();
      // Validate snackbar rendering triggered by Firebase error
      await tester.pump(const Duration(milliseconds: 100)); // Wait for async execution
      await tester.pump(const Duration(milliseconds: 300)); // Validate snackbar rendering

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Register navigation attempts to go back to login', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: RegisterScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Execute navigation fallback to login screen
      final loginLink = find.byType(TextButton).last;
      await tester.ensureVisible(loginLink);
      await tester.pump(const Duration(milliseconds: 300));
      
      await tester.tap(loginLink);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      
      expect(find.text('Login Screen'), findsOneWidget); 
    });
  });
}
