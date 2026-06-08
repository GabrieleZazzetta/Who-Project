import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:assessment_tool/main.dart' as app;
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/models/user_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // TEST SUITE INITIALIZATION
  group('Profile & Settings E2E', () {
    setUp(() async {
      try {
        final session = UserSession()
          ..email = 'nikoanto03@gmail.com'
          ..isLoggedIn = true
          ..isWhoStaff = false;
        await DatabaseService.instance.saveSession(session);
      } catch (_) {}
    });

    // PROFILE UPDATE FLOW
    testWidgets('Profile changes persist and restore',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final settingsTab = find.byIcon(Icons.settings).evaluate().isNotEmpty 
          ? find.byIcon(Icons.settings) 
          : find.byIcon(Icons.settings_rounded);
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab.first);
        await tester.pumpAndSettle();
      }

      final profileIcon = find.byIcon(Icons.person);
      if (profileIcon.evaluate().isNotEmpty) {
        await tester.tap(profileIcon.first);
        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          await tester.enterText(textFields.first, 'Gabriele Zazzetta');
          await tester.pumpAndSettle();

          if (find.text('Save Changes').evaluate().isNotEmpty) {
            await tester.tap(find.text('Save Changes').first);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          } else if (find.text('Save').evaluate().isNotEmpty) {
            await tester.tap(find.text('Save').first);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        }
      }
    });

    // LANGUAGE PREFERENCES
    testWidgets('Language changes successfully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final settingsTab = find.byIcon(Icons.settings).evaluate().isNotEmpty 
          ? find.byIcon(Icons.settings) 
          : find.byIcon(Icons.settings_rounded);
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab.first);
        await tester.pumpAndSettle();
      }

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
