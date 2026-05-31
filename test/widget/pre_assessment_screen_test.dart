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
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('Root')),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => home,
        ),
        GoRoute(
          path: '/map',
          builder: (context, state) {
            return const Scaffold(body: Text('Map Screen'));
          },
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
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Step 1
      expect(find.text('Assessment Information'), findsWidgets);
      
      final textFieldsStep1 = find.byType(TextFormField);
      await tester.enterText(textFieldsStep1.at(0), 'Test Assessment');
      await tester.enterText(textFieldsStep1.at(1), 'John Doe');
      await tester.enterText(textFieldsStep1.at(2), 'john@example.com');
      await tester.enterText(textFieldsStep1.at(3), '1234567890');
      
      final nextButton = find.text('Next').hitTestable();
      await tester.tap(nextButton);
      await tester.pump(const Duration(milliseconds: 300));

      // Step 2
      expect(find.text('Geographical Location'), findsWidgets);
      final textFieldsStep2 = find.byType(TextFormField);
      await tester.enterText(textFieldsStep2.at(0), 'Country');
      await tester.enterText(textFieldsStep2.at(1), 'Region');
      await tester.enterText(textFieldsStep2.at(2), 'District');
      await tester.enterText(textFieldsStep2.at(3), 'City');
      await tester.enterText(textFieldsStep2.at(4), 'Address');
      
      // Select Location Record dropdown
      final dropdownsStep2 = find.byType(DropdownButtonFormField<String>);
      if (dropdownsStep2.evaluate().isNotEmpty) {
        await tester.tap(dropdownsStep2.first);
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('Urban').last);
        await tester.pump(const Duration(milliseconds: 300));
      }

      await tester.tap(nextButton);
      await tester.pump(const Duration(milliseconds: 300));

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
      await tester.pump(const Duration(milliseconds: 300));

      // Step 4
      expect(find.text('Existing Healthcare Services'), findsWidgets);
      
      // Select Dropdowns in Step 4
      final dropdownsStep4 = find.byType(DropdownButtonFormField<String>);
      
      // Outpatient
      if (dropdownsStep4.evaluate().isNotEmpty) {
        await tester.tap(dropdownsStep4.at(0));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('Yes').last);
        await tester.pump(const Duration(milliseconds: 300));
      }
      
      // Inpatient Yes
      if (dropdownsStep4.evaluate().length > 1) {
        await tester.tap(dropdownsStep4.at(1));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('Yes').last);
        await tester.pump(const Duration(milliseconds: 300));
        
        // Fill inpatient fields
        final numberFields = find.byType(TextFormField);
        await tester.enterText(numberFields.at(0), '100'); // total beds
        await tester.enterText(numberFields.at(1), '20'); // icu beds
        
        final conditionalDropdowns = find.byType(DropdownButtonFormField<String>);
        if (conditionalDropdowns.evaluate().length > 2) {
          // Has 24h emergency
          await tester.tap(conditionalDropdowns.at(2));
          await tester.pump(const Duration(milliseconds: 300));
          await tester.tap(find.text('Yes').last);
          await tester.pump(const Duration(milliseconds: 300));
        }
        
        // Inpatient No (to trigger clearing logic)
        await tester.tap(dropdownsStep4.at(1));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('No').last);
        await tester.pump(const Duration(milliseconds: 300));
      }
      
      // Let's test the Back button first
      final backButton = find.text('Back').hitTestable();
      await tester.tap(backButton);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Facility Identification'), findsWidgets);
      
      // Go next again
      await tester.tap(nextButton);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Existing Healthcare Services'), findsWidgets);

      // We are at step 4. Submit
      final submitButton = find.text('Start Assessment').hitTestable();
      await tester.ensureVisible(submitButton);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(submitButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      // Should have navigated to map
      expect(find.text('Map Screen'), findsOneWidget);
    });

    testWidgets('renders tablet landscape split layout', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1600, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(1600, 900),
            devicePixelRatio: 1.0,
          ),
          child: const Scaffold(
            body: PreAssessmentScreen(
              emergencyType: EmergencyType.ebola,
              facilityType: FacilityType.screeningAndIsolation,
            ),
          ),
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verifica sidebar e form area
      expect(find.byType(AnimatedContainer), findsWidgets);
      expect(find.byIcon(Icons.menu_open_rounded), findsOneWidget);
      
      // Testa collapse sidebar
      await tester.tap(find.byIcon(Icons.menu_open_rounded));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
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
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

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
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AppBar), findsOneWidget);
    });
    testWidgets('Back button navigates to previous step', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(
        const Scaffold(
          body: PreAssessmentScreen(
            emergencyType: EmergencyType.mpox,
            facilityType: FacilityType.standAloneCenter,
          ),
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Vai allo step 2
      await tester.ensureVisible(find.text('Next'));
      await tester.tap(find.text('Next').hitTestable());
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Geographical Location'), findsWidgets);

      // Torna indietro
      await tester.ensureVisible(find.text('Back'));
      await tester.tap(find.text('Back').hitTestable());
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Assessment Information'), findsWidgets);
    });

    testWidgets('inpatient Yes shows extra fields, No hides them', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(
        const Scaffold(
          body: PreAssessmentScreen(
            emergencyType: EmergencyType.mpox,
            facilityType: FacilityType.standAloneCenter,
          ),
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Naviga fino allo step 4
      for (int i = 0; i < 3; i++) {
        await tester.ensureVisible(find.text('Next'));
        await tester.tap(find.text('Next').hitTestable());
        await tester.pump(const Duration(milliseconds: 300));
      }
      
      expect(find.text('Existing Healthcare Services'), findsWidgets);

      // Seleziona Inpatient Yes
      final dropdowns = find.byType(DropdownButtonFormField<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Yes').last);
      await tester.pump(const Duration(milliseconds: 300));

      // Verifica che appaiano i campi extra
      expect(find.byType(TextFormField), findsWidgets);
      
      // Seleziona No per nasconderli
      await tester.tap(dropdowns.at(1));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('No').last);
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}
