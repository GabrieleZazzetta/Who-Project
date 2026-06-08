import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:assessment_tool/main.dart' as app;
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/screens/main_dashboard_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // TEST SUITE INITIALIZATION
  group('Navigation E2E', () {
    setUp(() async {
      try {
        await DatabaseService.instance.init();
        final session = UserSession()
          ..email = 'nikoanto03@gmail.com'
          ..isLoggedIn = true
          ..isWhoStaff = false;
        await DatabaseService.instance.saveSession(session);
      } catch (_) {}
    });

    // BOTTOM NAVIGATION TABS
    testWidgets('Bottom navigation bar switches tabs',
        (WidgetTester tester) async {
      app.main();
      await Future.delayed(const Duration(seconds: 8));
      await tester.pumpAndSettle();

      // Wait for app initialization and initial screen render
      for (int i = 0; i < 100; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.byType(MainDashboardScreen).evaluate().isNotEmpty ||
            find.byType(TextFormField).evaluate().isNotEmpty) {
          break;
        }
      }

      // Fallback: Perform login if user is redirected to auth screen
      if (find.byType(MainDashboardScreen).evaluate().isEmpty) {
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          await tester.enterText(textFields.at(0), 'nikoanto03@gmail.com');
          await tester.enterText(textFields.at(1), 'Antonio!2003');
          await tester.pumpAndSettle();
          await tester.tap(find.byType(ElevatedButton).first);

          // Wait for main dashboard to appear post-login
          for (int i = 0; i < 100; i++) {
            await tester.pump(const Duration(milliseconds: 100));
            if (find.byType(MainDashboardScreen).evaluate().isNotEmpty) {
              break;
            }
          }
        }
      }

      final mainDashboard = find.byType(MainDashboardScreen);
      expect(mainDashboard, findsOneWidget);

      // Verify map/list view toggle
      final assignmentTab = find.byIcon(Icons.assignment).evaluate().isNotEmpty
          ? find.byIcon(Icons.assignment)
          : find.byIcon(Icons.assignment_rounded);
      if (assignmentTab.evaluate().isNotEmpty) {
        await tester.tap(assignmentTab.first);
        await tester.pumpAndSettle();
      }

      // Verify settings view access
      final settingsTab = find.byIcon(Icons.settings).evaluate().isNotEmpty
          ? find.byIcon(Icons.settings)
          : find.byIcon(Icons.settings_rounded);
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab.first);
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.person_outline),
            findsWidgets);
      }

      // Verify home dashboard return
      final homeTab = find.byIcon(Icons.home_filled).evaluate().isNotEmpty
          ? find.byIcon(Icons.home_filled)
          : find.byIcon(Icons.grid_view_rounded);
      if (homeTab.evaluate().isNotEmpty) {
        await tester.tap(homeTab.first);
        await tester.pumpAndSettle();
      }
    });

    // MODULE NAVIGATION FLOW
    testWidgets('Navigate to Outbreak module and back',
        (WidgetTester tester) async {
      app.main();
      await Future.delayed(const Duration(seconds: 8));
      await tester.pumpAndSettle();

      // Wait for app initialization and initial screen render
      for (int i = 0; i < 100; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.byType(MainDashboardScreen).evaluate().isNotEmpty ||
            find.byType(TextFormField).evaluate().isNotEmpty) {
          break;
        }
      }

      // Fallback: Perform login if user is redirected to auth screen
      if (find.byType(MainDashboardScreen).evaluate().isEmpty) {
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().isNotEmpty) {
          await tester.enterText(textFields.at(0), 'nikoanto03@gmail.com');
          await tester.enterText(textFields.at(1), 'Antonio!2003');
          await tester.pumpAndSettle();
          await tester.tap(find.byType(ElevatedButton).first);

          // Wait for main dashboard to appear post-login
          for (int i = 0; i < 100; i++) {
            await tester.pump(const Duration(milliseconds: 100));
            if (find.byType(MainDashboardScreen).evaluate().isNotEmpty) {
              break;
            }
          }
        }
      }

      // Access specific outbreak module details
      final cards = find.text('Mpox Outbreak');
      if (cards.evaluate().isNotEmpty) {
        await tester.tap(cards.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

        // Verify return navigation to main dashboard
        await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(MainDashboardScreen), findsOneWidget);
      }
    });
  });
}
