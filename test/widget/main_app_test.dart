import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_tool/main.dart';
import 'package:assessment_tool/providers/locale_provider.dart';
import 'package:assessment_tool/services/database_service.dart';

import 'dart:io';
import 'package:isar/isar.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';

import '../helpers/mocks.dart';

void main() {
  late Isar testIsar;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    tempDir = Directory.systemTemp.createTempSync();
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    DatabaseService.instance.setTestIsar(testIsar);
  });

  tearDownAll(() async {
    await testIsar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      try { tempDir.deleteSync(recursive: true); } catch (e) {}
    }
  });

  testWidgets('WHOAssessmentApp renders and configures router and theme', (tester) async {
    // 1. Setup dependencies
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // 2. Pump the root App widget with ProviderScope
    await tester.runAsync(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            // The DatabaseService and others are mocked inside setUpAll typically,
            // but we can just use the real mock isar here.
          ],
          child: const WHOAssessmentApp(initialLocation: '/login'),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 300));
    });
    
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 3. Verify it routed to LoginScreen (which renders an AppBar or specific widgets)
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // LoginScreen has a text "WHO Health Facilities Assessment" in the header
    expect(find.textContaining('Health Facilities'), findsWidgets);
  });
}
