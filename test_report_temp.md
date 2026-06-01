# Testing Campaign Report

## 1. Alberatura delle Cartelle
```text
test/
│   helpers/
│   ├── mocks.dart
│   ├── mock_data.dart
│   └── test_wrapper.dart
│   unit/
│   ├── auth_service_test.dart
│   ├── critical_alarm_flow_test.dart
│   ├── database_and_analytics_test.dart
│   ├── engine_and_math_test.dart
│   ├── global_map_helper_test.dart
│   ├── models_test.dart
│   ├── mpox_data_test.dart
│   ├── report_export_service_test.dart
│   ├── services_test.dart
│   ├── sync_flow_test.dart
│   ├── sync_repository_test.dart
│   └── sync_service_test.dart
    widget/
    ├── assessments_list_screen_extended_test.dart
    ├── assessment_widgets_test.dart
    ├── core_widgets_test.dart
    ├── global_map_test.dart
    ├── login_screen_test.dart
    ├── main_app_test.dart
    ├── map_and_analytics_widgets_test.dart
    ├── pre_assessment_screen_test.dart
    ├── register_screen_extended_test.dart
    ├── register_screen_test.dart
    └── settings_screen_test.dart
integration_test/
├── analytics_e2e_test.dart
├── assessment_e2e_test.dart
├── auth_e2e_test.dart
├── navigation_e2e_test.dart
└── settings_e2e_test.dart
```

## 2. Unit Test
### auth_service_test.dart
- **AuthService Tests**: register creates user and saves local session
- **AuthService Tests**: login authenticates and updates local session
- **AuthService Tests**: login fallback to local auth when firebase fails
- **AuthService Tests**: login fallback fails if offline password is wrong
- **AuthService Tests**: logout clears local data and signs out from firebase
- **AuthService Tests**: syncPendingPasswordChanges syncs successfully when user is logged in
- **AuthService Tests**: syncPendingPasswordChanges does nothing if list is empty

### critical_alarm_flow_test.dart
- **Critical Alarm & Report Flow**: E2E Alarm and Report Generation: transitions to Red and exports Word doc via native share

### database_and_analytics_test.dart
- **Database integrity and Auth flows**: CRUD e Atomicità: Salvataggio, lettura e aggiornamento di FacilityLayout annidato
- **Database integrity and Auth flows**: Hashing e Login Locale: Verifica correttezza SHA256 e simulazione login offline
- **Database integrity and Auth flows**: clearSession removes user sessions
- **Database integrity and Auth flows**: getPendingPasswordSyncs retrieves correctly
- **Database integrity and Auth flows**: clearAllLocalData wipes UserSessions but preserves LocalUserCredential (logout_flaw_test)
- **Test Interruzione Transazione (ACID Rollback)**: Un fallimento a metà writeTxn deve eseguire il rollback ed escludere record corrotti o parziali
- **Analytics Aggregation Engine Computations**: IPC category score is 100% when all questions meetsTarget
- **Analytics Aggregation Engine Computations**: Trend line sorts facilities chronologically by dateCreated ascending

### engine_and_math_test.dart
- **Motore di Calcolo Compliance - Unit Tests**: Calcolo Base e Ponderazione: Risposte miste escludendo N/A e Pending
- **Motore di Calcolo Compliance - Unit Tests**: Critical Failures: Una risposta 
- **Motore di Calcolo Compliance - Unit Tests**: Aggregazione: globalReadinessScore calcolato correttamente dalle sole zone compilate
- **Motore di Calcolo Compliance - Unit Tests**: Edge Case - Division By Zero: SpatialZone senza domande o solo N/A deve restituire 0.0 e non crashare
- **Advanced Compliance Math & Domain Logic**: WHO domain validation matches case-insensitive patterns
- **Advanced Compliance Math & Domain Logic**: Readiness calculation with large mixed question list
- **Advanced Compliance Math & Domain Logic**: Zone readiness calculation with only N/A and pending questions
- **Advanced Compliance Math & Domain Logic**: Global score is 100% when all compiled zones have perfect score
- **Advanced Compliance Math & Domain Logic**: Ponderated formula is stable with combination of all compliance levels
- **Assessment Compliance Engine Logic**: Tapping a compliance level sets it on the question
- **Assessment Compliance Engine Logic**: General assessment questions group correctly by ID prefix into 4 sections
- **Assessment Compliance Engine Logic**: Zone statusColor transitions through full lifecycle
- **PreAssessment & Data Factory Logic**: Mpox ScreeningAndIsolation layout returns non-empty zones with checklists
- **PreAssessment & Data Factory Logic**: FacilityLayout facilityName defaults to 
- **PreAssessment & Data Factory Logic**: FacilityType name mapping returns correct human-readable strings

