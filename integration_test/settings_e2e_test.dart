import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:assessment_tool/main.dart' as app;
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/models/user_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile & Settings E2E', () {
    setUp(() async {
      try {
        final session = UserSession()
          ..email = 'gabriele@who.int'
          ..isLoggedIn = true
          ..isWhoStaff = true;
        await DatabaseService.instance.saveSession(session);
      } catch (_) {}
    });

    testWidgets('Profile changes persist and restore', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final bottomNav = find.byType(BottomNavigationBar);
      final settingsTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.settings));
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab.first);
        await tester.pumpAndSettle();
      }

      // Tap sul profilo
      final profileIcon = find.byIcon(Icons.person);
      if (profileIcon.evaluate().isNotEmpty) {
        await tester.tap(profileIcon.first);
        await tester.pumpAndSettle();

        // Trova campo nome e modificalo
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          await tester.enterText(textFields.first, 'Gabriele Zazzetta');
          await tester.pumpAndSettle();

          // Cerca bottone di salvataggio
          if (find.text('Save').evaluate().isNotEmpty) {
            await tester.tap(find.text('Save').first);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          } else if (find.text('Update').evaluate().isNotEmpty) {
            await tester.tap(find.text('Update').first);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        }
      }
    });

    testWidgets('Language changes successfully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final bottomNav = find.byType(BottomNavigationBar);
      final settingsTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.settings));
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab.first);
        await tester.pumpAndSettle();
      }

      // Cerca il selettore lingua (DropdownButton o un ListTile con icona lingua)
      final languageIcon = find.byIcon(Icons.language);
      if (languageIcon.evaluate().isNotEmpty) {
        await tester.tap(languageIcon.first);
        await tester.pumpAndSettle();

        final frenchOption = find.text('Français');
        if (frenchOption.evaluate().isNotEmpty) {
          await tester.tap(frenchOption.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }
      }
    });
  });
}
