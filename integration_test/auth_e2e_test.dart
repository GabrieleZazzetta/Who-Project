import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:assessment_tool/main.dart' as app;
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/screens/main_dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication E2E', () {
    setUp(() async {
      try {
        await DatabaseService.instance.clearSession();
      } catch (_) {}
    });

    testWidgets('Login fails with wrong credentials',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      expect(find.byType(TextFormField), findsWidgets);

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'invalid@who.int');
      await tester.enterText(textFields.at(1), 'wrongpassword');
      await tester.pumpAndSettle();

      final loginButton = find.byType(ElevatedButton).first;
      await tester.tap(loginButton);

      // Aspetta che l'autenticazione fallisca e appaia la SnackBar (max 5 secondi)
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.byType(SnackBar).evaluate().isNotEmpty) {
          break;
        }
      }

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Login succeeds with correct credentials',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Crea l'utente nel test per evitare l'errore "invalid-credential"
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: 'nikoanto03@gmail.com', password: 'Antonio!2003');
        // Effettua subito il logout per poi testare il flusso UI di login
        await FirebaseAuth.instance.signOut();
      } catch (_) {}

      // Seleziona il tab External Partner
      final externalPartnerToggle =
          find.byKey(const Key('toggle_external_partner'));
      await tester.tap(externalPartnerToggle);
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'nikoanto03@gmail.com');
      await tester.enterText(textFields.at(1), 'Antonio!2003');
      await tester.pumpAndSettle();

      final loginButton = find.byType(ElevatedButton).first;
      await tester.tap(loginButton);

      // Wait for navigation or SnackBar (max 10 seconds)
      for (int i = 0; i < 100; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.byType(MainDashboardScreen).evaluate().isNotEmpty ||
            find.byType(SnackBar).evaluate().isNotEmpty) {
          break;
        }
      }

      if (find.byType(SnackBar).evaluate().isNotEmpty) {
        final snackBarText = find.descendant(
            of: find.byType(SnackBar), matching: find.byType(Text));
        if (snackBarText.evaluate().isNotEmpty) {
          final textWidget = tester.widget<Text>(snackBarText.first);
          debugPrint("!!! LOGIN ERROR IN TEST: ${textWidget.data} !!!");
        }
      }

      expect(find.byType(MainDashboardScreen), findsOneWidget);
    });

    testWidgets('Toggle password visibility', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final offIcon = find.byIcon(Icons.visibility_off);
      final onIcon = find.byIcon(Icons.visibility);

      if (offIcon.evaluate().isNotEmpty) {
        await tester.tap(offIcon.first);
        await tester.pumpAndSettle();
      } else if (onIcon.evaluate().isNotEmpty) {
        await tester.tap(onIcon.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Logs out after successful Login', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      if (find.byType(MainDashboardScreen).evaluate().isEmpty) {
        // Crea l'utente anche qui per sicurezza
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: 'nikoanto03@gmail.com', password: 'Antonio!2003');
          await FirebaseAuth.instance.signOut();
        } catch (_) {}

        final externalPartnerToggle =
            find.byKey(const Key('toggle_external_partner'));
        await tester.tap(externalPartnerToggle);
        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), 'nikoanto03@gmail.com');
        await tester.enterText(textFields.at(1), 'Antonio!2003');
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ElevatedButton).first);

        for (int i = 0; i < 100; i++) {
          await tester.pump(const Duration(milliseconds: 100));
          if (find.byType(MainDashboardScreen).evaluate().isNotEmpty) {
            break;
          }
        }
      }

      final settingsTab = find.byIcon(Icons.settings).evaluate().isNotEmpty 
          ? find.byIcon(Icons.settings) 
          : find.byIcon(Icons.settings_rounded);
      await tester.tap(settingsTab.first);
      await tester.pumpAndSettle();

      // Scroll to the bottom of the SettingsScreen to reveal the logout button
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -1000));
      await tester.pumpAndSettle();

      final iconLogout = find.byIcon(Icons.logout).evaluate().isNotEmpty 
          ? find.byIcon(Icons.logout) 
          : find.byIcon(Icons.logout_rounded);
      final textLogout = find.text('Log Out');

      if (iconLogout.evaluate().isNotEmpty) {
        await tester.tap(iconLogout.first);
      } else if (textLogout.evaluate().isNotEmpty) {
        await tester.tap(textLogout.first);
      }
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final confirmText = find.text('Confirm');
      final yesText = find.text('Yes');
      if (confirmText.evaluate().isNotEmpty) {
        await tester.tap(confirmText.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      } else if (yesText.evaluate().isNotEmpty) {
        await tester.tap(yesText.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      expect(find.byType(TextFormField), findsWidgets);
    });
  });
}
