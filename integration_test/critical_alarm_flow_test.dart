import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/services/report_export_service.dart';

// MOCK BUILD CONTEXT PER EVITARE IL PUMP DI WIDGET NEI TEST DI SERVIZIO ASINCRONI
class MockBuildContext implements BuildContext {
  @override
  RenderObject? findRenderObject() => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Isar testIsar;
  late Directory tempDir;
  final List<MethodCall> shareMethodCalls = [];

  setUpAll(() async {
    await Isar.initializeIsarCore(download: false);
    tempDir = Directory.systemTemp.createTempSync('isar_alarm_test_dir');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    DatabaseService.instance.setTestIsar(testIsar);

    const MethodChannel pathChannel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathChannel, (MethodCall methodCall) async {
      if (methodCall.method == 'getTemporaryDirectory') {
        return tempDir.path;
      }
      return null;
    });

    const MethodChannel shareChannel = MethodChannel('dev.fluttercommunity.plus/share');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(shareChannel, (MethodCall methodCall) async {
      shareMethodCalls.add(methodCall);
      return 'success';
    });
  });

  tearDownAll(() async {
    testIsar.close();
    if(tempDir.existsSync()){try{tempDir.deleteSync(recursive:true);}catch(e){}}
  });

  setUp(() async {
    shareMethodCalls.clear();
    final db = DatabaseService.instance;
    final all = await db.getAllAssessments();
    for (var f in all) {
      await db.deleteAssessment(f.id);
    }
  });

  group('Critical Alarm & Report Flow', () {
    
    test('E2E Alarm and Report Generation: transitions to Red and exports Word doc via native share', () async {
      final db = DatabaseService.instance;

      final facility = FacilityLayout(
        facilityName: 'Gaza Al-Shifa Hospital',
        emergencyType: EmergencyType.sars,
        dateCreated: DateTime.now().toUtc(),
        zones: [
          SpatialZone(
            id: 'z_screening',
            name: 'Screening and Triage Area',
            checklist: [
              AssessmentQuestion(
                id: 'q_s1',
                text: 'Are suspected cases physically isolated immediately?',
                selectedCompliance: ComplianceLevel.meetsTarget,
              ),
            ],
          ),
        ],
      );

      facility.generalInfo = GeneralFacilityInfo()
        ..assessorName = 'Dr. John Doe'
        ..assessorEmail = 'john.doe@who.int'
        ..city = 'Gaza City'
        ..country = 'Palestine'
        ..facilityAddressOrGps = '31.5, 34.4';

      final savedId = await db.saveAssessment(facility);
      expect(savedId, isNotNull);

      var loaded = await db.getAssessmentById(savedId);
      expect(loaded, isNotNull);

      expect(loaded!.globalReadinessScore, equals(100.0));
      expect(loaded.zones.first.statusColor, equals(Colors.green.shade600));

      loaded.zones.first.checklist.first.selectedCompliance = ComplianceLevel.doesNotMeet;
      await db.saveAssessment(loaded);

      var updated = await db.getAssessmentById(savedId);
      expect(updated, isNotNull);

      expect(updated!.globalReadinessScore, closeTo(33.33, 0.01));
      expect(updated.zones.first.statusColor, equals(Colors.red.shade600));
      bool hasCritical = updated.zones.any((z) => z.checklist.any((q) => q.isCriticalFailure));
      expect(hasCritical, isTrue);

      final mockContext = MockBuildContext();
      await ReportExportService.exportAssessmentToEditableWord(mockContext, updated);

      expect(shareMethodCalls, isNotEmpty);
      final call = shareMethodCalls.first;
      expect(call.method, contains('share'));
      
      final Map<dynamic, dynamic> arguments = call.arguments as Map<dynamic, dynamic>;
      final List<dynamic> paths = arguments['tokens'] ?? arguments['paths'] ?? [];
      expect(paths, isNotEmpty);

      final String filePath = paths.first.toString();
      expect(filePath, contains('WHO_Report_Gaza_Al-Shifa_Hospital.doc'));
      
      final generatedFile = File(filePath);
      expect(generatedFile.existsSync(), isTrue);

      final content = await generatedFile.readAsString();
      expect(content, contains('WHO Assessment Report'));
      expect(content, contains('Gaza Al-Shifa Hospital'));
      expect(content, contains('Dr. John Doe'));
      expect(content, contains('john.doe@who.int'));
      expect(content, contains('Screening and Triage Area'));
      expect(content, contains('33%')); 
    });
  });
}
