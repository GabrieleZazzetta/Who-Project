import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assessment_tool/screens/settings_screen.dart';
import 'package:assessment_tool/providers/locale_provider.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/services/sync_service.dart';
import 'package:assessment_tool/providers/database_provider.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/repositories/sync_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';

class MockDatabaseService extends Mock implements DatabaseService {}
class MockAuthService extends Mock implements AuthService {}
class MockSyncService extends AsyncNotifier<SyncState> implements SyncNotifier {
  final SyncState initialState;
  MockSyncService(this.initialState);
  
  @override
  Future<SyncState> build() async => initialState;

  @override
  Future<void> syncAll({int attempt = 0, bool forcePullAll = false}) async {}

  @override
  Future<void> pushPendingData() async {}
  
  @override
  set repository(SyncRepository repo) {}
}

void main() {
  late MockDatabaseService mockDb;
  late MockAuthService mockAuth;

  setUp(() {
    mockDb = MockDatabaseService();
    mockAuth = MockAuthService();
    final mockSync = MockSyncService(SyncState(status: SyncStatus.idle)); // ignore: unused_local_variable
    SharedPreferences.setMockInitialValues({'locale': 'en'});

    when(() => mockDb.getCurrentSession()).thenAnswer((_) async => UserSession()
      ..email = 'test@who.int'
      ..displayName = 'Test User'
      ..isWhoStaff = true);
    
    when(() => mockDb.getAllAssessments()).thenAnswer((_) async => []);
    when(() => mockDb.getDirtyAssessments()).thenAnswer((_) async => []);
  });

  SyncState currentSyncState = SyncState(status: SyncStatus.idle);

  Widget createTestApp(Widget child) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => child,
            ),
            GoRoute(
              path: '/login',
              builder: (context, state) => const Scaffold(body: Text('Login Screen')),
            ),
          ],
        );

        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(snapshot.data!),
            databaseServiceProvider.overrideWithValue(mockDb),
            authServiceProvider.overrideWithValue(mockAuth),
            syncProvider.overrideWith(() => MockSyncService(currentSyncState)),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        );
      }
    );
  }

  group('SettingsScreen Tests', () {
    testWidgets('renders tablet layout and changes language', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Mount SettingsScreen in tablet layout
      await tester.pumpWidget(createTestApp(const SettingsScreen()));
      await tester.pumpAndSettle();

      // Validate language tile rendering
      final languageTile = find.text('Language');
      expect(languageTile, findsOneWidget);

      // Execute language tile tap to open bottom sheet
      await tester.tap(languageTile);
      await tester.pumpAndSettle();

      // Validate locale option rendering
      final italianoOption = find.text('Italiano');
      expect(italianoOption, findsOneWidget);

      // Execute specific locale selection
      await tester.tap(italianoOption);
      await tester.pumpAndSettle();
    });

    testWidgets('renders mobile layout and changes language', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Mount SettingsScreen in mobile layout
      await tester.pumpWidget(createTestApp(
        const MediaQuery(
          data: MediaQueryData(size: Size(400, 800)),
          child: SettingsScreen(),
        ),
      ));
      await tester.pumpAndSettle();

      // Validate scroll interaction
      final languageTile = find.text('Language');
      await tester.dragFrom(const Offset(200, 400), const Offset(0, -400));
      await tester.pumpAndSettle();
      
      // Execute language tile tap to open bottom sheet
      await tester.tap(languageTile);
      await tester.pumpAndSettle();

      // Validate locale option rendering
      final espanolOption = find.text('Español');
      expect(espanolOption, findsOneWidget);

      // Execute specific locale selection
      await tester.tap(espanolOption);
      await tester.pumpAndSettle();
    });

    testWidgets('opens user profile modal', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      await tester.pumpWidget(createTestApp(const SettingsScreen()));
      await tester.pumpAndSettle();

      // Execute profile tile tap to open modal
      final profileTile = find.text('User Profile');
      await tester.tap(profileTile);
      await tester.pumpAndSettle();

      // Validate profile modal data rendering
      expect(find.text('Test User'), findsWidgets);
      expect(find.text('test@who.int'), findsWidgets);

      // Execute save action to persist local profile changes
      final saveBtn = find.text('Save Changes');
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();
    });

    testWidgets('logout without dirty data proceeds directly', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      when(() => mockAuth.logout()).thenAnswer((_) async {});

      await tester.pumpWidget(createTestApp(const SettingsScreen()));
      await tester.pumpAndSettle();

      await tester.dragFrom(const Offset(200, 400), const Offset(0, -400));
      await tester.pumpAndSettle();

      final logoutBtn = find.text('Log Out');
      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('logout with dirty data shows warning dialog and cancels', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      when(() => mockDb.getDirtyAssessments()).thenAnswer((_) async => [
        FacilityLayout()..isDirty = true
      ]);

      await tester.pumpWidget(createTestApp(const SettingsScreen()));
      await tester.pumpAndSettle();

      await tester.dragFrom(const Offset(200, 400), const Offset(0, -400));
      await tester.pumpAndSettle();

      final logoutBtn = find.text('Log Out');
      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      // Validate warning dialog rendering
      expect(find.byType(AlertDialog), findsOneWidget);
      
      // Execute dialog cancellation
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      
      // Validate navigation cancellation
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Login Screen'), findsNothing);
    });
    
    testWidgets('logout with dirty data shows warning dialog and confirms', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      when(() => mockDb.getDirtyAssessments()).thenAnswer((_) async => [
        FacilityLayout()..isDirty = true
      ]);
      when(() => mockAuth.logout()).thenAnswer((_) async {});

      await tester.pumpWidget(createTestApp(const SettingsScreen()));
      await tester.pumpAndSettle();

      await tester.dragFrom(const Offset(200, 400), const Offset(0, -400));
      await tester.pumpAndSettle();

      final logoutBtn = find.text('Log Out');
      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      // Validate warning dialog rendering
      expect(find.byType(AlertDialog), findsOneWidget);
      
      // Execute logout confirmation
      await tester.tap(find.text('Logout & Lose Data'));
      await tester.pumpAndSettle();
      
      // Validate navigation to login
      expect(find.text('Login Screen'), findsOneWidget);
    });
    
    testWidgets('sync string displays correctly when syncing', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final syncingState = SyncState(status: SyncStatus.syncing);
      currentSyncState = syncingState;

      when(() => mockDb.getAllAssessments()).thenAnswer((_) async => [
        FacilityLayout()..isDirty = true
      ]);

      await tester.pumpWidget(createTestApp(const SettingsScreen()));
      await tester.pump(const Duration(milliseconds: 100)); // Advance asynchronous execution
      await tester.pump(const Duration(milliseconds: 100)); // Render subsequent frames
      await tester.pump(const Duration(seconds: 1)); // Advance UI animations

      expect(find.text('Synchronizing data...'), findsOneWidget);
    });
    
    testWidgets('sync string displays correctly when error', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final errorState = SyncState(status: SyncStatus.error);
      currentSyncState = errorState;

      when(() => mockDb.getAllAssessments()).thenAnswer((_) async => [
        FacilityLayout()..isDirty = true
      ]);

      await tester.pumpWidget(createTestApp(const SettingsScreen()));
      await tester.pump(const Duration(milliseconds: 100)); // Advance asynchronous execution
      await tester.pump(const Duration(milliseconds: 100)); // Render subsequent frames
      await tester.pump(const Duration(seconds: 1)); // Advance UI animations

      expect(find.text('Sync failed. Tap to retry.'), findsOneWidget);
    });
  });
}
