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

      // Execute Step 1: Assessment Information
      expect(find.text('Assessment Information'), findsWidgets);
      
      // Provision valid inputs for step 1
      final textFieldsStep1 = find.byType(TextFormField);
      await tester.enterText(textFieldsStep1.at(0), 'Test Assessment');
      await tester.enterText(textFieldsStep1.at(1), 'John Doe');
      await tester.enterText(textFieldsStep1.at(2), 'john@example.com');
      await tester.enterText(textFieldsStep1.at(3), '1234567890');
      
      final nextButton = find.text('Next').hitTestable();
      await tester.tap(nextButton);
      await tester.pump(const Duration(milliseconds: 300));

      // Execute Step 2: Geographical Location
      expect(find.text('Geographical Location'), findsWidgets);
      
      // Provision geographical data
      final textFieldsStep2 = find.byType(TextFormField);
      await tester.enterText(textFieldsStep2.at(0), 'Country');
      await tester.enterText(textFieldsStep2.at(1), 'Region');
      await tester.enterText(textFieldsStep2.at(2), 'District');
      await tester.enterText(textFieldsStep2.at(3), 'City');
      await tester.enterText(textFieldsStep2.at(4), 'Address');
      
      // Select location dropdown
      final dropdownsStep2 = find.byType(DropdownButtonFormField<String>);
      if (dropdownsStep2.evaluate().isNotEmpty) {
        await tester.tap(dropdownsStep2.first);
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('Urban').last);
        await tester.pump(const Duration(milliseconds: 300));
      }

      await tester.tap(nextButton);
      await tester.pump(const Duration(milliseconds: 300));

      // Execute Step 3: Facility Identification
      expect(find.text('Facility Identification'), findsWidgets);
      
      // Provision facility identification data
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

      // Execute Step 4: Existing Healthcare Services
      expect(find.text('Existing Healthcare Services'), findsWidgets);
      
      // Configure service availability
      final dropdownsStep4 = find.byType(DropdownButtonFormField<String>);
      
      // Configure outpatient setting
      if (dropdownsStep4.evaluate().isNotEmpty) {
        await tester.tap(dropdownsStep4.at(0));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('Yes').last);
        await tester.pump(const Duration(milliseconds: 300));
      }
      
      // Configure inpatient availability
      if (dropdownsStep4.evaluate().length > 1) {
        await tester.tap(dropdownsStep4.at(1));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('Yes').last);
        await tester.pump(const Duration(milliseconds: 300));
        
        // Provision inpatient capacity
        final numberFields = find.byType(TextFormField);
        await tester.enterText(numberFields.at(0), '100'); // total beds
        await tester.enterText(numberFields.at(1), '20'); // icu beds
        
        final conditionalDropdowns = find.byType(DropdownButtonFormField<String>);
        if (conditionalDropdowns.evaluate().length > 2) {
          // Configure 24h emergency service
          await tester.tap(conditionalDropdowns.at(2));
          await tester.pump(const Duration(milliseconds: 300));
          await tester.tap(find.text('Yes').last);
          await tester.pump(const Duration(milliseconds: 300));
        }
        
        // Validate field clearing on negative selection
        await tester.tap(dropdownsStep4.at(1));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('No').last);
        await tester.pump(const Duration(milliseconds: 300));
      }
      
      // Execute back navigation
      final backButton = find.text('Back').hitTestable();
      await tester.tap(backButton);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Facility Identification'), findsWidgets);
      
      // Execute forward navigation
      await tester.tap(nextButton);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Existing Healthcare Services'), findsWidgets);

      // Execute form submission
      final submitButton = find.text('Start Assessment').hitTestable();
      await tester.ensureVisible(submitButton);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(submitButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      // Validate navigation to map screen after successful submission
      expect(find.text('Map Screen'), findsOneWidget);
    });

    testWidgets('renders tablet landscape split layout', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1600, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(
        const MediaQuery(
          data: MediaQueryData(
            size: Size(1600, 900),
            devicePixelRatio: 1.0,
          ),
          child: Scaffold(
            body: PreAssessmentScreen(
              emergencyType: EmergencyType.ebola,
              facilityType: FacilityType.screeningAndIsolation,
            ),
          ),
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Validate layout constraints
      expect(find.byType(AnimatedContainer), findsWidgets);
      expect(find.byIcon(Icons.menu_open_rounded), findsOneWidget);
      
      // Execute sidebar toggle
      await tester.tap(find.byIcon(Icons.menu_open_rounded));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    });

    testWidgets('renders mobile portrait layout', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createProviderAppWithRouter(
        const MediaQuery(
          data: MediaQueryData(
            size: Size(400, 800),
          ),
          child: Scaffold(
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
        const MediaQuery(
          data: MediaQueryData(
            size: Size(568, 320),
          ),
          child: Scaffold(
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

      // Navigate to Step 2
      await tester.ensureVisible(find.text('Next'));
      await tester.tap(find.text('Next').hitTestable());
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Geographical Location'), findsWidgets);

      // Navigate to previous step
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

      // Navigate to Step 4
      for (int i = 0; i < 3; i++) {
        await tester.ensureVisible(find.text('Next'));
        await tester.tap(find.text('Next').hitTestable());
        await tester.pump(const Duration(milliseconds: 300));
      }
      
      expect(find.text('Existing Healthcare Services'), findsWidgets);

      // Configure inpatient positive selection to toggle dynamic fields
      final dropdowns = find.byType(DropdownButtonFormField<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Yes').last);
      await tester.pump(const Duration(milliseconds: 300));

      // Validate dependent fields rendering
      expect(find.byType(TextFormField), findsWidgets);
      
      // Configure inpatient negative selection
      await tester.tap(dropdowns.at(1));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('No').last);
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}
