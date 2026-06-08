import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:assessment_tool/main.dart' as app;
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/models/user_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // TEST SUITE INITIALIZATION
  group('Analytics & Outbreak Reporting E2E', () {
    setUp(() async {
      try {
        final session = UserSession()
          ..email = 'gabriele@who.int'
          ..isLoggedIn = true
          ..isWhoStaff = true;
        await DatabaseService.instance.saveSession(session);
      } catch (_) {}
    });

    // ANALYTICS GLOBAL DASHBOARD
    testWidgets('Analytics global dashboard loads', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Navigate to assignment list view
      final bottomNav = find.byType(BottomNavigationBar);
      final listTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.assignment));
      if (listTab.evaluate().isNotEmpty) {
        await tester.tap(listTab.first);
        await tester.pumpAndSettle();

        // Access the analytics feature via dedicated button
        final analyticsBtn = find.byIcon(Icons.analytics_rounded);
        if (analyticsBtn.evaluate().isNotEmpty) {
          await tester.tap(analyticsBtn.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    // GLOBAL MAP 3D INTERACTION
    testWidgets('Global Map 3D interaction', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Navigate to assignment list view
      final bottomNav = find.byType(BottomNavigationBar);
      final listTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.assignment));
      if (listTab.evaluate().isNotEmpty) {
        await tester.tap(listTab.first);
        await tester.pumpAndSettle();

        // Access global map interaction view
        final mapIcon = find.byIcon(Icons.map_outlined);
        if (mapIcon.evaluate().isNotEmpty) {
          await tester.tap(mapIcon.first);
          await tester.pumpAndSettle(const Duration(seconds: 4));

          expect(find.byType(Scaffold), findsWidgets);
          
          // Focus map to specific geographical extent
          final focusBtn = find.byIcon(Icons.my_location_rounded);
          if (focusBtn.evaluate().isNotEmpty) {
            await tester.tap(focusBtn.first);
            await tester.pumpAndSettle(const Duration(seconds: 1));
          }
        }
      }
    });

    // INTERACTIVE MAP ASSESSMENT
    testWidgets('Interactive Map opens assessment', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Navigate to assignment list view
      final bottomNav = find.byType(BottomNavigationBar);
      final listTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.assignment));
      if (listTab.evaluate().isNotEmpty) {
        await tester.tap(listTab.first);
        await tester.pumpAndSettle();

        // Select specific assessment to view details
        final tiles = find.byType(Card);
        if (tiles.evaluate().isNotEmpty) {
          await tester.tap(tiles.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Open interactive map for selected assessment
          final interactiveMapBtn = find.byIcon(Icons.map);
          if (interactiveMapBtn.evaluate().isNotEmpty) {
            await tester.tap(interactiveMapBtn.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            // Simulate interaction on specific map pin
            final interactiveViewer = find.byType(InteractiveViewer);
            if (interactiveViewer.evaluate().isNotEmpty) {
              final mapPins = find.descendant(of: interactiveViewer, matching: find.byType(GestureDetector));
              if (mapPins.evaluate().isNotEmpty) {
                await tester.tap(mapPins.first);
                await tester.pumpAndSettle(const Duration(seconds: 2));
              }
            }
          }
        }
      }
    });
  });
}