### global_map_helper_test.dart
- **GlobalMapHelper Unit Tests**: scoreColor returns correct colors
- **GlobalMapHelper Unit Tests**: parseOrGeocode returns direct coordinates if formatted lat/lng
- **GlobalMapHelper Unit Tests**: parseOrGeocode handles invalid direct coordinates and falls back to HTTP
- **GlobalMapHelper Unit Tests**: parseOrGeocode returns coordinates from Nominatim
- **GlobalMapHelper Unit Tests**: resolveLocation falls back to city and country if direct fails

### models_test.dart
- **FacilityLayout & GeneralFacilityInfo Unit Tests**: should initialize FacilityLayout with correct default values
- **FacilityLayout & GeneralFacilityInfo Unit Tests**: should correctly assign FacilityLayout constructor parameters
- **globalReadinessScore Calculations**: should return 0.0 when zones is empty
- **globalReadinessScore Calculations**: should return 0.0 when all zones are empty or have 0% completionPercentage
- **globalReadinessScore Calculations**: should return correct mathematical average of only zones with completion > 0%
- **globalReadinessScore Calculations**: should allow setting GeneralFacilityInfo parameters correctly
- **globalReadinessScore Calculations**: should enforce UTC timezones on all timestamps
- **globalReadinessScore Calculations**: should handle all EmergencyType and FacilityType enums
- **AssessmentQuestion Unit Tests**: should initialize with correct default values
- **AssessmentQuestion Unit Tests**: should correctly assign constructor parameters
- **AssessmentQuestion Unit Tests**: should return scoreValue of 3 for meetsTarget
- **AssessmentQuestion Unit Tests**: should return scoreValue of 2 for partiallyMeets
- **AssessmentQuestion Unit Tests**: should return scoreValue of 1 for doesNotMeet
- **AssessmentQuestion Unit Tests**: should return scoreValue of 0 for pending
- **AssessmentQuestion Unit Tests**: should return scoreValue of 0 for notApplicable
- **AssessmentQuestion Unit Tests**: should set isCriticalFailure to true only when selectedCompliance is doesNotMeet
- **AssessmentQuestion Unit Tests**: should allow mutating all fields dynamically
- **UserSession Tests**: should initialize UserSession with correct default values
- **UserSession Tests**: should allow setting and modifying all UserSession properties
- **LocalUserCredential Tests**: should initialize LocalUserCredential with correct default values
- **LocalUserCredential Tests**: should allow setting password sync flags and roles independently
- **SpatialZone Unit Tests**: should initialize with correct default values
- **readinessScore Calculations**: should return 0.0 when checklist is empty
- **readinessScore Calculations**: should return 0.0 when all questions are pending
- **readinessScore Calculations**: should calculate 100.0 score when all answered meet target
- **readinessScore Calculations**: should calculate correct average score with mixed compliance levels
- **completionPercentage Calculations**: should return 0.0 when checklist is empty
- **completionPercentage Calculations**: should return 100.0 when all questions are non-pending
- **completionPercentage Calculations**: should calculate correct ratio of non-pending questions
- **statusColor Mapping**: should return Colors.grey.shade400 when completionPercentage is 0%
- **statusColor Mapping**: should return Colors.red.shade600 when there is at least one critical failure
- **statusColor Mapping**: should return Colors.orange.shade500 when completion is partial (< 100%) and no critical failure
- **statusColor Mapping**: should return Colors.amber.shade500 when completed (100%) and contains partiallyMeets and no doesNotMeet
- **statusColor Mapping**: should return Colors.green.shade600 when completed (100%) and all meetsTarget or notApplicable

