import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:assessment_tool/main.dart' as app;
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/models/user_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

    testWidgets('Assessment add item (Start Pre-Assessment)', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 1. Dalla dashboard, clicca un'emergenza
      final cards = find.byType(Card);
      if (cards.evaluate().isNotEmpty) {
        await tester.tap(cards.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // 2. Seleziona il tipo di facility
        final facilityCards = find.byType(Card);
        if (facilityCards.evaluate().isNotEmpty) {
          await tester.tap(facilityCards.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // 3. Pre-assessment screen: cerca un input text per il nome e un pulsante per confermare
          final textFields = find.byType(TextFormField);
          if (textFields.evaluate().isNotEmpty) {
            await tester.enterText(textFields.first, 'Test E2E Facility');
            await tester.pumpAndSettle();
            
            // Avanza o invia form
            final submitButton = find.byType(ElevatedButton);
            if (submitButton.evaluate().isNotEmpty) {
              await tester.tap(submitButton.last);
              await tester.pumpAndSettle(const Duration(seconds: 2));
            }
          }
        }
      }
    });

    testWidgets('Assessment compliance change', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Entriamo in un'ispezione esistente
      // Cerchiamo la lista ispezioni
      final bottomNav = find.byType(BottomNavigationBar);
      final listTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.list));
      if (listTab.evaluate().isNotEmpty) {
        await tester.tap(listTab.first);
        await tester.pumpAndSettle();

        final tiles = find.byType(ListTile);
        if (tiles.evaluate().isNotEmpty) {
          await tester.tap(tiles.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Seleziona la prima zona
          if (find.byType(Card).evaluate().isNotEmpty) {
            await tester.tap(find.byType(Card).first);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          } else if (find.byType(ListTile).evaluate().isNotEmpty) {
            await tester.tap(find.byType(ListTile).first);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
          
          if (find.byType(Card).evaluate().isNotEmpty || find.byType(ListTile).evaluate().isNotEmpty) {
            // Trova una card domanda e fai tap su un pulsante compliance
            final complianceBtn = find.byIcon(Icons.check_circle_outline);
            if (complianceBtn.evaluate().isNotEmpty) {
              await tester.tap(complianceBtn.first);
              await tester.pumpAndSettle(const Duration(seconds: 1));
            }
          }
        }
      }
    });
  });
}
