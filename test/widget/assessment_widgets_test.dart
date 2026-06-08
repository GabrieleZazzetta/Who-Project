import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:assessment_tool/screens/assessment_screen.dart';
import 'package:assessment_tool/screens/pre_assessment_screen.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

void main() {
  // TEST SUITE: ASSESSMENT WIDGETS
  group('Assessment Widgets Tests', () {

    // ASSESSMENT SCREEN
    group('AssessmentScreen Tests', () {
      testWidgets('renders questions and updates compliance', (WidgetTester tester) async {
        // Setup device viewport
        tester.view.physicalSize = const Size(1200, 1000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());

        // Provision initial test data
        final testQuestion = AssessmentQuestion(id: 'q_1', text: 'Is the facility clean?');
        final zone = SpatialZone(id: 'z_1', name: 'Test Zone', checklist: [testQuestion]);

        final router = GoRouter(
          initialLocation: '/',
          routes: [GoRoute(path: '/', builder: (context, state) => AssessmentScreen(zone: zone))],
        );

        // Mount widget
        await tester.pumpWidget(MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
        await tester.pumpAndSettle();

        // Validate initial rendering
        expect(find.text('Test Zone'), findsOneWidget);
        expect(find.text('Is the facility clean?'), findsOneWidget);

        // Execute compliance update to Meets Target
        final meetsTargetIcon = find.byIcon(Icons.check_circle);
        await tester.ensureVisible(meetsTargetIcon);
        await tester.tap(meetsTargetIcon);
        await tester.pumpAndSettle();

        expect(testQuestion.selectedCompliance, ComplianceLevel.meetsTarget);

        // Execute compliance update to Partially Meets
        final partiallyMeetsIcon = find.byIcon(Icons.warning_amber_rounded);
        await tester.ensureVisible(partiallyMeetsIcon);
        await tester.tap(partiallyMeetsIcon);
        await tester.pumpAndSettle();

        expect(testQuestion.selectedCompliance, ComplianceLevel.partiallyMeets);
        expect(find.byIcon(Icons.lightbulb), findsOneWidget);

        // Execute note addition flow
        final addNoteButton = find.byIcon(Icons.edit_note);
        await tester.ensureVisible(addNoteButton);
        await tester.tap(addNoteButton);
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
        await tester.enterText(find.byType(TextField), 'Test note');
        
        final dialogButtons = find.byType(ElevatedButton);
        await tester.tap(dialogButtons.last);
        await tester.pumpAndSettle();

        expect(testQuestion.note, 'Test note');
      });

      testWidgets('renders tablet portrait layout', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(850, 1000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());
        
        final zone = SpatialZone(id: 'z_1', name: 'Test Zone', checklist: [AssessmentQuestion(id: 'q_1', text: 'Q1')]);
        
        await tester.pumpWidget(MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AssessmentScreen(zone: zone)
        ));
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.byType(AssessmentScreen), findsOneWidget);
      });

      testWidgets('renders mobile portrait layout', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());
        
        final zone = SpatialZone(id: 'z_1', name: 'Test Zone', checklist: [AssessmentQuestion(id: 'q_1', text: 'Q1')]);
        
        await tester.pumpWidget(MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AssessmentScreen(zone: zone)
        ));
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.byType(AssessmentScreen), findsOneWidget);
      });
    });

    // PRE-ASSESSMENT SCREEN
    group('PreAssessmentScreen Tests', () {
      testWidgets('renders all steps and completes pre-assessment form', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 1000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());

        bool mapScreenVisited = false;
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(path: '/', builder: (context, state) => const PreAssessmentScreen(emergencyType: EmergencyType.mpox, facilityType: FacilityType.existingFacilityWithWard)),
            GoRoute(path: '/map', builder: (context, state) {
              mapScreenVisited = true;
              return const Scaffold(body: Text('Map Screen Placeholder'));
            }),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
        await tester.pumpAndSettle();

        // Validate step 1 rendering
        expect(find.byType(PreAssessmentScreen), findsOneWidget);
        expect(find.byIcon(Icons.person_pin), findsWidgets);
        
        await tester.enterText(find.byType(TextFormField).first, 'Test Facility Name');
        await tester.pump();

        // Execute step 1 completion
        final btn1 = find.byType(ElevatedButton).first;
        await tester.ensureVisible(btn1);
        await tester.tap(btn1);
        await tester.pumpAndSettle();
        
        // Validate step 2 rendering
        expect(find.byIcon(Icons.location_on), findsWidgets);

        // Execute step 2 completion
        final btn2 = find.byType(ElevatedButton).first;
        await tester.ensureVisible(btn2);
        await tester.tap(btn2);
        await tester.pumpAndSettle();
        
        // Validate step 3 rendering
        expect(find.byIcon(Icons.local_hospital), findsWidgets);

        // Execute step 3 completion
        final btn3 = find.byType(ElevatedButton).first;
        await tester.ensureVisible(btn3);
        await tester.tap(btn3);
        await tester.pumpAndSettle();
        
        // Validate step 4 rendering
        expect(find.byIcon(Icons.medical_services), findsWidgets);
        expect(find.text('Start Assessment'), findsWidgets);

        // Execute final submission
        final btnSubmit = find.byType(ElevatedButton).first;
        await tester.ensureVisible(btnSubmit);
        await tester.tap(btnSubmit);
        await tester.pump();
        await tester.pumpAndSettle();

        // Validate routing to map screen
        expect(mapScreenVisited, isTrue);
        expect(find.text('Map Screen Placeholder'), findsOneWidget);
      });

      testWidgets('renders tablet portrait layout', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(850, 1000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());
        
        await tester.pumpWidget(MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PreAssessmentScreen(emergencyType: EmergencyType.mpox, facilityType: FacilityType.existingFacilityWithWard)
        ));
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.byType(PreAssessmentScreen), findsOneWidget);
      });

      testWidgets('renders mobile portrait layout', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());
        
        await tester.pumpWidget(MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PreAssessmentScreen(emergencyType: EmergencyType.mpox, facilityType: FacilityType.existingFacilityWithWard)
        ));
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.byType(PreAssessmentScreen), findsOneWidget);
      });
    });

    // CAMERA PERMISSIONS
    group('Camera & Image Acquisition Tests', () {
      const channel = MethodChannel('plugins.flutter.io/image_picker');
      bool shouldFail = false;

      setUpAll(() {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (FlutterErrorDetails details) {
          if (details.exceptionAsString().contains('overflowed')) return;
          originalOnError?.call(details);
        };

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'pickImage' || methodCall.method == 'pickMedia') {
            if (shouldFail) {
              throw PlatformException(code: 'camera_access_denied', message: 'Camera permission was denied by the user.');
            }
            return '/tmp/fake_evidence.jpg';
          }
          return null;
        });
      });

      tearDownAll(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
      });

      testWidgets('Camera Permissions Denied: Shows permission dialog on exception', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        
        // Inject permission failure
        shouldFail = true;

        final dummyZone = SpatialZone(
          id: 'z_fire_test',
          name: 'Fire Safety Area',
          checklist: [AssessmentQuestion(id: 'q_evidence_test', text: 'Verify the fire safety escape route.', selectedCompliance: ComplianceLevel.pending)],
        );

        await tester.pumpWidget(MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: AssessmentScreen(zone: dummyZone)),
        ));
        await tester.pumpAndSettle();

        // Execute camera invocation
        final addPhotoBtn = find.text("Add Photo");
        await tester.tap(addPhotoBtn);
        await tester.pumpAndSettle();

        final takePhotoOption = find.text('Take a Photo');
        await tester.tap(takePhotoOption);
        await tester.pumpAndSettle();

        // Validate dialog rendering
        expect(find.text("Camera Access Required"), findsOneWidget);

        // Execute dialog dismissal
        final understoodBtn = find.byKey(const Key('btn_close_permission_dialog'));
        await tester.tap(understoodBtn);
        await tester.pumpAndSettle();

        expect(find.text("Camera Access Required"), findsNothing);
      });

      testWidgets('Camera Image Acquisition: Saves path and displays thumbnail', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        
        // Inject success state
        shouldFail = false;

        final dummyQuestion = AssessmentQuestion(id: 'q_photo_test', text: 'Verify standard isolation signage.', selectedCompliance: ComplianceLevel.meetsTarget);
        final dummyZone = SpatialZone(id: 'z_signage_test', name: 'Signage Verification', checklist: [dummyQuestion]);

        await tester.pumpWidget(MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: AssessmentScreen(zone: dummyZone)),
        ));
        await tester.pumpAndSettle();

        // Execute camera invocation
        final addPhotoBtn = find.text("Add Photo");
        await tester.tap(addPhotoBtn);
        await tester.pumpAndSettle();

        final takePhotoOption = find.text('Take a Photo');
        await tester.tap(takePhotoOption);
        await tester.pumpAndSettle();

        // Validate state update and UI rendering
        expect(find.text("Camera Access Required"), findsNothing);
        expect(dummyQuestion.mediaPaths, isNotNull);
        expect(dummyQuestion.mediaPaths!.contains('/tmp/fake_evidence.jpg'), isTrue);

        final mediaGalleryFinder = find.byType(GestureDetector);
        expect(mediaGalleryFinder, findsAtLeastNWidgets(1));
      });
    });

  });
}