### mpox_data_test.dart
- MpoxCongregateSettingData gets layout

### report_export_service_test.dart

### services_test.dart
- **DatabaseService CRUD Tests**: saveAssessment should persist layout and auto-mark as dirty
- **DatabaseService CRUD Tests**: saveFromSync should persist layout WITHOUT marking as dirty
- **DatabaseService CRUD Tests**: getDirtyAssessments should return only modified local layouts
- **AuthService Tests**: register should create user in firebase and save session locally
- **AuthService Tests**: login offline should fallback to local credential if network fails
- **SyncService Tests**: pushPendingData sets error state on failure
- **SyncService Tests**: syncAll updates local db from remote json
- **Support Services (Geocoding & Export)**: Validazione Coordinate: Rifiuto Null Island
- **Support Services (Geocoding & Export)**: Export Word Resilience: non deve crashare senza dati

### sync_flow_test.dart
- **Sync Flow & Login/Logout Scenarios (MockRepo)**: forcePullAll pulls all data ignoring local lastSyncedAt state
- **Sync Flow & Login/Logout Scenarios (MockRepo)**: Complete End-to-End: Create, Push, Logout (Clear), Login (Pull)
- **Sync Flow & Login/Logout Scenarios (MockRepo)**: Push pending data does not pull and only pushes (Logout offline prep)
- **Stress Testing - Offline Flow & Resilience (FakeRepo)**: Offline-to-Online: Create offline, save and auto-sync on connectivity restore
- **Stress Testing - Offline Flow & Resilience (FakeRepo)**: Exponential Backoff & Retry Resilience: 3 consecutive attempts before failure
- **Stress Testing - Offline Flow & Resilience (FakeRepo)**: Last-Write-Wins (LWW) Conflict Resolution

### sync_repository_test.dart
- **SyncRepository Tests**: pushAssessment creates a document in Firestore
- **SyncRepository Tests**: pushAssessment returns null if firestore is not initialized
- **SyncRepository Tests**: pullAssessments retrieves assessments from Firestore with lastSync
- **SyncRepository Tests**: pullAssessments returns empty list if firestore is not initialized
- **SyncRepository Tests**: pushAssessment uploads local images and replaces with remote URLs
- **SyncRepository Tests**: pushAssessment creates a document with generalInfo
- **SyncRepository Tests**: pullAssessments parses dateCreated when available
- **SyncRepository Tests**: pullAssessments catches firestore errors
- **SyncRepository Tests**: pushAssessment handles missing local image file gracefully

### sync_service_test.dart
- **SyncNotifier Tests**: initial state is idle
- **SyncNotifier Tests**: pushPendingData sets success state and updates dirty assessments
- **SyncNotifier Tests**: pushPendingData sets error state on exception
- **SyncNotifier Tests**: syncAll performs push and pull

## 3. Widget Test
### assessments_list_screen_extended_test.dart
- **AssessmentsListScreen Extended Tests**: Offline Sync indicator shows correct state based on isDirty
- **AssessmentsListScreen Extended Tests**: Pull to refresh using fling
- **AssessmentsListScreen Extended Tests**: Swipe to delete confirmation dialog
- **AssessmentsListScreen Extended Tests**: No results found placeholder for empty search
- **AssessmentsListScreen Extended Tests**: Filter popup interactions and Geographical Overview

### assessment_widgets_test.dart
- **AssessmentScreen Tests**: renders questions and updates compliance
- **AssessmentScreen Tests**: renders tablet portrait layout
- **AssessmentScreen Tests**: renders mobile portrait layout
- **PreAssessmentScreen Tests**: renders all steps and completes pre-assessment form
- **PreAssessmentScreen Tests**: renders tablet portrait layout
- **PreAssessmentScreen Tests**: renders mobile portrait layout
- **Camera & Image Acquisition Tests**: Permessi Fotocamera Negati: Mostra il dialogo premium esplicativo in caso di eccezione permessi
- **Camera & Image Acquisition Tests**: Camera Image Acquisition: Memorizza il percorso e visualizza la miniatura in checklist

