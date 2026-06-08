import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:assessment_tool/main.dart' as app;
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/models/user_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // TEST SUITE INITIALIZATION
  group('Assessment Operations E2E', () {
    setUp(() async {
      try {
        final session = UserSession()
          ..email = 'gabriele@who.int'
          ..isLoggedIn = true
          ..isWhoStaff = true;
        await DatabaseService.instance.saveSession(session);
      } catch (_) {}
    });

    // ASSESSMENT CREATION FLOW
    testWidgets('Assessment add item (Start Pre-Assessment)', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Select an active emergency from dashboard
      final cards = find.byType(Card);
      if (cards.evaluate().isNotEmpty) {
        await tester.tap(cards.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Choose specific facility type for assessment
        final facilityCards = find.byType(Card);
        if (facilityCards.evaluate().isNotEmpty) {
          await tester.tap(facilityCards.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Populate pre-assessment facility details form
          final textFields = find.byType(TextFormField);
          if (textFields.evaluate().isNotEmpty) {
            await tester.enterText(textFields.first, 'Test E2E Facility');
            await tester.pumpAndSettle();
            
            // Confirm and proceed to main assessment
            final submitButton = find.byType(ElevatedButton);
            if (submitButton.evaluate().isNotEmpty) {
              await tester.tap(submitButton.last);
              await tester.pumpAndSettle(const Duration(seconds: 2));
            }
          }
        }
      }
    });

    // COMPLIANCE STATUS UPDATE
    testWidgets('Assessment compliance change', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Navigate to assessment list view
      final bottomNav = find.byType(BottomNavigationBar);
      final listTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.assignment));
      if (listTab.evaluate().isNotEmpty) {
        await tester.tap(listTab.first);
        await tester.pumpAndSettle();

        // Select an ongoing assessment
        final tiles = find.byType(Card);
        if (tiles.evaluate().isNotEmpty) {
          await tester.tap(tiles.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Access specific zone within the assessment
          final zoneCards = find.byType(Card);
          if (zoneCards.evaluate().isNotEmpty) {
            await tester.tap(zoneCards.first);
            await tester.pumpAndSettle(const Duration(seconds: 2));
            
            // Toggle compliance status for a question
            final complianceBtn = find.byIcon(Icons.check_circle_outline);
            if (complianceBtn.evaluate().isNotEmpty) {
              await tester.tap(complianceBtn.first);
              await tester.pumpAndSettle(const Duration(seconds: 1));
            }
          }
        }
      }
    });

    // MEDIA ACQUISITION FLOW
    testWidgets('Camera flow acquisition', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Navigate to assessment list view
      final bottomNav = find.byType(BottomNavigationBar);
      final listTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.assignment));
      if (listTab.evaluate().isNotEmpty) {
        await tester.tap(listTab.first);
        await tester.pumpAndSettle();

        // Select an ongoing assessment
        final tiles = find.byType(Card);
        if (tiles.evaluate().isNotEmpty) {
          await tester.tap(tiles.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Access specific zone within the assessment
          final zoneCards = find.byType(Card);
          if (zoneCards.evaluate().isNotEmpty) {
            await tester.tap(zoneCards.first);
            await tester.pumpAndSettle(const Duration(seconds: 2));
            
            // Trigger camera acquisition flow from a question
            final cameraBtn = find.byIcon(Icons.camera_alt_outlined);
            if (cameraBtn.evaluate().isNotEmpty) {
              await tester.tap(cameraBtn.first);
              await tester.pumpAndSettle(const Duration(seconds: 2));
              
              // Validate camera UI or permission dialog appearance
              expect(find.byType(Dialog).evaluate().isNotEmpty || find.byIcon(Icons.camera).evaluate().isNotEmpty || find.byIcon(Icons.photo_library).evaluate().isNotEmpty, isTrue);
              
              // Dismiss potential permission dialog to unblock subsequent tests
              if (find.text('Cancel').evaluate().isNotEmpty) {
                await tester.tap(find.text('Cancel').first);
                await tester.pumpAndSettle();
              }
            }
          }
        }
      }
    });

    // ASSESSMENT DELETION FLOW
    testWidgets('Delete Assessment', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final bottomNav = find.byType(BottomNavigationBar);
      final listTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.assignment));
      if (listTab.evaluate().isNotEmpty) {
        await tester.tap(listTab.first);
        await tester.pumpAndSettle();

        final deleteBtn = find.byIcon(Icons.delete_outline);
        if (deleteBtn.evaluate().isNotEmpty) {
          await tester.tap(deleteBtn.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          final confirmBtn = find.text('Delete');
          if (confirmBtn.evaluate().isNotEmpty) {
            await tester.tap(confirmBtn.last);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        }
      }
    });
  });
}
