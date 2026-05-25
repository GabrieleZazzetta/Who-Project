import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/screens/assessments_list_screen.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

void main() {
  late Isar testIsar;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: false);
    tempDir = Directory.systemTemp.createTempSync('isar_widget_list_test');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    DatabaseService.instance.setTestIsar(testIsar);
  });

  tearDownAll(() async {
    testIsar.close();
    if(tempDir.existsSync()){try{tempDir.deleteSync(recursive:true);}catch(e){}}
  });

  group('AssessmentsListScreen Widget Tests', () {
    setUpAll(() {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('overflowed')) {
          return;
        }
        originalOnError?.call(details);
      };
    });

    testWidgets('should render empty state placeholder when no assessments exist', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.runAsync(() async {
        // Clear DB safely inside runAsync
        await testIsar.writeTxn(() async {
          await testIsar.facilityLayouts.clear();
        });

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: AssessmentsListScreen(),
            ),
          ),
        );
        // Consente la risoluzione delle chiamate asincrone Isar
        await Future.delayed(const Duration(milliseconds: 200));
        await tester.pump();

        expect(find.text("No assessments match your filters."), findsOneWidget);
      });
    });

    testWidgets('should render assessment cards and search bar', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.runAsync(() async {
        // Clear DB safely
        await testIsar.writeTxn(() async {
          await testIsar.facilityLayouts.clear();
        });

        // Save a sample assessment in database
        final facility = FacilityLayout(
          facilityName: 'Clinic Geneva',
          emergencyType: EmergencyType.mpox,
          isDirty: true,
        );
        await DatabaseService.instance.saveAssessment(facility);

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: AssessmentsListScreen(),
            ),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 200));
        await tester.pump();

        // Card is rendered
        expect(find.text("Clinic Geneva"), findsAtLeastNWidgets(1));
        expect(find.byType(Card), findsAtLeastNWidgets(1));

        // Sync indicator icon is present
        expect(find.byIcon(Icons.cloud_upload_outlined), findsOneWidget);
      });
    });

    testWidgets('should filter list dynamically when typing in search bar', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.runAsync(() async {
        // Clear DB safely
        await testIsar.writeTxn(() async {
          await testIsar.facilityLayouts.clear();
        });

        // Save two sample assessments
        await DatabaseService.instance.saveAssessment(FacilityLayout(facilityName: 'Clinic Rome'));
        await DatabaseService.instance.saveAssessment(FacilityLayout(facilityName: 'Clinic London'));

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: AssessmentsListScreen(),
            ),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 200));
        await tester.pump();

        expect(find.text("Clinic Rome"), findsAtLeastNWidgets(1));
        expect(find.text("Clinic London"), findsAtLeastNWidgets(1));

        final searchFieldFinder = find.byType(TextField).first;
        await tester.enterText(searchFieldFinder, "Rome");

        await tester.pump();
        await Future.delayed(const Duration(milliseconds: 200));
        await tester.pump();

        // Rome is found, London is filtered out
        expect(find.text("Clinic Rome"), findsAtLeastNWidgets(1));
        expect(find.text("Clinic London"), findsNothing);
      });
    });
  });
}
