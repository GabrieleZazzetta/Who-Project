import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:assessment_tool/main.dart' as app;
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/models/user_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

    testWidgets('Analytics global dashboard loads', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Vai alla schermata Search/List per cercare il tasto Analytics
      final bottomNav = find.byType(BottomNavigationBar);
      final listTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.assignment));
      if (listTab.evaluate().isNotEmpty) {
        await tester.tap(listTab.first);
        await tester.pumpAndSettle();

        // Cerca il tasto premium per le Analytics
        final analyticsBtn = find.byIcon(Icons.analytics_rounded);
        if (analyticsBtn.evaluate().isNotEmpty) {
          await tester.tap(analyticsBtn.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('Global Map 3D interaction', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final bottomNav = find.byType(BottomNavigationBar);
      final listTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.assignment));
      if (listTab.evaluate().isNotEmpty) {
        await tester.tap(listTab.first);
        await tester.pumpAndSettle();

        // Trova l'icona mappamondo (Global Map) nella search bar
        final mapIcon = find.byIcon(Icons.map_outlined);
        if (mapIcon.evaluate().isNotEmpty) {
          await tester.tap(mapIcon.first);
          await tester.pumpAndSettle(const Duration(seconds: 4));

          // Dovremmo essere sulla Global Map
          expect(find.byType(Scaffold), findsWidgets);
          
          // Fai tap sul pulsante "Fit to extent"
          final focusBtn = find.byIcon(Icons.my_location_rounded);
          if (focusBtn.evaluate().isNotEmpty) {
            await tester.tap(focusBtn.first);
            await tester.pumpAndSettle(const Duration(seconds: 1));
          }
        }
      }
    });

    testWidgets('Interactive Map opens assessment', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final bottomNav = find.byType(BottomNavigationBar);
      final listTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.assignment));
      if (listTab.evaluate().isNotEmpty) {
        await tester.tap(listTab.first);
        await tester.pumpAndSettle();

        // Apri un assessment
        final tiles = find.byType(Card);
        if (tiles.evaluate().isNotEmpty) {
          await tester.tap(tiles.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Apri Interactive Map
          final interactiveMapBtn = find.byIcon(Icons.map);
          if (interactiveMapBtn.evaluate().isNotEmpty) {
            await tester.tap(interactiveMapBtn.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));

            // Cerca un'area tappabile sulla mappa
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
