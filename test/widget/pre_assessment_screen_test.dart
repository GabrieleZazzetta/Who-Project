import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assessment_tool/screens/pre_assessment_screen.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

void main() {
  Widget createProviderAppWithRouter(Widget home) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => home,
        ),
        GoRoute(
          path: '/map',
          builder: (context, state) => const Scaffold(body: Text('Map Screen')),
        ),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  group('PreAssessmentScreen Tests', () {
    testWidgets('fills form steps and submits to map screen', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(
        const Scaffold(
          body: PreAssessmentScreen(
            emergencyType: EmergencyType.mpox,
            facilityType: FacilityType.standAloneCenter,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Step 1
      expect(find.text('Assessment Information'), findsWidgets);
      
      final textFieldsStep1 = find.byType(TextFormField);
      await tester.enterText(textFieldsStep1.at(0), 'Test Assessment');
      await tester.enterText(textFieldsStep1.at(1), 'John Doe');
      await tester.enterText(textFieldsStep1.at(2), 'john@example.com');
      await tester.enterText(textFieldsStep1.at(3), '1234567890');
      
      final nextButton = find.text('Next').hitTestable();
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Step 2
      expect(find.text('Geographical Location'), findsWidgets);
      final textFieldsStep2 = find.byType(TextFormField);
      await tester.enterText(textFieldsStep2.at(0), 'Country');
      await tester.enterText(textFieldsStep2.at(1), 'Region');
      await tester.enterText(textFieldsStep2.at(2), 'District');
      await tester.enterText(textFieldsStep2.at(3), 'City');
      await tester.enterText(textFieldsStep2.at(4), 'Address');

      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Step 3
      expect(find.text('Facility Identification'), findsWidgets);
      final textFieldsStep3 = find.byType(TextFormField);
      await tester.enterText(textFieldsStep3.at(0), 'FAC-123');
      await tester.enterText(textFieldsStep3.at(1), 'Facility Name');
      await tester.enterText(textFieldsStep3.at(2), 'Dir Name');
      await tester.enterText(textFieldsStep3.at(3), 'Dir Phone');
      await tester.enterText(textFieldsStep3.at(4), 'Dir Email');
      await tester.enterText(textFieldsStep3.at(5), 'Resp Name');
      await tester.enterText(textFieldsStep3.at(6), 'Resp Position');
      
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Step 4
      expect(find.text('Existing Healthcare Services'), findsWidgets);
      // Here we have DropdownButtonFormField.
      // Offers inpatient? We need to tap it to Yes so we can fill beds.
      // There are multiple dropdowns, let's just submit directly or interact with one.
      
      // Let's test the Back button first
      final backButton = find.text('Back').hitTestable();
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.text('Facility Identification'), findsWidgets);
      
      // Go next again
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('Existing Healthcare Services'), findsWidgets);

      // We are at step 4. Submit
      final submitButton = find.text('Start Assessment').hitTestable();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Should have navigated to map
      expect(find.text('Map Screen'), findsOneWidget);
    });

    testWidgets('renders tablet landscape split layout', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(3600, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(
        const Scaffold(
          body: PreAssessmentScreen(
            emergencyType: EmergencyType.ebola,
            facilityType: FacilityType.screeningAndIsolation,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Should see the sidebar
      expect(find.byType(AnimatedContainer), findsWidgets);
      
      // Tap collapse menu
      final menuBtn = find.byIcon(Icons.menu_open_rounded);
      if (menuBtn.evaluate().isNotEmpty) {
        await tester.tap(menuBtn);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('renders mobile portrait layout', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(400, 800),
          ),
          child: const Scaffold(
            body: PreAssessmentScreen(
              emergencyType: EmergencyType.mpox,
              facilityType: FacilityType.congregateSetting,
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('renders mobile landscape layout', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(568, 320));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(568, 320),
          ),
          child: const Scaffold(
            body: PreAssessmentScreen(
              emergencyType: EmergencyType.mpox,
              facilityType: FacilityType.existingFacilityWithWard,
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
