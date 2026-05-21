// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Health Facilities Assessment Tool';

  @override
  String get authorizedPersonnelOnly => 'AUTHORIZED PERSONNEL ONLY';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue =>
      'Sign in to continue your assessment activities.';

  @override
  String get whoStaff => 'WHO Staff';

  @override
  String get externalPartner => 'External Partner';

  @override
  String get whoIdEmail => 'WHO ID / Email';

  @override
  String get partnerEmail => 'Partner Email';

  @override
  String get wimsPassword => 'WIMS Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get authenticate => 'Authenticate';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get registerHere => 'Register Here';

  @override
  String get settings => 'Settings';

  @override
  String get accountAndSync => 'ACCOUNT & SYNC';

  @override
  String get userProfile => 'User Profile';

  @override
  String get offlineSync => 'Offline Sync';

  @override
  String get preferences => 'PREFERENCES';

  @override
  String get language => 'Language';

  @override
  String get about => 'ABOUT';

  @override
  String get whoGuidelines => 'WHO Guidelines';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get appVersion => 'App Version';

  @override
  String get logOut => 'Log Out';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get appTitleLine1 => 'Health Facilities';

  @override
  String get appTitleLine2 => 'Assessment Tool';

  @override
  String get appTitleMultiline => 'Health Facilities\nAssessment Tool';

  @override
  String get requiredField => 'Required field';

  @override
  String get whoStaffEmailError => 'WHO Staff must use a @who.int email';

  @override
  String get invalidEmailError => 'Please enter a valid email address';

  @override
  String get loginFailed => 'Login failed: ';

  @override
  String get home => 'Home';

  @override
  String get assessments => 'Assessments';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get infoDialogTitle => 'WHO Assessment Tool';

  @override
  String get infoDialogBody =>
      'This application provides structural rapid assessment tools for health facilities during infectious disease outbreaks, based on official WHO guidelines.';

  @override
  String get close => 'Close';

  @override
  String get statusActive => 'Active';

  @override
  String get statusSoon => 'Soon';

  @override
  String get moduleLocked => 'Module currently locked.';

  @override
  String get selectFacilityType => 'Select Facility Type';

  @override
  String facilitiesLabel(String emergencyName) {
    return '$emergencyName Facilities';
  }

  @override
  String facilitySelectionDescription(String emergencyName) {
    return 'Choose the specific health facility configuration to proceed with the $emergencyName assessment module.';
  }

  @override
  String get moduleLockedDevelopment => 'Module locked or in development.';

  @override
  String get collapseMenu => 'Collapse Menu';

  @override
  String get expandMenu => 'Expand Menu';

  @override
  String get back => 'Back';

  @override
  String get step1Title => 'Assessment Information';

  @override
  String get step1Desc =>
      'Please enter a title to easily identify this assessment later, along with the assessor details.';

  @override
  String get assessmentTitleLabel =>
      'Assessment Title (e.g. Hospital North - Baseline)';

  @override
  String get assessmentDateLabel => 'Date of assessment';

  @override
  String get selectDate => 'Select Date';

  @override
  String get assessorNameLabel =>
      'Name of the person conducting the assessment';

  @override
  String get assessorEmailLabel =>
      'Email of the person conducting the assessment';

  @override
  String get assessorPhoneLabel =>
      'Phone of the person conducting the assessment';

  @override
  String get step2Title => 'Geographical Location';

  @override
  String get countryLabel => 'Country';

  @override
  String get regionLabel => 'Region/province name';

  @override
  String get districtLabel => 'District name';

  @override
  String get cityLabel => 'City/Village/clan/locality name';

  @override
  String get addressLabel => 'Address of facility / GPS coordinates';

  @override
  String get locationRecordLabel => 'Record of facility location';

  @override
  String get step3Title => 'Facility Identification';

  @override
  String metadataAutofill(String emergencyType, String facilityType) {
    return 'Metadata Auto-fill: The assessment is set for $emergencyType in a facility type: \'$facilityType\'.';
  }

  @override
  String get facilityCodeLabel => 'Facility code';

  @override
  String get facilityNameLabel => 'Facility name';

  @override
  String get managingAuthorityLabel => 'Managing authority';

  @override
  String get directorNameLabel => 'Facility director/manager’s name';

  @override
  String get directorPhoneLabel =>
      'Facility director/manager’s telephone number';

  @override
  String get directorEmailLabel => 'Facility director/manager’s email address';

  @override
  String get respondentNameLabel => 'Respondent or key informant’s name';

  @override
  String get respondentPositionLabel =>
      'Respondent or key informant’s position';

  @override
  String get structureTypeLabel => 'Type of structure';

  @override
  String get existingFacilityTypeLabel =>
      'Type of existing healthcare facility';

  @override
  String get step4Title => 'Existing Healthcare Services';

  @override
  String get offersOutpatientLabel => 'The facility offers outpatient services';

  @override
  String get offersInpatientLabel => 'The facility offers inpatient services';

  @override
  String get inpatientCapacityDesc =>
      'Please provide inpatient capacity details.';

  @override
  String get totalBedsLabel => 'Total number of overnight/ inpatient beds';

  @override
  String get icuBedsLabel =>
      'Of the total number of inpatient beds, how many are intensive care unit (ICU) beds?';

  @override
  String get has24hEmergencyLabel =>
      'The facility has dedicated 24-hour staffed emergency unit';

  @override
  String get hasIcuOrHduLabel =>
      'The facility has intensive care or high-dependency unit';

  @override
  String get facilityConfigurationTitle => 'Facility Configuration';

  @override
  String facilityConfigurationDesc(String emergencyType) {
    return 'Complete the pre-assessment steps to set up the environment for $emergencyType.';
  }

  @override
  String stepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get backButton => 'Back';

  @override
  String get nextButton => 'Next';

  @override
  String get submitButton => 'Submit';

  @override
  String get unnamedAssessment => 'Unnamed Assessment';

  @override
  String get dateOfBirthError => 'Please select your Date of Birth';

  @override
  String get passwordReqError => 'Please meet all password requirements';

  @override
  String get registrationSuccess => 'Registration Successful! Welcome.';

  @override
  String get registrationFailed => 'Registration failed: ';

  @override
  String get joinPlatform => 'Join the Platform';

  @override
  String get createAccountDescGlobal =>
      'Create your account to start managing health facility assessments globally.';

  @override
  String get authorizedPersonnel => 'AUTHORIZED PERSONNEL ONLY';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get createAccountDescAuth =>
      'Enter your details to register as an authorized user.';

  @override
  String get createAccountDescStart => 'Create your account to get started.';

  @override
  String get whoStaffRole => 'WHO Staff';

  @override
  String get externalPartnerRole => 'External Partner';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get dobLabel => 'Date of Birth';

  @override
  String get whoEmailLabel => 'WHO Email Address';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get requiredValidation => 'Required';

  @override
  String get createPasswordLabel => 'Create Password';

  @override
  String get passwordMustContain => 'Password must contain:';

  @override
  String get chars8Plus => '8+ Chars';

  @override
  String get uppercase => 'Uppercase';

  @override
  String get number => 'Number';

  @override
  String get special => 'Special';

  @override
  String get registerAccountBtn => 'Register Account';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get addNote => 'Add Note';

  @override
  String get editNote => 'Edit Note';

  @override
  String get enterObservations => 'Enter your observations here...';

  @override
  String get cancel => 'Cancel';

  @override
  String get saveNote => 'Save Note';

  @override
  String get takePhoto => 'Take a Photo';

  @override
  String get chooseGallery => 'Choose from Gallery';

  @override
  String get errorPickingImage => 'Error picking image: ';

  @override
  String get cameraAccessRequired => 'Camera Access Required';

  @override
  String get cameraAccessMsg =>
      'To capture facility evidence, this app requires camera permissions. Please enable camera access in your device\'s System Settings.';

  @override
  String get understood => 'Understood';

  @override
  String get overallCompletion => 'Overall Completion';

  @override
  String completedPct(String pct) {
    return '$pct% Completed';
  }

  @override
  String get areaChecklist => 'Area Checklist';

  @override
  String get areaAssessmentChecklist => 'Area Assessment Checklist';

  @override
  String get meetsTarget => 'Meets\n(3 pts)';

  @override
  String get partiallyMeets => 'Partially Meets\n(2 pts)';

  @override
  String get doesNotMeet => 'Does Not Meet\n(1 pt)';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get evaluationCriteria => 'Evaluation Criteria';

  @override
  String get gotIt => 'Got it';

  @override
  String get howToImprove => 'HOW TO IMPROVE YOUR DESIGN';

  @override
  String get savedAssessments => 'Saved Assessments';

  @override
  String get analytics => 'Analytics';

  @override
  String get searchAssessment => 'Search assessment by name...';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get sortBy => 'SORT BY';

  @override
  String get newestFirst => 'Newest First';

  @override
  String get highestScore => 'Highest Score';

  @override
  String get lowestScore => 'Lowest Score';

  @override
  String get dateFilter => 'DATE FILTER';

  @override
  String get clearDateFilter => 'Clear Date Filter';

  @override
  String get noAssessmentsMatch => 'No assessments match your filters.';

  @override
  String get selectAssessmentToView => 'Select an assessment to view details';

  @override
  String get openInteractiveMap => 'Open Interactive Map';

  @override
  String get criticalFails => 'Critical Fails';

  @override
  String get zonesEvaluated => 'Zones Evaluated';

  @override
  String get zoneBreakdown => 'Zone Breakdown';

  @override
  String get deleteAssessment => 'Delete Assessment';

  @override
  String get deleteAssessmentConfirm =>
      'Are you sure you want to permanently delete this assessment? This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get assessmentDeleted => 'Assessment deleted successfully.';

  @override
  String get inProgress => 'In Progress';

  @override
  String get completed => 'Completed';

  @override
  String get allCountries => 'All Countries';

  @override
  String get allYears => 'All Years';

  @override
  String get dataAnalytics => 'Data Analytics';

  @override
  String get advancedCharts => 'Advanced Charts';

  @override
  String get noReportsAvailable => 'No reports available for this selection.';

  @override
  String get assessmentsCount => 'Assessments';

  @override
  String get assessmentsCountInfo =>
      'Total number of completed facility assessments.';

  @override
  String get avgReadiness => 'Avg Readiness';

  @override
  String get avgReadinessInfo =>
      'The average percentage score indicating how well the assessed facilities meet the required standards.';

  @override
  String get criticalFailsInfo =>
      'Number of high-priority criteria that did not meet the minimum requirements.';

  @override
  String get complianceBreakdown => 'Compliance Breakdown';

  @override
  String distributionCriteria(int total) {
    return 'Distribution of $total evaluated criteria';
  }

  @override
  String get complianceBreakdownInfo =>
      'Visualizes the percentage of criteria that fully meet (Meets), partially meet (Partial), or fail (Fails) the standards.';

  @override
  String get meets => 'Meets';

  @override
  String get partial => 'Partial';

  @override
  String get fails => 'Fails';

  @override
  String get categoryPerformance => 'Category Performance';

  @override
  String get readinessScoreTech => 'Readiness score across technical areas';

  @override
  String get categoryPerformanceInfo =>
      'Average compliance scores grouped by technical categories like IPC, WASH, and Logistics.';

  @override
  String get geographicalRanking => 'Geographical Ranking';

  @override
  String get avgReadinessCountry => 'Average readiness score by country';

  @override
  String get geographicalRankingInfo =>
      'Compares the readiness performance between different countries or regions.';

  @override
  String get countryRegion => 'Country / Region';

  @override
  String get reportingYear => 'Reporting Year';

  @override
  String get advancedAnalytics => 'Advanced Analytics';

  @override
  String get noDataToDisplay => 'No data to display.';

  @override
  String get readinessTrend => 'Readiness Trend';

  @override
  String get evolutionOfGlobalScore => 'Evolution of global score';

  @override
  String get performanceRadar => 'Performance Radar';

  @override
  String get pillarsBalance => 'Pillars balance';

  @override
  String get evolutionGlobalScoreTime =>
      'Evolution of the global score over time';

  @override
  String get multidimensionalPerformance => 'Multidimensional Performance';

  @override
  String get balanceAcrossPillars => 'Balance across technical pillars';

  @override
  String get thisAssessment => 'this assessment';

  @override
  String readinessScoreFor(String name) {
    return 'Readiness score for $name';
  }

  @override
  String get addMoreAssessmentsUnlock =>
      'Add more assessments to unlock trend analysis.';

  @override
  String get notEnoughHistoricalData =>
      'Not enough historical data for trend analysis. At least 2 assessments needed.';

  @override
  String assessmentIndex(int index) {
    return 'Assessment $index';
  }

  @override
  String get spatialAssessment => 'Spatial Assessment';

  @override
  String get viewSavedAssessments => 'View Saved Assessments';

  @override
  String get generalAssessment => 'General Assessment';

  @override
  String get pinchToExplore =>
      'Pinch to explore. Tap highlighted pins to evaluate.';

  @override
  String get unnamedFacility => 'Unnamed Facility';

  @override
  String get unknownCity => 'Unknown City';

  @override
  String get unknown => 'Unknown';

  @override
  String get globalReadiness => 'GLOBAL READINESS';

  @override
  String get viewDetails => 'View Details';

  @override
  String get globalAssessmentMap => 'Global Assessment Map';

  @override
  String get calibratingSatelliteImagery => 'Calibrating Satellite Imagery...';

  @override
  String get syncingAssessmentCoordinates => 'Syncing assessment coordinates';

  @override
  String get fitToExtent => 'Fit to Extent';

  @override
  String assessedOn(String date) {
    return 'Assessed on $date';
  }

  @override
  String get readinessScoreUppercase => 'READINESS SCORE';

  @override
  String get initializing3dEngine => 'Initializing 3D Engine...';

  @override
  String get filterAll => 'All';

  @override
  String get signInLink => 'Sign In';
}
