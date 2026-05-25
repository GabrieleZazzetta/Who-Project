import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:assessment_tool/screens/facility_selection_screen.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

void main() {
  group('FacilitySelectionScreen Widget Tests', () {
    testWidgets('renders all facility types and handles navigation for mpox', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      bool preAssessmentVisited = false;
      FacilityType? passedFacilityType;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const FacilitySelectionScreen(emergency: EmergencyType.mpox),
          ),
          GoRoute(
            path: '/pre-assessment',
            builder: (context, state) {
              preAssessmentVisited = true;
              final extra = state.extra as Map<String, dynamic>;
              passedFacilityType = extra['facilityType'] as FacilityType;
              return const Scaffold(body: Text('PreAssessment Placeholder'));
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

      // Verify the 4 options are rendered
      expect(find.text('Screening, Triage & Temporary Isolation'), findsOneWidget);
      expect(find.text('Existing Facility with Dedicated Ward'), findsOneWidget);
      expect(find.text('Stand-Alone Treatment Centre'), findsOneWidget);
      expect(find.text('Congregate Settings'), findsOneWidget);

      // Tap on the first facility option
      await tester.tap(find.text('Screening, Triage & Temporary Isolation'));
      await tester.pumpAndSettle();

      // Since emergency is mpox, it should navigate to /pre-assessment
      expect(preAssessmentVisited, isTrue);
      expect(passedFacilityType, FacilityType.screeningAndIsolation);
      expect(find.text('PreAssessment Placeholder'), findsOneWidget);
    });

    testWidgets('handles navigation for other emergency types', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      bool mapVisited = false;
      FacilityType? passedFacilityType;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const FacilitySelectionScreen(emergency: EmergencyType.ebola),
          ),
          GoRoute(
            path: '/map',
            builder: (context, state) {
              mapVisited = true;
              final extra = state.extra as Map<String, dynamic>;
              passedFacilityType = extra['facilityType'] as FacilityType;
              return const Scaffold(body: Text('Map Placeholder'));
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

      // Tap on the second facility option
      await tester.tap(find.text('Existing Facility with Dedicated Ward'));
      await tester.pumpAndSettle();

      // Since emergency is ebola, it should navigate to /map
      expect(mapVisited, isTrue);
      expect(passedFacilityType, FacilityType.existingFacilityWithWard);
      expect(find.text('Map Placeholder'), findsOneWidget);
    });
  });
}
