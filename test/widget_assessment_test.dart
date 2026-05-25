import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:assessment_tool/screens/assessment_screen.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

void main() {
  group('AssessmentScreen Widget Tests', () {
    testWidgets('renders questions and updates compliance', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      final testQuestion = AssessmentQuestion(
        id: 'q_1',
        text: 'Is the facility clean?',
      );

      final zone = SpatialZone(
        id: 'z_1',
        name: 'Test Zone',
        checklist: [testQuestion],
      );

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => AssessmentScreen(zone: zone),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );

      await tester.pumpAndSettle();

      // Check title and question
      expect(find.text('Test Zone'), findsOneWidget);
      expect(find.text('Is the facility clean?'), findsOneWidget);

      final meetsTargetIcon = find.byIcon(Icons.check_circle);
      expect(meetsTargetIcon, findsOneWidget);

      // Tap on Meets Target
      await tester.ensureVisible(meetsTargetIcon);
      await tester.tap(meetsTargetIcon);
      await tester.pumpAndSettle();

      expect(testQuestion.selectedCompliance, ComplianceLevel.meetsTarget);

      // Tap on Partially Meets
      final partiallyMeetsIcon = find.byIcon(Icons.warning_amber_rounded);
      await tester.ensureVisible(partiallyMeetsIcon);
      await tester.tap(partiallyMeetsIcon);
      await tester.pumpAndSettle();

      expect(testQuestion.selectedCompliance, ComplianceLevel.partiallyMeets);
      expect(find.byIcon(Icons.lightbulb), findsOneWidget); // Recommendation block

      // Test "Add Note" dialog
      final addNoteButton = find.byIcon(Icons.edit_note);
      await tester.ensureVisible(addNoteButton);
      await tester.tap(addNoteButton);
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      
      await tester.enterText(find.byType(TextField), 'Test note');
      
      final dialogButtons = find.byType(ElevatedButton);
      await tester.tap(dialogButtons.last);
      await tester.pumpAndSettle();

      expect(testQuestion.note, 'Test note');
    });
  });
}
