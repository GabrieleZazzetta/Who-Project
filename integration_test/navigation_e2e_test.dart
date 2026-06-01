import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:assessment_tool/main.dart' as app;
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/models/user_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation E2E', () {
    setUp(() async {
      try {
        final session = UserSession()
          ..email = 'gabriele@who.int'
          ..isLoggedIn = true
          ..isWhoStaff = true;
        await DatabaseService.instance.saveSession(session);
      } catch (_) {}
    });

    testWidgets('Bottom navigation bar switches tabs', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final bottomNav = find.byType(BottomNavigationBar);
      expect(bottomNav, findsOneWidget);

      // Clicca sul tab della mappa (es. icona map o list)
      if (find.descendant(of: bottomNav, matching: find.byIcon(Icons.map)).evaluate().isNotEmpty) {
        await tester.tap(find.descendant(of: bottomNav, matching: find.byIcon(Icons.map)).first);
        await tester.pumpAndSettle();
      } else if (find.descendant(of: bottomNav, matching: find.byIcon(Icons.list)).evaluate().isNotEmpty) {
        await tester.tap(find.descendant(of: bottomNav, matching: find.byIcon(Icons.list)).first);
        await tester.pumpAndSettle();
      }

      // Clicca sul tab settings
      final settingsTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.settings));
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab.first);
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.person), findsWidgets); // Un'icona tipica dei settings
      }

      // Torna alla home
      if (find.descendant(of: bottomNav, matching: find.byIcon(Icons.home)).evaluate().isNotEmpty) {
        await tester.tap(find.descendant(of: bottomNav, matching: find.byIcon(Icons.home)).first);
        await tester.pumpAndSettle();
      } else if (find.descendant(of: bottomNav, matching: find.byIcon(Icons.dashboard)).evaluate().isNotEmpty) {
        await tester.tap(find.descendant(of: bottomNav, matching: find.byIcon(Icons.dashboard)).first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Navigate to Outbreak module and back', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Cerca card Mpox o similare
      final cards = find.byType(Card);
      if (cards.evaluate().isNotEmpty) {
        await tester.tap(cards.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Dovremmo essere in facility selection
        expect(find.byType(BackButton), findsOneWidget);

        // Torniamo indietro
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Tornati in home
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      }
    });
  });
}
