import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:assessment_tool/main.dart' as app;
import 'package:assessment_tool/services/database_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication E2E', () {
    setUp(() async {
      try {
        await DatabaseService.instance.clearSession();
      } catch (_) {}
    });

    testWidgets('Login fails with wrong credentials', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      expect(find.byType(TextFormField), findsWidgets);

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'invalid@who.int');
      await tester.enterText(textFields.at(1), 'wrongpassword');
      await tester.pumpAndSettle();

      final loginButton = find.byType(ElevatedButton).first;
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Login succeeds with correct credentials', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'gabriele@who.int'); 
      await tester.enterText(textFields.at(1), 'Test1234!');
      await tester.pumpAndSettle();

      final loginButton = find.byType(ElevatedButton).first;
      await tester.tap(loginButton);
      
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(BottomNavigationBar), findsOneWidget);
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

      if (find.byType(BottomNavigationBar).evaluate().isEmpty) {
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), 'gabriele@who.int');
        await tester.enterText(textFields.at(1), 'Test1234!');
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ElevatedButton).first);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }

      final bottomNav = find.byType(BottomNavigationBar);
      await tester.tap(find.descendant(of: bottomNav, matching: find.byIcon(Icons.settings)));
      await tester.pumpAndSettle();

      final iconLogout = find.byIcon(Icons.logout);
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
