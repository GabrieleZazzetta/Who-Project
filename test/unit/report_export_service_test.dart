import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:assessment_tool/services/report_export_service.dart';
import 'package:assessment_tool/models/assessment_models.dart';

class FakeSharePlatform extends SharePlatform {
  @override
  Future<ShareResult> shareXFiles(
    List<XFile> files, {
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    print('ShareXFiles called');
    return ShareResult('Success', ShareResultStatus.success);
  }
}

class FakePathProviderPlatform extends PathProviderPlatform {
  final Directory tempDir;
  FakePathProviderPlatform(this.tempDir);

  @override
  Future<String?> getTemporaryPath() async {
    print('getTemporaryPath called');
    return tempDir.path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('export_test_dir');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir);
  });

  tearDownAll(() {
    if (tempDir.existsSync()) {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    }
  });

  group('ReportExportService Tests', () {
    testWidgets('exportAssessmentToEditableWord creates file and calls share', (WidgetTester tester) async {
      final facility = FacilityLayout(
        facilityName: 'Export Clinic',
        emergencyType: EmergencyType.ebola,
      );
      
      facility.generalInfo = GeneralFacilityInfo()
        ..country = 'Uganda'
        ..city = 'Kampala'
        ..assessorName = 'Dr. John Doe';
      
      facility.zones = [SpatialZone(
        id: 'z1',
        name: 'Triage',
        coordinates: MapCoordinates(top: 0, left: 0),
        touchArea: MapCoordinates(top: 0, left: 0, width: 0, height: 0),
        checklist: [
          AssessmentQuestion(
            id: 'q1',
            text: 'Is triage ready?',
            category: AssessmentCategory.infectionPreventionControl,
            selectedCompliance: ComplianceLevel.meetsTarget,
          )
        ],
      )];

      // Mock SharePlatform
      SharePlatform.instance = FakeSharePlatform();

      // Abbiamo bisogno di un context finto per Share.shareXFiles
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: const Text('Export Context'),
            ),
          ),
        ),
      );

      final context = tester.element(find.text('Export Context'));
      
      // Chiamata diretta così possiamo fare await dentro runAsync
      await tester.runAsync(() async {
        await ReportExportService.exportAssessmentToEditableWord(context, facility);
      });

      // Verifica che il file esista
      final expectedFile = File('${tempDir.path}/WHO_Report_Export_Clinic.doc');
      expect(expectedFile.existsSync(), true);

      // Verifica contenuto file
      final content = expectedFile.readAsStringSync();
      expect(content, contains('Export Clinic'));
      expect(content, contains('Uganda'));
      expect(content, contains('Triage'));
      expect(content, contains('Dr. John Doe'));
    });
  });
}
