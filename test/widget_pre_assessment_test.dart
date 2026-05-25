import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:assessment_tool/screens/pre_assessment_screen.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

void main() {
  group('PreAssessmentScreen Widget Tests', () {
    testWidgets('renders all steps and completes pre-assessment form', (WidgetTester tester) async {
      // Set larger screen to avoid overflow in tests
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      bool mapScreenVisited = false;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const PreAssessmentScreen(
              emergencyType: EmergencyType.mpox,
              facilityType: FacilityType.existingFacilityWithWard,
            ),
          ),
          GoRoute(
            path: '/map',
            builder: (context, state) {
              mapScreenVisited = true;
              return const Scaffold(body: Text('Map Screen Placeholder'));
            },
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

      // We should be on step 1
      expect(find.byType(PreAssessmentScreen), findsOneWidget);
      expect(find.byIcon(Icons.person_pin), findsWidgets); // Icon for step 1
      
      // Enter some text
      await tester.enterText(find.byType(TextFormField).first, 'Test Facility Name');
      await tester.pump();

      // Go to Step 2
      final btn1 = find.byType(ElevatedButton).first;
      await tester.ensureVisible(btn1);
      await tester.tap(btn1);
      await tester.pumpAndSettle();
      
      expect(find.byIcon(Icons.location_on), findsWidgets); // Icon for step 2

      // Go to Step 3
      final btn2 = find.byType(ElevatedButton).first;
      await tester.ensureVisible(btn2);
      await tester.tap(btn2);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.local_hospital), findsWidgets); // Icon for step 3

      // Go to Step 4
      final btn3 = find.byType(ElevatedButton).first;
      await tester.ensureVisible(btn3);
      await tester.tap(btn3);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.medical_services), findsWidgets); // Icon for step 4

      // Now we should see "Start Assessment"
      expect(find.text('Start Assessment'), findsWidgets);

      // Submit form
      final btnSubmit = find.byType(ElevatedButton).first;
      await tester.ensureVisible(btnSubmit);
      await tester.tap(btnSubmit);
      await tester.pump(); // Start loading dialog
      await tester.pumpAndSettle(); // Finish dialog and navigate

      // Verify we navigated to /map
      expect(mapScreenVisited, isTrue);
      expect(find.text('Map Screen Placeholder'), findsOneWidget);
    });
  });
}
