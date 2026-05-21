import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'firebase_options.dart';
import 'models/assessment_models.dart';
import 'services/database_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_dashboard_screen.dart';
import 'screens/facility_selection_screen.dart';
import 'screens/pre_assessment_screen.dart';
import 'screens/interactive_map_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/advanced_analytics_screen.dart';
import 'screens/assessment_screen.dart';
import 'screens/global_map_screen_3d.dart';

// STATO GLOBALE FIREBASE
// Previene crash critici ("Lost connection to device") se GMS non è disponibile
bool isFirebaseInitialized = false;

// AVVIO DELL'APPLICAZIONE
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // INIZIALIZZAZIONE FIREBASE
  // Gestione robusta per tablet senza Google Play Services (GMS)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    isFirebaseInitialized = true;
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
    isFirebaseInitialized = false;
    // L'app continuerà a funzionare in modalità locale (offline-first)
  }



  // INIZIALIZZAZIONE DATABASE LOCALE
  await DatabaseService.instance.init();

  // INIZIALIZZAZIONE PREFERENCES
  final prefs = await SharedPreferences.getInstance();

  // CONTROLLO SESSIONE LOCALE (Hybrid Auth)
  final session = await DatabaseService.instance.getCurrentSession();
  final String initialLocation = (session != null && session.isLoggedIn) ? '/' : '/login';

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: WHOAssessmentApp(initialLocation: initialLocation),
    ),
  );
}

// LOGICA DI ROUTING GLOBALE
// Definizione delle rotte dell'applicazione tramite go_router
GoRouter _buildRouter(String initialLocation) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    // Accesso iniziale
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // Registrazione nuovi utenti
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    // Dashboard principale e selezione moduli
    GoRoute(
      path: '/',
      builder: (context, state) {
        final initialIndex = state.extra is int ? state.extra as int : 0;
        return MainDashboardScreen(initialIndex: initialIndex);
      },
      routes: [
        GoRoute(
          path: 'facility-selection',
          builder: (context, state) {
            final emergency = state.extra as EmergencyType;
            return FacilitySelectionScreen(emergency: emergency);
          },
        ),
      ],
    ),
    // Configurazione pre-assessment
    GoRoute(
      path: '/pre-assessment',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return PreAssessmentScreen(
          emergencyType: data['emergencyType'] as EmergencyType,
          facilityType: data['facilityType'] as FacilityType,
        );
      },
    ),
    // Mappa interattiva e gestione dati spaziali
    GoRoute(
      path: '/map',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return InteractiveMapScreen(
          emergencyType: data['emergencyType'] as EmergencyType,
          facilityType: data['facilityType'] as FacilityType,
          assessmentId: data['assessmentId'] as int?,
          preFilledData: data['preFilledData'] as FacilityLayout?,
        );
      },
    ),
    // Analisi e reportistica
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const AnalyticsScreen(),
    ),
    // Analisi avanzata con grafici dettagliati
    GoRoute(
      path: '/advanced-analytics',
      builder: (context, state) {
        final data = state.extra as List<FacilityLayout>;
        return AdvancedAnalyticsScreen(data: data);
      },
    ),
    // Mappa globale 3D delle strutture
    GoRoute(
      path: '/global-map',
      builder: (context, state) => const GlobalMapScreen3D(),
    ),
    // Valutazione specifica di una zona o modulo
    GoRoute(
      path: '/assessment',
      builder: (context, state) {
        final zone = state.extra as SpatialZone;
        return AssessmentScreen(zone: zone);
      },
    ),
  ],
);

// CONFIGURAZIONE APP
class WHOAssessmentApp extends ConsumerStatefulWidget {
  final String initialLocation;
  const WHOAssessmentApp({super.key, required this.initialLocation});

  @override
  ConsumerState<WHOAssessmentApp> createState() => _WHOAssessmentAppState();
}

class _WHOAssessmentAppState extends ConsumerState<WHOAssessmentApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = _buildRouter(widget.initialLocation);
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp.router(
      title: 'WHO Health Facilities Assessment',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Public Sans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005DA8),
          primary: const Color(0xFF005DA8),
          surface: const Color(0xFFF5F7F8),
        ),
      ),
    );
  }
}
