import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:assessment_tool/screens/advanced_analytics_screen.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

void main() {
  Widget createTestWidget(List<FacilityLayout> data) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      home: AdvancedAnalyticsScreen(data: data),
    );
  }

  group('AdvancedAnalyticsScreen Widget Tests', () {
    testWidgets('renders empty state when no data provided', (tester) async {
      await tester.pumpWidget(createTestWidget([]));
      await tester.pumpAndSettle();
      
      expect(find.text('No data to display.'), findsOneWidget);
    });

    testWidgets('renders charts when data is provided', (tester) async {
      final f1 = FacilityLayout()
        ..facilityName = 'H1'
        ..dateCreated = DateTime(2023, 1, 1);
      final zone1 = SpatialZone()..name = 'Z1';
      final q1 = AssessmentQuestion()
        ..id = 'q1'
        ..category = AssessmentCategory.infectionPreventionControl
        ..selectedCompliance = ComplianceLevel.meetsTarget;
      zone1.checklist.add(q1);
      f1.zones.add(zone1);

      final f2 = FacilityLayout()
        ..facilityName = 'H2'
        ..dateCreated = DateTime(2023, 2, 1);
      final zone2 = SpatialZone()..name = 'Z2';
      final q2 = AssessmentQuestion()
        ..id = 'q2'
        ..category = AssessmentCategory.wash
        ..selectedCompliance = ComplianceLevel.doesNotMeet;
      zone2.checklist.add(q2);
      f2.zones.add(zone2);

      await tester.pumpWidget(createTestWidget([f1, f2]));
      await tester.pumpAndSettle();
      
      expect(find.text('ADVANCED ANALYTICS'), findsOneWidget);
      expect(find.text('No data to display.'), findsNothing);
      expect(find.text('Readiness Trend'), findsOneWidget);
    });
  });
}