### core_widgets_test.dart
- **MainDashboardScreen Tests**: renders home content with outbreak cards
- **MainDashboardScreen Tests**: info dialog opens on info button tap
- **MainDashboardScreen Tests**: bottom navigation changes tabs
- **MainDashboardScreen Tests**: renders tablet portrait layout
- **MainDashboardScreen Tests**: renders mobile portrait layout
- **SettingsScreen Tests**: renders all sections and user profile info
- **SettingsScreen Tests**: logout prompts when there are dirty assessments
- **SettingsScreen Tests**: changes language when selected
- **SettingsScreen Tests**: opens user profile and saves changes
- **SettingsScreen Tests**: triggers offline sync when data exists
- **AssessmentsListScreen Tests**: should filter list dynamically when typing in search bar
- **AssessmentsListScreen Tests**: Sort dropdown changes list order
- **AssessmentsListScreen Tests**: Tapping an item attempts navigation
- **AssessmentsListScreen Tests**: renders tablet portrait layout
- **AssessmentsListScreen Tests**: renders mobile portrait layout
- **RegisterScreen Tests**: should render all input fields and branding elements
- **RegisterScreen Tests**: password requirements checkmark state updates dynamically
- **FacilitySelectionScreen Tests**: renders all facility types and handles navigation for mpox
- **FacilitySelectionScreen Tests**: renders mobile portrait layout with standard header
- **FacilitySelectionScreen Tests**: renders tablet landscape split layout
- **FacilitySelectionScreen Tests**: ebola emergency navigates to map instead of pre-assessment
- **FacilitySelectionScreen Tests**: renders tablet portrait layout
- **FacilitySelectionScreen Tests**: taps back button
- **FacilitySelectionScreen Tests**: toggles sidebar on tablet landscape
- **FacilitySelectionScreen Tests**: handles locked module tap
- **FacilitySelectionScreen Tests**: renders mobile landscape layout with list view
- **SettingsScreen Additional Tests**: renders mobile layout with SliverAppBar
- **SettingsScreen Additional Tests**: mobile language selector uses BottomSheet
- **SettingsScreen Additional Tests**: no data shows disabled sync tile
- **AssessmentsListScreen Additional Tests**: delete confirmation dialog appears on swipe/long-press
- **AssessmentsListScreen Additional Tests**: tablet landscape shows split detail view
- **AssessmentsListScreen Additional Tests**: score sort low to high works

### global_map_test.dart
- **GlobalMapScreen3D Tests**: renders loading state initially

### login_screen_test.dart
- **LoginScreen Tests**: renders all form elements
- **LoginScreen Tests**: WHO staff rejects non @who.int email
- **LoginScreen Tests**: external partner accepts generic email
- **LoginScreen Tests**: forgot password button opens modal
- **LoginScreen Tests**: empty fields show required error
- **LoginScreen Tests**: renders tablet portrait layout
- **LoginScreen Tests**: renders tablet landscape layout
- **LoginScreen Tests**: renders mobile landscape layout
- **LoginScreen Tests**: successful login navigates to dashboard
- **LoginScreen Tests**: failed login shows snackbar
- **LoginScreen Tests**: toggle password visibility
- **LoginScreen Tests**: switching to external partner clears email
- **LoginScreen Tests**: external partner rejects invalid email format
- **LoginScreen Tests**: register navigation link is present
- **LoginScreen Tests**: renders mobile portrait with header and form
- **LoginScreen Tests**: forgot password modal shows errors for empty fields
- **LoginScreen Tests**: forgot password handles missing email in local db
- **LoginScreen Tests**: forgot password handles incorrect date of birth
- **LoginScreen Tests**: forgot password completes reset flow successfully

### main_app_test.dart
- WHOAssessmentApp renders and configures router and theme

