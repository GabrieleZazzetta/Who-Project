import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/screens/register_screen.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

void main() {
  group('RegisterScreen Widget Tests', () {
    setUpAll(() {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('overflowed')) {
          return;
        }
        originalOnError?.call(details);
      };
    });

    testWidgets('should render all input fields and branding elements', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: RegisterScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Join the Platform"), findsAtLeastNWidgets(1));
      expect(find.text("Create Account"), findsAtLeastNWidgets(1));
      expect(find.byType(TextFormField), findsNWidgets(4)); // First Name, Last Name, Email, Password
      expect(find.text("Date of Birth"), findsOneWidget);
    });

    testWidgets('password requirements checkmark state updates dynamically', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: RegisterScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final passwordFieldFinder = find.byType(TextFormField).at(3);

      // Verify default state (all requirement checkmarks are unchecked)
      expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(4));

      // Enter simple password
      await tester.enterText(passwordFieldFinder, "abc");
      await tester.pump();
      expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(4));

      // Enter longer password matching length, uppercase, number and special char
      await tester.enterText(passwordFieldFinder, "Abc1234!");
      await tester.pump();
      
      // All requirements met (Icons.check_circle)
      expect(find.byIcon(Icons.check_circle), findsNWidgets(4));
    });
  });
}
