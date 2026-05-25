import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:isar/isar.dart';
import 'dart:io';

import 'package:assessment_tool/screens/interactive_map_screen.dart';
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
    tempDir = Directory.systemTemp.createTempSync('map_test');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
      name: 'map_test_instance_${DateTime.now().millisecondsSinceEpoch}',
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
      home: const InteractiveMapScreen(
        emergencyType: EmergencyType.mpox,
        facilityType: FacilityType.standAloneCenter,
      ),
    );
  }

  group('InteractiveMapScreen Widget Tests', () {
    testWidgets('renders map screen and pinch-to-explore text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      
      expect(find.text('Spatial Assessment'), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(find.text('Pinch to explore. Tap highlighted pins to evaluate.'), findsWidgets);
    });

    testWidgets('has general assessment and list buttons in appbar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      
      expect(find.byIcon(Icons.assignment_outlined), findsOneWidget);
      expect(find.byIcon(Icons.domain_verification), findsOneWidget);
    });
  });
}
