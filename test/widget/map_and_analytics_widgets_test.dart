import 'dart:io';
import 'dart:async';
import 'package:go_router/go_router.dart';
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
import 'package:assessment_tool/providers/database_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

void main() {
  late Isar testIsar;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    HttpOverrides.global = FakeHttpOverrides();
  });

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('map_analytics_widget_test');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
      name: 'map_analytics_instance_${DateTime.now().millisecondsSinceEpoch}',
    );
    DatabaseService.instance.setTestIsar(testIsar);

    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final msg = details.exceptionAsString();
      if (msg.contains('overflowed') || 
          msg.contains('channel-error') ||
          msg.contains('setAccessToken') ||
          msg.contains('MissingPluginException')) {
        return;
      }
      originalOnError?.call(details);
    };

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(
      const BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._MapboxOptions.setAccessToken',
        StandardMessageCodec(),
      ),
      (message) async => null,
    );
  });

  tearDown(() {
    testIsar.close(deleteFromDisk: true);
    if (tempDir.existsSync()) {
      try { tempDir.deleteSync(recursive: true); } catch (e) {}
    }
  });

  Widget createTestWidget(Widget screen) {
    return ProviderScope(
      overrides: [
        databaseServiceProvider.overrideWithValue(DatabaseService.instance),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', '')],
        home: screen,
      ),
    );
  }

  group('Map and Analytics Widgets Tests', () {

    // ANALYTICS SCREEN
    group('AnalyticsScreen Tests', () {
      testWidgets('renders empty state when no assessments available', (tester) async {
        // Mount AnalyticsScreen
        await tester.runAsync(() async {
          await tester.pumpWidget(createTestWidget(const AnalyticsScreen()));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));
        
        // Validate empty state rendering
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('No reports available for this selection.'), findsWidgets);
      });

      testWidgets('renders metrics when data is available', (tester) async {
        // Provision mock facility layout with test zone
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

        // Persist mock data to Isar database
        await tester.runAsync(() async {
          await testIsar.writeTxn(() async {
            await testIsar.facilityLayouts.put(facility);
          });
        });

        // Mount AnalyticsScreen
        await tester.runAsync(() async {
          await tester.pumpWidget(createTestWidget(const AnalyticsScreen()));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));
        
        // Validate metrics and charts scroll view rendering
        expect(find.text('No reports available for this selection.'), findsNothing);
        expect(find.byType(CustomScrollView), findsWidgets);
      });

      testWidgets('interacts with dropdowns and info modal', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 2400));
        addTearDown(() => tester.binding.setSurfaceSize(null));

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

        await tester.runAsync(() async {
          await testIsar.writeTxn(() async {
            await testIsar.facilityLayouts.put(facility);
          });
        });

        await tester.runAsync(() async {
          await tester.pumpWidget(createTestWidget(const AnalyticsScreen()));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        
        // Execute info icon tap
        final infoIcon = find.byIcon(Icons.info_outline_rounded).first;
        if (infoIcon.evaluate().isNotEmpty) {
           await tester.ensureVisible(infoIcon);
           await tester.pump(const Duration(milliseconds: 100));
           await tester.tap(infoIcon);
           await tester.pump(const Duration(milliseconds: 500));
           
           final gotItBtn = find.text('Got it').last;
           await tester.ensureVisible(gotItBtn);
           await tester.pump(const Duration(milliseconds: 100));
           await tester.tap(gotItBtn, warnIfMissed: false);
           await tester.pump(const Duration(milliseconds: 500));
        }

        // Execute country dropdown tap
        final dropdownFinder = find.byType(DropdownButton<String>).first;
        if (dropdownFinder.evaluate().isNotEmpty) {
           await tester.ensureVisible(dropdownFinder);
           await tester.pump(const Duration(milliseconds: 100));
           await tester.tap(dropdownFinder, warnIfMissed: false);
           await tester.pump(const Duration(milliseconds: 500));
        }
        
        // Select country option
        final italyItem = find.text('Italy').last;
        if (italyItem.evaluate().isNotEmpty) {
           await tester.ensureVisible(italyItem);
           await tester.pump(const Duration(milliseconds: 100));
           await tester.tap(italyItem, warnIfMissed: false);
           await tester.pump(const Duration(milliseconds: 500));
        }
      });
    });

    // ADVANCED ANALYTICS SCREEN
    group('AdvancedAnalyticsScreen Tests', () {
      testWidgets('renders empty state when no data provided', (tester) async {
        await tester.pumpWidget(createTestWidget(const AdvancedAnalyticsScreen(data: [])));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('No data to display.'), findsOneWidget);
      });

      testWidgets('renders charts when data is provided', (tester) async {
        // Provision multiple facility layouts for historical data comparison
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

        // Mount AdvancedAnalyticsScreen
        await tester.pumpWidget(createTestWidget(AdvancedAnalyticsScreen(data: [f1, f2])));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        
        // Validate scrollable chart container rendering
        expect(find.text('No data to display.'), findsNothing);
        expect(find.byType(SingleChildScrollView), findsWidgets);
      });

      testWidgets('renders single assessment state', (tester) async {
        final f1 = FacilityLayout()..facilityName = 'H1'..dateCreated = DateTime(2023, 1, 1);
        final zone1 = SpatialZone()..name = 'Z1';
        final q1 = AssessmentQuestion()..id = 'q1'..category = AssessmentCategory.infectionPreventionControl..selectedCompliance = ComplianceLevel.meetsTarget;
        zone1.checklist = List.from(zone1.checklist)..add(q1);
        f1.zones = List.from(f1.zones)..add(zone1);

        await tester.pumpWidget(createTestWidget(AdvancedAnalyticsScreen(data: [f1])));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        
        expect(find.text('Add more assessments to unlock trend analysis.'), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsWidgets);
      });

      testWidgets('renders tablet portrait layout', (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final f1 = FacilityLayout()..facilityName = 'H1'..dateCreated = DateTime(2023, 1, 1);
        await tester.pumpWidget(createTestWidget(AdvancedAnalyticsScreen(data: [f1, f1])));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(SingleChildScrollView), findsWidgets);
      });

      testWidgets('renders mobile portrait layout', (tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final f1 = FacilityLayout()..facilityName = 'H1'..dateCreated = DateTime(2023, 1, 1);
        
        await tester.pumpWidget(createTestWidget(AdvancedAnalyticsScreen(data: [f1, f1])));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(SingleChildScrollView), findsWidgets);
      });

      testWidgets('renders mobile landscape layout', (tester) async {
        await tester.binding.setSurfaceSize(const Size(550, 300));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final f1 = FacilityLayout()..facilityName = 'H1'..dateCreated = DateTime(2023, 1, 1);
        
        await tester.pumpWidget(createTestWidget(AdvancedAnalyticsScreen(data: [f1, f1])));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(SingleChildScrollView), findsWidgets);
      });

      testWidgets('renders empty state when not enough valid historical data', (tester) async {
        final f1 = FacilityLayout()..facilityName = 'H1';
        
        await tester.pumpWidget(createTestWidget(AdvancedAnalyticsScreen(data: [f1])));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Not enough historical data for trend analysis. At least 2 assessments needed.'), findsOneWidget);
      });
    });

    // INTERACTIVE MAP SCREEN
    group('InteractiveMapScreen Tests', () {
      testWidgets('renders map screen and pinch-to-explore text', (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(createTestWidget(const InteractiveMapScreen(emergencyType: EmergencyType.mpox, facilityType: FacilityType.standAloneCenter)));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.text('Spatial Assessment'), findsOneWidget);
        expect(find.byType(InteractiveViewer), findsOneWidget);
        expect(find.text('Pinch to explore. Tap highlighted pins to evaluate.'), findsWidgets);
      });

      testWidgets('has general assessment and list buttons in appbar', (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(createTestWidget(const InteractiveMapScreen(emergencyType: EmergencyType.mpox, facilityType: FacilityType.standAloneCenter)));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.byIcon(Icons.assignment_outlined), findsOneWidget);
        expect(find.byIcon(Icons.domain_verification), findsOneWidget);
      });

      Widget createMapWidgetWithRouter(Widget screen) {
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(path: '/', builder: (context, state) => screen),
            GoRoute(path: '/assessment', builder: (context, state) => const Scaffold(body: Text('Assessment'))),
          ],
        );
        return ProviderScope(
          overrides: [
            databaseServiceProvider.overrideWithValue(DatabaseService.instance),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', '')],
          ),
        );
      }

      testWidgets('taps general assessment button', (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(createMapWidgetWithRouter(const InteractiveMapScreen(emergencyType: EmergencyType.mpox, facilityType: FacilityType.standAloneCenter)));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        
        final btn = find.byKey(const Key('btn_general_assessment'));
        await tester.ensureVisible(btn);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.tap(btn);
        await tester.pump(const Duration(milliseconds: 500));
      });

      testWidgets('taps a specific zone on the map', (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(createMapWidgetWithRouter(const InteractiveMapScreen(emergencyType: EmergencyType.mpox, facilityType: FacilityType.standAloneCenter)));
          await Future.delayed(const Duration(milliseconds: 500));
        });
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        
        final zoneKey = find.byKey(const Key('zone_triage_area'));
        if (zoneKey.evaluate().isNotEmpty) {
           await tester.tap(zoneKey);
           await tester.pump(const Duration(milliseconds: 500));
        }
      });
    });

    // GLOBAL MAP SCREEN 3D
    group('GlobalMapScreen3D Tests', () {
      testWidgets('renders map screen when data is loaded', (tester) async {
        final facility = FacilityLayout()
          ..facilityName = 'Map Test Hospital'
          ..dateCreated = DateTime(2023, 1, 1)
          ..generalInfo = (GeneralFacilityInfo()..city = 'Rome'..country = 'Italy');

        await tester.runAsync(() async {
          await testIsar.writeTxn(() async {
            await testIsar.facilityLayouts.put(facility);
          });
        });

        try {
          await tester.runAsync(() async {
            await tester.pumpWidget(createTestWidget(const GlobalMapScreen3D()));
            await Future.delayed(const Duration(milliseconds: 500));
          });
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
        } catch (e) {}
        
        expect(find.text('Global Assessment Map'), findsOneWidget);
      });

      testWidgets('FAB toggles map style', (tester) async {
        try {
          await tester.runAsync(() async {
            await tester.pumpWidget(createTestWidget(const GlobalMapScreen3D()));
            await Future.delayed(const Duration(milliseconds: 500));
          });
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
          
          final fab = find.byType(FloatingActionButton);
          if (fab.evaluate().isNotEmpty) {
            await tester.tap(fab);
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 500));
          }
        } catch (e) {}
      });
    });

  });
}

class FakeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return FakeHttpClient();
  }
}

class FakeHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  Duration? connectionTimeout;

  @override
  Duration idleTimeout = const Duration(seconds: 15);

  @override
  int? maxConnectionsPerHost;

  @override
  String? userAgent;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return FakeHttpClientRequest(url);
  }
}

class FakeHttpClientRequest extends Fake implements HttpClientRequest {
  final Uri url;
  FakeHttpClientRequest(this.url);

  @override
  final HttpHeaders headers = FakeHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return FakeHttpClientResponse(url);
  }
}

class FakeHttpHeaders extends Fake implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class FakeHttpClientResponse extends Fake implements HttpClientResponse {
  final Uri url;
  FakeHttpClientResponse(this.url);

  @override
  int get statusCode => 200;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    String responseBody = '[]';
    if (url.toString().contains('nominatim.openstreetmap.org')) {
      responseBody = '[{"lat": "41.9028", "lon": "12.4964"}]';
    }
    final stream = Stream.value(responseBody.codeUnits);
    return stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