### map_and_analytics_widgets_test.dart
- **AnalyticsScreen Tests**: renders empty state when no assessments available
- **AnalyticsScreen Tests**: renders metrics when data is available
- **AnalyticsScreen Tests**: interacts with dropdowns and info modal
- **AdvancedAnalyticsScreen Tests**: renders empty state when no data provided
- **AdvancedAnalyticsScreen Tests**: renders charts when data is provided
- **AdvancedAnalyticsScreen Tests**: renders single assessment state
- **AdvancedAnalyticsScreen Tests**: renders tablet portrait layout
- **AdvancedAnalyticsScreen Tests**: renders mobile portrait layout
- **AdvancedAnalyticsScreen Tests**: renders mobile landscape layout
- **AdvancedAnalyticsScreen Tests**: renders empty state when not enough valid historical data
- **InteractiveMapScreen Tests**: renders map screen and pinch-to-explore text
- **InteractiveMapScreen Tests**: has general assessment and list buttons in appbar
- **InteractiveMapScreen Tests**: taps general assessment button
- **InteractiveMapScreen Tests**: taps a specific zone on the map
- **GlobalMapScreen3D Tests**: renders map screen when data is loaded
- **GlobalMapScreen3D Tests**: FAB toggles map style

### pre_assessment_screen_test.dart
- **PreAssessmentScreen Tests**: fills form steps and submits to map screen
- **PreAssessmentScreen Tests**: renders tablet landscape split layout
- **PreAssessmentScreen Tests**: renders mobile portrait layout
- **PreAssessmentScreen Tests**: renders mobile landscape layout
- **PreAssessmentScreen Tests**: Back button navigates to previous step
- **PreAssessmentScreen Tests**: inpatient Yes shows extra fields, No hides them

### register_screen_extended_test.dart
- **RegisterScreen Extended Tests**: Firebase email-already-in-use shows error snackbar
- **RegisterScreen Extended Tests**: Register navigation attempts to go back to login

### register_screen_test.dart
- **RegisterScreen Tests**: renders all input fields and branding elements
- **RegisterScreen Tests**: password requirements checkmark state updates dynamically
- **RegisterScreen Tests**: WHO staff rejects non @who.int email on submit
- **RegisterScreen Tests**: external partner mode accepts non-who email
- **RegisterScreen Tests**: renders tablet portrait layout
- **RegisterScreen Tests**: renders mobile portrait layout
- **RegisterScreen Tests**: renders mobile landscape layout

### settings_screen_test.dart
- **SettingsScreen Tests**: renders tablet layout and changes language
- **SettingsScreen Tests**: renders mobile layout and changes language
- **SettingsScreen Tests**: opens user profile modal
- **SettingsScreen Tests**: logout without dirty data proceeds directly
- **SettingsScreen Tests**: logout with dirty data shows warning dialog and cancels
- **SettingsScreen Tests**: logout with dirty data shows warning dialog and confirms
- **SettingsScreen Tests**: sync string displays correctly when syncing
- **SettingsScreen Tests**: sync string displays correctly when error

## 4. Integration Test (UI E2E on Simulator)
### analytics_e2e_test.dart
- **Analytics & Outbreak Reporting E2E**: Analytics global dashboard loads
- **Analytics & Outbreak Reporting E2E**: Global Map 3D interaction

### assessment_e2e_test.dart
- **Assessment Operations E2E**: Assessment add item (Start Pre-Assessment)
- **Assessment Operations E2E**: Assessment compliance change

### auth_e2e_test.dart
- **Authentication E2E**: Login fails with wrong credentials
- **Authentication E2E**: Login succeeds with correct credentials
- **Authentication E2E**: Toggle password visibility
- **Authentication E2E**: Logs out after successful Login

### navigation_e2e_test.dart
- **Navigation E2E**: Bottom navigation bar switches tabs
- **Navigation E2E**: Navigate to Outbreak module and back

### settings_e2e_test.dart
- **Profile & Settings E2E**: Profile changes persist and restore
- **Profile & Settings E2E**: Language changes successfully

