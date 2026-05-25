import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/providers/locale_provider.dart';
import 'package:assessment_tool/screens/main_dashboard_screen.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

import 'utils/fake_services.dart';

void main() {
  late Isar testIsar;
  late Directory tempDir;
  late SharedPreferences prefs;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: false);
    tempDir = Directory.systemTemp.createTempSync('isar_widget_main_dashboard_test');
    testIsar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: tempDir.path,
    );
    DatabaseService.instance.setTestIsar(testIsar);
    
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    
// removed custom error handler
  });

  tearDownAll(() async {
    testIsar.close();
    if(tempDir.existsSync()){try{tempDir.deleteSync(recursive:true);}catch(e){}}
  });
  
  setUp(() async {
    await testIsar.writeTxn(() async {
      await testIsar.facilityLayouts.clear();
      await testIsar.userSessions.clear();
      await testIsar.localUserCredentials.clear();
    });
  });

  group('MainDashboardScreen Widget Tests', () {
    testWidgets('renders home content with outbreak cards', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      final fakeAuthService = FakeAuthService();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuthService),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MainDashboardScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      debugDumpApp();
      
      print("Scaffolds found: ${find.byType(Scaffold).evaluate().length}");
      print("HomeContent found: ${find.byType(HomeContent).evaluate().length}");
      print("MainDashboardScreen found: ${find.byType(MainDashboardScreen).evaluate().length}");
      
      // Controlla la presenza dei titoli delle card
      expect(find.text('Mpox Outbreak'), findsOneWidget);
      expect(find.text('Ebola Virus Disease'), findsOneWidget);
      expect(find.text('SARI / COVID-19'), findsOneWidget);
      
      // Controlla che le badge attive e presto siano renderizzate
      expect(find.text('ACTIVE'), findsWidgets);
      expect(find.text('SOON'), findsWidgets);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });

    testWidgets('info dialog opens on info button tap', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      final fakeAuthService = FakeAuthService();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuthService),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MainDashboardScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      // Trova e tocca l'icona info
      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pump();
      await tester.pumpAndSettle();

      // Controlla che il dialogo info sia aperto
      expect(find.text('WHO Assessment Tool'), findsOneWidget);
      
      // Chiudi il dialogo
      await tester.tap(find.text('Close'));
      await tester.pump();
      await tester.pumpAndSettle();
      
      expect(find.text('WHO Assessment Tool'), findsNothing);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });
    
    testWidgets('bottom navigation changes tabs', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      final fakeAuthService = FakeAuthService();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuthService),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MainDashboardScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      // Siamo sulla Home (Dashboard)
      expect(find.text('Mpox Outbreak'), findsOneWidget);

      // Tocca tab Impostazioni (Settings) - Nella bottom bar
      // Cerchiamo per icona o testo
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();
      await tester.pumpAndSettle();

      // Verifica che siamo nella schermata Settings
      expect(find.text('ACCOUNT & SYNC'), findsOneWidget);
      expect(find.text('Mpox Outbreak'), findsNothing);
      
      // Torna alla Home
      await tester.tap(find.byIcon(Icons.home_filled));
      await tester.pump();
      await tester.pumpAndSettle();
      
      expect(find.text('Mpox Outbreak'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });
    
    testWidgets('tablet landscape shows navigation rail', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(2000, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      final fakeAuthService = FakeAuthService();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuthService),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MainDashboardScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      // Verifica Sidebar espansa visibile cercando elementi specifici del drawer premium
      expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
      
      // Cambia tab a Settings dalla sidebar
      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('ACCOUNT & SYNC'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });
  });
}
