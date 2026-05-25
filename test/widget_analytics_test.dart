import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:isar/isar.dart';
import 'dart:io';

import 'package:assessment_tool/screens/analytics_screen.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

void main() {
  late Isar testIsar;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: false);
  });

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('analytics_test');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
      name: 'analytics_test_instance_${DateTime.now().millisecondsSinceEpoch}',
    );
    DatabaseService.instance.setTestIsar(testIsar);
  });

  tearDown(() {
    testIsar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      try { tempDir.deleteSync(recursive: true); } catch (e) {}
    }
  });

  Widget createTestWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      home: const AnalyticsScreen(),
    );
  }

  group('AnalyticsScreen Widget Tests', () {
    testWidgets('renders empty state when no assessments available', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      
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
        
      zone.checklist.add(question);
      facility.zones.add(zone);

      await testIsar.writeTxn(() async {
        await testIsar.facilityLayouts.put(facility);
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      
      expect(find.text('No reports available for this selection.'), findsNothing);
      expect(find.text('DATA ANALYTICS'), findsOneWidget); // title
      expect(find.byIcon(Icons.insights_rounded), findsWidgets); // advanced analytics icon
    });
  });
}
