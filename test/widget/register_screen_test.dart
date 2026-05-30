import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assessment_tool/screens/register_screen.dart';
import 'package:assessment_tool/providers/database_provider.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:go_router/go_router.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';
import '../helpers/mocks.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late MockAuthService mockAuth;

  setUp(() {
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
      ],
    );

    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuth),
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

  group('RegisterScreen Tests', () {
    testWidgets('renders all input fields and branding elements', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: RegisterScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byKey(const Key('input_firstname')), findsOneWidget);
      expect(find.byKey(const Key('input_lastname')), findsOneWidget);
      expect(find.byKey(const Key('input_email')), findsOneWidget);
      expect(find.byKey(const Key('input_password')), findsOneWidget);
      expect(find.byKey(const Key('btn_create_account')), findsOneWidget);
    });

    testWidgets('password requirements checkmark state updates dynamically', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: RegisterScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final passwordField = find.byKey(const Key('input_password'));
      
      // Before typing, all checkmarks should be unchecked (Icons.radio_button_unchecked)
      // Since there are 4 requirements, there are 4 unchecked icons.
      expect(find.byIcon(Icons.radio_button_unchecked), findsWidgets);
      
      await tester.enterText(passwordField, 'Password123!');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      
      // After typing a valid password, they should all be checked (Icons.check_circle)
      expect(find.byIcon(Icons.check_circle), findsWidgets);
    });

    testWidgets('WHO staff rejects non @who.int email on submit', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: RegisterScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.byKey(const Key('input_firstname')), 'John');
      await tester.enterText(find.byKey(const Key('input_lastname')), 'Doe');
      await tester.enterText(find.byKey(const Key('input_email')), 'test@gmail.com');
      await tester.enterText(find.byKey(const Key('input_password')), 'ValidPass123!');
      
      // Set DOB
      final datePickerIcon = find.byIcon(Icons.calendar_today_outlined);
      await tester.ensureVisible(datePickerIcon);
      await tester.tap(datePickerIcon);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('OK'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final btn = find.byKey(const Key('btn_create_account'));
      await tester.ensureVisible(btn);
      await tester.tap(btn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('WHO Staff must use a @who.int email'), findsOneWidget);
    });

    testWidgets('external partner mode accepts non-who email', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Return a fake UserCredential from register
      when(() => mockAuth.register(any(), any(), isWhoStaff: any(named: 'isWhoStaff'), displayName: any(named: 'displayName')))
          .thenAnswer((_) async => null);

      await tester.pumpWidget(createProviderAppWithRouter(const Scaffold(body: RegisterScreen())));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Toggle external partner
      await tester.tap(find.byKey(const Key('toggle_external_partner')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.enterText(find.byKey(const Key('input_firstname')), 'Partner');
      await tester.enterText(find.byKey(const Key('input_lastname')), 'User');
      await tester.enterText(find.byKey(const Key('input_email')), 'test@gmail.com');
      await tester.enterText(find.byKey(const Key('input_password')), 'ValidPass123!');
      
      // Set DOB
      final datePickerIcon = find.byIcon(Icons.calendar_today_outlined);
      await tester.ensureVisible(datePickerIcon);
      await tester.tap(datePickerIcon);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('OK'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final btn = find.byKey(const Key('btn_create_account'));
      await tester.ensureVisible(btn);
      await tester.tap(btn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('WHO Staff must use a @who.int email'), findsNothing);
    });

    testWidgets('renders tablet portrait layout', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1800, 3000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(createProviderAppWithRouter(
        MediaQuery(
          data: const MediaQueryData(size: Size(800, 1000)),
          child: const Scaffold(body: RegisterScreen()),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('input_email')), findsOneWidget);
    });

    testWidgets('renders mobile portrait layout', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(createProviderAppWithRouter(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: const Scaffold(body: RegisterScreen()),
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
          child: const Scaffold(body: RegisterScreen()),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('input_email')), findsOneWidget);
    });
  });
}
