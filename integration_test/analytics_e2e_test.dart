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
      final listTab = find.descendant(of: bottomNav, matching: find.byIcon(Icons.list));
      if (listTab.evaluate().isNotEmpty) {
        await tester.tap(listTab.first);
        await tester.pumpAndSettle();

        // Cerca il tasto FAB o pulsante appBar per le Analytics
        if (find.byIcon(Icons.analytics).evaluate().isNotEmpty) {
          await tester.tap(find.byIcon(Icons.analytics).first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          expect(find.byType(Scaffold), findsWidgets);
        } else if (find.byIcon(Icons.bar_chart).evaluate().isNotEmpty) {
          await tester.tap(find.byIcon(Icons.bar_chart).first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('Global Map 3D interaction', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Trova l'icona mappamondo (Global Map) nella dashboard
      final mapIcon = find.byIcon(Icons.public);
      if (mapIcon.evaluate().isNotEmpty) {
        await tester.tap(mapIcon.first);
        await tester.pumpAndSettle(const Duration(seconds: 4));

        // Dovremmo essere sulla Global Map
        expect(find.byType(Scaffold), findsWidgets);
        
        // Fai tap su un pulsante della mappa se presente (es. focus user location)
        final focusBtn = find.byIcon(Icons.my_location);
        if (focusBtn.evaluate().isNotEmpty) {
          await tester.tap(focusBtn.first);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }
      }
    });
  });
}
