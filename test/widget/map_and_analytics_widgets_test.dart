import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:assessment_tool/screens/analytics_screen.dart';
import 'package:assessment_tool/screens/advanced_analytics_screen.dart';
import 'package:assessment_tool/screens/interactive_map_screen.dart';
import 'package:assessment_tool/screens/global_map_screen_3d.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

void main() {
  late Isar testIsar;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('map_analytics_widget_test');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
      name: 'map_analytics_instance_${DateTime.now().millisecondsSinceEpoch}',
    );
    DatabaseService.instance.setTestIsar(testIsar);
  });

  tearDown(() {
    testIsar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      try { tempDir.deleteSync(recursive: true); } catch (e) {}
    }
  });

  Widget createTestWidget(Widget screen) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      home: screen,
    );
  }

  group('Map and Analytics Widgets Tests', () {

    // ==========================================
    // ANALYTICS SCREEN (widget_analytics_test.dart)
    // ==========================================
    group('AnalyticsScreen Tests', () {
      testWidgets('renders empty state when no assessments available', (tester) async {
        await tester.pumpWidget(createTestWidget(const AnalyticsScreen()));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('No reports available for this selection.'), findsWidgets);
      });

      testWidgets('renders metrics when data is available', (tester) async {
        final facility = FacilityLayout()
          ..facilityName = 'Test Hospital'
          ..dateCreated = DateTime(2023, 1, 1)
          ..generalInfo = (GeneralFacilityInfo()..country = 'Italy');
          
        final zone = SpatialZone()..name = 'Zone 1';
        final question = AssessmentQuestion()
          ..id = 'q1'
          ..category = AssessmentCategory.infectionPreventionControl
          ..selectedCompliance = ComplianceLevel.meetsTarget;
          
        zone.checklist = List.from(zone.checklist)..add(question);
        facility.zones = List.from(facility.zones)..add(zone);

        await testIsar.writeTxn(() async {
          await testIsar.facilityLayouts.put(facility);
        });

        await tester.pumpWidget(createTestWidget(const AnalyticsScreen()));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        
        expect(find.text('No reports available for this selection.'), findsNothing);
        expect(find.text('DATA ANALYTICS'), findsOneWidget);
        expect(find.byIcon(Icons.insights_rounded), findsWidgets);
      });
    });

    // ==========================================
    // ADVANCED ANALYTICS SCREEN (widget_advanced_analytics_test.dart)
    // ==========================================
    group('AdvancedAnalyticsScreen Tests', () {
      testWidgets('renders empty state when no data provided', (tester) async {
        await tester.pumpWidget(createTestWidget(const AdvancedAnalyticsScreen(data: [])));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('No data to display.'), findsOneWidget);
      });

      testWidgets('renders charts when data is provided', (tester) async {
        final f1 = FacilityLayout()..facilityName = 'H1'..dateCreated = DateTime(2023, 1, 1);
        final zone1 = SpatialZone()..name = 'Z1';
        final q1 = AssessmentQuestion()..id = 'q1'..category = AssessmentCategory.infectionPreventionControl..selectedCompliance = ComplianceLevel.meetsTarget;
        zone1.checklist = List.from(zone1.checklist)..add(q1);
        f1.zones = List.from(f1.zones)..add(zone1);

        final f2 = FacilityLayout()..facilityName = 'H2'..dateCreated = DateTime(2023, 2, 1);
        final zone2 = SpatialZone()..name = 'Z2';
        final q2 = AssessmentQuestion()..id = 'q2'..category = AssessmentCategory.wash..selectedCompliance = ComplianceLevel.doesNotMeet;
        zone2.checklist = List.from(zone2.checklist)..add(q2);
        f2.zones = List.from(f2.zones)..add(zone2);

        await tester.pumpWidget(createTestWidget(AdvancedAnalyticsScreen(data: [f1, f2])));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        
        expect(find.text('ADVANCED ANALYTICS'), findsOneWidget);
        expect(find.text('No data to display.'), findsNothing);
        expect(find.text('Readiness Trend'), findsOneWidget);
      });
    });

    // ==========================================
    // INTERACTIVE MAP SCREEN (widget_interactive_map_test.dart)
    // ==========================================
    group('InteractiveMapScreen Tests', () {
      testWidgets('renders map screen and pinch-to-explore text', (tester) async {
        await tester.pumpWidget(createTestWidget(const InteractiveMapScreen(emergencyType: EmergencyType.mpox, facilityType: FacilityType.standAloneCenter)));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.text('Spatial Assessment'), findsOneWidget);
        expect(find.byType(InteractiveViewer), findsOneWidget);
        expect(find.text('Pinch to explore. Tap highlighted pins to evaluate.'), findsWidgets);
      });

      testWidgets('has general assessment and list buttons in appbar', (tester) async {
        await tester.pumpWidget(createTestWidget(const InteractiveMapScreen(emergencyType: EmergencyType.mpox, facilityType: FacilityType.standAloneCenter)));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.byIcon(Icons.assignment_outlined), findsOneWidget);
        expect(find.byIcon(Icons.domain_verification), findsOneWidget);
      });
    });

    // ==========================================
    // GLOBAL MAP SCREEN 3D (widget_global_map_test.dart)
    // ==========================================
    group('GlobalMapScreen3D Tests', () {
      testWidgets('renders map screen when data is loaded', (tester) async {
        await tester.pumpWidget(createTestWidget(const GlobalMapScreen3D()));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.text('Global Assessment Map'), findsOneWidget);
      });
    });

  });
}
