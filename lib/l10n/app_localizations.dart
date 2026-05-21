import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Facilities Assessment Tool'**
  String get appTitle;

  /// No description provided for @authorizedPersonnelOnly.
  ///
  /// In en, this message translates to:
  /// **'AUTHORIZED PERSONNEL ONLY'**
  String get authorizedPersonnelOnly;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your assessment activities.'**
  String get signInToContinue;

  /// No description provided for @whoStaff.
  ///
  /// In en, this message translates to:
  /// **'WHO Staff'**
  String get whoStaff;

  /// No description provided for @externalPartner.
  ///
  /// In en, this message translates to:
  /// **'External Partner'**
  String get externalPartner;

  /// No description provided for @whoIdEmail.
  ///
  /// In en, this message translates to:
  /// **'WHO ID / Email'**
  String get whoIdEmail;

  /// No description provided for @partnerEmail.
  ///
  /// In en, this message translates to:
  /// **'Partner Email'**
  String get partnerEmail;

  /// No description provided for @wimsPassword.
  ///
  /// In en, this message translates to:
  /// **'WIMS Password'**
  String get wimsPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @authenticate.
  ///
  /// In en, this message translates to:
  /// **'Authenticate'**
  String get authenticate;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @registerHere.
  ///
  /// In en, this message translates to:
  /// **'Register Here'**
  String get registerHere;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accountAndSync.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT & SYNC'**
  String get accountAndSync;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @offlineSync.
  ///
  /// In en, this message translates to:
  /// **'Offline Sync'**
  String get offlineSync;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get about;

  /// No description provided for @whoGuidelines.
  ///
  /// In en, this message translates to:
  /// **'WHO Guidelines'**
  String get whoGuidelines;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @appTitleLine1.
  ///
  /// In en, this message translates to:
  /// **'Health Facilities'**
  String get appTitleLine1;

  /// No description provided for @appTitleLine2.
  ///
  /// In en, this message translates to:
  /// **'Assessment Tool'**
  String get appTitleLine2;

  /// No description provided for @appTitleMultiline.
  ///
  /// In en, this message translates to:
  /// **'Health Facilities\nAssessment Tool'**
  String get appTitleMultiline;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @whoStaffEmailError.
  ///
  /// In en, this message translates to:
  /// **'WHO Staff must use a @who.int email'**
  String get whoStaffEmailError;

  /// No description provided for @invalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmailError;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed: '**
  String get loginFailed;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @assessments.
  ///
  /// In en, this message translates to:
  /// **'Assessments'**
  String get assessments;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @infoDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'WHO Assessment Tool'**
  String get infoDialogTitle;

  /// No description provided for @infoDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This application provides structural rapid assessment tools for health facilities during infectious disease outbreaks, based on official WHO guidelines.'**
  String get infoDialogBody;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get statusSoon;

  /// No description provided for @moduleLocked.
  ///
  /// In en, this message translates to:
  /// **'Module currently locked.'**
  String get moduleLocked;

  /// No description provided for @selectFacilityType.
  ///
  /// In en, this message translates to:
  /// **'Select Facility Type'**
  String get selectFacilityType;

  /// No description provided for @facilitiesLabel.
  ///
  /// In en, this message translates to:
  /// **'{emergencyName} Facilities'**
  String facilitiesLabel(String emergencyName);

  /// No description provided for @facilitySelectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the specific health facility configuration to proceed with the {emergencyName} assessment module.'**
  String facilitySelectionDescription(String emergencyName);

  /// No description provided for @moduleLockedDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Module locked or in development.'**
  String get moduleLockedDevelopment;

  /// No description provided for @collapseMenu.
  ///
  /// In en, this message translates to:
  /// **'Collapse Menu'**
  String get collapseMenu;

  /// No description provided for @expandMenu.
  ///
  /// In en, this message translates to:
  /// **'Expand Menu'**
  String get expandMenu;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Assessment Information'**
  String get step1Title;

  /// No description provided for @step1Desc.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title to easily identify this assessment later, along with the assessor details.'**
  String get step1Desc;

  /// No description provided for @assessmentTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Assessment Title (e.g. Hospital North - Baseline)'**
  String get assessmentTitleLabel;

  /// No description provided for @assessmentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of assessment'**
  String get assessmentDateLabel;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @assessorNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name of the person conducting the assessment'**
  String get assessorNameLabel;

  /// No description provided for @assessorEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email of the person conducting the assessment'**
  String get assessorEmailLabel;

  /// No description provided for @assessorPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone of the person conducting the assessment'**
  String get assessorPhoneLabel;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Geographical Location'**
  String get step2Title;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @regionLabel.
  ///
  /// In en, this message translates to:
  /// **'Region/province name'**
  String get regionLabel;

  /// No description provided for @districtLabel.
  ///
  /// In en, this message translates to:
  /// **'District name'**
  String get districtLabel;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City/Village/clan/locality name'**
  String get cityLabel;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address of facility / GPS coordinates'**
  String get addressLabel;

  /// No description provided for @locationRecordLabel.
  ///
  /// In en, this message translates to:
  /// **'Record of facility location'**
  String get locationRecordLabel;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Facility Identification'**
  String get step3Title;

  /// No description provided for @metadataAutofill.
  ///
  /// In en, this message translates to:
  /// **'Metadata Auto-fill: The assessment is set for {emergencyType} in a facility type: \'{facilityType}\'.'**
  String metadataAutofill(String emergencyType, String facilityType);

  /// No description provided for @facilityCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Facility code'**
  String get facilityCodeLabel;

  /// No description provided for @facilityNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Facility name'**
  String get facilityNameLabel;

  /// No description provided for @managingAuthorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Managing authority'**
  String get managingAuthorityLabel;

  /// No description provided for @directorNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Facility director/manager’s name'**
  String get directorNameLabel;

  /// No description provided for @directorPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Facility director/manager’s telephone number'**
  String get directorPhoneLabel;

  /// No description provided for @directorEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Facility director/manager’s email address'**
  String get directorEmailLabel;

  /// No description provided for @respondentNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Respondent or key informant’s name'**
  String get respondentNameLabel;

  /// No description provided for @respondentPositionLabel.
  ///
  /// In en, this message translates to:
  /// **'Respondent or key informant’s position'**
  String get respondentPositionLabel;

  /// No description provided for @structureTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type of structure'**
  String get structureTypeLabel;

  /// No description provided for @existingFacilityTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type of existing healthcare facility'**
  String get existingFacilityTypeLabel;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Existing Healthcare Services'**
  String get step4Title;

  /// No description provided for @offersOutpatientLabel.
  ///
  /// In en, this message translates to:
  /// **'The facility offers outpatient services'**
  String get offersOutpatientLabel;

  /// No description provided for @offersInpatientLabel.
  ///
  /// In en, this message translates to:
  /// **'The facility offers inpatient services'**
  String get offersInpatientLabel;

  /// No description provided for @inpatientCapacityDesc.
  ///
  /// In en, this message translates to:
  /// **'Please provide inpatient capacity details.'**
  String get inpatientCapacityDesc;

  /// No description provided for @totalBedsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total number of overnight/ inpatient beds'**
  String get totalBedsLabel;

  /// No description provided for @icuBedsLabel.
  ///
  /// In en, this message translates to:
  /// **'Of the total number of inpatient beds, how many are intensive care unit (ICU) beds?'**
  String get icuBedsLabel;

  /// No description provided for @has24hEmergencyLabel.
  ///
  /// In en, this message translates to:
  /// **'The facility has dedicated 24-hour staffed emergency unit'**
  String get has24hEmergencyLabel;

  /// No description provided for @hasIcuOrHduLabel.
  ///
  /// In en, this message translates to:
  /// **'The facility has intensive care or high-dependency unit'**
  String get hasIcuOrHduLabel;

  /// No description provided for @facilityConfigurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Facility Configuration'**
  String get facilityConfigurationTitle;

  /// No description provided for @facilityConfigurationDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete the pre-assessment steps to set up the environment for {emergencyType}.'**
  String facilityConfigurationDesc(String emergencyType);

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepProgress(int current, int total);

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @submitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitButton;

  /// No description provided for @unnamedAssessment.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Assessment'**
  String get unnamedAssessment;

  /// No description provided for @dateOfBirthError.
  ///
  /// In en, this message translates to:
  /// **'Please select your Date of Birth'**
  String get dateOfBirthError;

  /// No description provided for @passwordReqError.
  ///
  /// In en, this message translates to:
  /// **'Please meet all password requirements'**
  String get passwordReqError;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful! Welcome.'**
  String get registrationSuccess;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed: '**
  String get registrationFailed;

  /// No description provided for @joinPlatform.
  ///
  /// In en, this message translates to:
  /// **'Join the Platform'**
  String get joinPlatform;

  /// No description provided for @createAccountDescGlobal.
  ///
  /// In en, this message translates to:
  /// **'Create your account to start managing health facility assessments globally.'**
  String get createAccountDescGlobal;

  /// No description provided for @authorizedPersonnel.
  ///
  /// In en, this message translates to:
  /// **'AUTHORIZED PERSONNEL ONLY'**
  String get authorizedPersonnel;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @createAccountDescAuth.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to register as an authorized user.'**
  String get createAccountDescAuth;

  /// No description provided for @createAccountDescStart.
  ///
  /// In en, this message translates to:
  /// **'Create your account to get started.'**
  String get createAccountDescStart;

  /// No description provided for @whoStaffRole.
  ///
  /// In en, this message translates to:
  /// **'WHO Staff'**
  String get whoStaffRole;

  /// No description provided for @externalPartnerRole.
  ///
  /// In en, this message translates to:
  /// **'External Partner'**
  String get externalPartnerRole;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @dobLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dobLabel;

  /// No description provided for @whoEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'WHO Email Address'**
  String get whoEmailLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @requiredValidation.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredValidation;

  /// No description provided for @createPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get createPasswordLabel;

  /// No description provided for @passwordMustContain.
  ///
  /// In en, this message translates to:
  /// **'Password must contain:'**
  String get passwordMustContain;

  /// No description provided for @chars8Plus.
  ///
  /// In en, this message translates to:
  /// **'8+ Chars'**
  String get chars8Plus;

  /// No description provided for @uppercase.
  ///
  /// In en, this message translates to:
  /// **'Uppercase'**
  String get uppercase;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @special.
  ///
  /// In en, this message translates to:
  /// **'Special'**
  String get special;

  /// No description provided for @registerAccountBtn.
  ///
  /// In en, this message translates to:
  /// **'Register Account'**
  String get registerAccountBtn;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// No description provided for @enterObservations.
  ///
  /// In en, this message translates to:
  /// **'Enter your observations here...'**
  String get enterObservations;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @saveNote.
  ///
  /// In en, this message translates to:
  /// **'Save Note'**
  String get saveNote;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takePhoto;

  /// No description provided for @chooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseGallery;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image: '**
  String get errorPickingImage;

  /// No description provided for @cameraAccessRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera Access Required'**
  String get cameraAccessRequired;

  /// No description provided for @cameraAccessMsg.
  ///
  /// In en, this message translates to:
  /// **'To capture facility evidence, this app requires camera permissions. Please enable camera access in your device\'s System Settings.'**
  String get cameraAccessMsg;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get understood;

  /// No description provided for @overallCompletion.
  ///
  /// In en, this message translates to:
  /// **'Overall Completion'**
  String get overallCompletion;

  /// No description provided for @completedPct.
  ///
  /// In en, this message translates to:
  /// **'{pct}% Completed'**
  String completedPct(String pct);

  /// No description provided for @areaChecklist.
  ///
  /// In en, this message translates to:
  /// **'Area Checklist'**
  String get areaChecklist;

  /// No description provided for @areaAssessmentChecklist.
  ///
  /// In en, this message translates to:
  /// **'Area Assessment Checklist'**
  String get areaAssessmentChecklist;

  /// No description provided for @meetsTarget.
  ///
  /// In en, this message translates to:
  /// **'Meets\n(3 pts)'**
  String get meetsTarget;

  /// No description provided for @partiallyMeets.
  ///
  /// In en, this message translates to:
  /// **'Partially Meets\n(2 pts)'**
  String get partiallyMeets;

  /// No description provided for @doesNotMeet.
  ///
  /// In en, this message translates to:
  /// **'Does Not Meet\n(1 pt)'**
  String get doesNotMeet;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @evaluationCriteria.
  ///
  /// In en, this message translates to:
  /// **'Evaluation Criteria'**
  String get evaluationCriteria;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @howToImprove.
  ///
  /// In en, this message translates to:
  /// **'HOW TO IMPROVE YOUR DESIGN'**
  String get howToImprove;

  /// No description provided for @savedAssessments.
  ///
  /// In en, this message translates to:
  /// **'Saved Assessments'**
  String get savedAssessments;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @searchAssessment.
  ///
  /// In en, this message translates to:
  /// **'Search assessment by name...'**
  String get searchAssessment;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'SORT BY'**
  String get sortBy;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get newestFirst;

  /// No description provided for @highestScore.
  ///
  /// In en, this message translates to:
  /// **'Highest Score'**
  String get highestScore;

  /// No description provided for @lowestScore.
  ///
  /// In en, this message translates to:
  /// **'Lowest Score'**
  String get lowestScore;

  /// No description provided for @dateFilter.
  ///
  /// In en, this message translates to:
  /// **'DATE FILTER'**
  String get dateFilter;

  /// No description provided for @clearDateFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Date Filter'**
  String get clearDateFilter;

  /// No description provided for @noAssessmentsMatch.
  ///
  /// In en, this message translates to:
  /// **'No assessments match your filters.'**
  String get noAssessmentsMatch;

  /// No description provided for @selectAssessmentToView.
  ///
  /// In en, this message translates to:
  /// **'Select an assessment to view details'**
  String get selectAssessmentToView;

  /// No description provided for @openInteractiveMap.
  ///
  /// In en, this message translates to:
  /// **'Open Interactive Map'**
  String get openInteractiveMap;

  /// No description provided for @criticalFails.
  ///
  /// In en, this message translates to:
  /// **'Critical Fails'**
  String get criticalFails;

  /// No description provided for @zonesEvaluated.
  ///
  /// In en, this message translates to:
  /// **'Zones Evaluated'**
  String get zonesEvaluated;

  /// No description provided for @zoneBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Zone Breakdown'**
  String get zoneBreakdown;

  /// No description provided for @deleteAssessment.
  ///
  /// In en, this message translates to:
  /// **'Delete Assessment'**
  String get deleteAssessment;

  /// No description provided for @deleteAssessmentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this assessment? This action cannot be undone.'**
  String get deleteAssessmentConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @assessmentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Assessment deleted successfully.'**
  String get assessmentDeleted;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @allCountries.
  ///
  /// In en, this message translates to:
  /// **'All Countries'**
  String get allCountries;

  /// No description provided for @allYears.
  ///
  /// In en, this message translates to:
  /// **'All Years'**
  String get allYears;

  /// No description provided for @dataAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Data Analytics'**
  String get dataAnalytics;

  /// No description provided for @advancedCharts.
  ///
  /// In en, this message translates to:
  /// **'Advanced Charts'**
  String get advancedCharts;

  /// No description provided for @noReportsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No reports available for this selection.'**
  String get noReportsAvailable;

  /// No description provided for @assessmentsCount.
  ///
  /// In en, this message translates to:
  /// **'Assessments'**
  String get assessmentsCount;

  /// No description provided for @assessmentsCountInfo.
  ///
  /// In en, this message translates to:
  /// **'Total number of completed facility assessments.'**
  String get assessmentsCountInfo;

  /// No description provided for @avgReadiness.
  ///
  /// In en, this message translates to:
  /// **'Avg Readiness'**
  String get avgReadiness;

  /// No description provided for @avgReadinessInfo.
  ///
  /// In en, this message translates to:
  /// **'The average percentage score indicating how well the assessed facilities meet the required standards.'**
  String get avgReadinessInfo;

  /// No description provided for @criticalFailsInfo.
  ///
  /// In en, this message translates to:
  /// **'Number of high-priority criteria that did not meet the minimum requirements.'**
  String get criticalFailsInfo;

  /// No description provided for @complianceBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Compliance Breakdown'**
  String get complianceBreakdown;

  /// No description provided for @distributionCriteria.
  ///
  /// In en, this message translates to:
  /// **'Distribution of {total} evaluated criteria'**
  String distributionCriteria(int total);

  /// No description provided for @complianceBreakdownInfo.
  ///
  /// In en, this message translates to:
  /// **'Visualizes the percentage of criteria that fully meet (Meets), partially meet (Partial), or fail (Fails) the standards.'**
  String get complianceBreakdownInfo;

  /// No description provided for @meets.
  ///
  /// In en, this message translates to:
  /// **'Meets'**
  String get meets;

  /// No description provided for @partial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get partial;

  /// No description provided for @fails.
  ///
  /// In en, this message translates to:
  /// **'Fails'**
  String get fails;

  /// No description provided for @categoryPerformance.
  ///
  /// In en, this message translates to:
  /// **'Category Performance'**
  String get categoryPerformance;

  /// No description provided for @readinessScoreTech.
  ///
  /// In en, this message translates to:
  /// **'Readiness score across technical areas'**
  String get readinessScoreTech;

  /// No description provided for @categoryPerformanceInfo.
  ///
  /// In en, this message translates to:
  /// **'Average compliance scores grouped by technical categories like IPC, WASH, and Logistics.'**
  String get categoryPerformanceInfo;

  /// No description provided for @geographicalRanking.
  ///
  /// In en, this message translates to:
  /// **'Geographical Ranking'**
  String get geographicalRanking;

  /// No description provided for @avgReadinessCountry.
  ///
  /// In en, this message translates to:
  /// **'Average readiness score by country'**
  String get avgReadinessCountry;

  /// No description provided for @geographicalRankingInfo.
  ///
  /// In en, this message translates to:
  /// **'Compares the readiness performance between different countries or regions.'**
  String get geographicalRankingInfo;

  /// No description provided for @countryRegion.
  ///
  /// In en, this message translates to:
  /// **'Country / Region'**
  String get countryRegion;

  /// No description provided for @reportingYear.
  ///
  /// In en, this message translates to:
  /// **'Reporting Year'**
  String get reportingYear;

  /// No description provided for @advancedAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Advanced Analytics'**
  String get advancedAnalytics;

  /// No description provided for @noDataToDisplay.
  ///
  /// In en, this message translates to:
  /// **'No data to display.'**
  String get noDataToDisplay;

  /// No description provided for @readinessTrend.
  ///
  /// In en, this message translates to:
  /// **'Readiness Trend'**
  String get readinessTrend;

  /// No description provided for @evolutionOfGlobalScore.
  ///
  /// In en, this message translates to:
  /// **'Evolution of global score'**
  String get evolutionOfGlobalScore;

  /// No description provided for @performanceRadar.
  ///
  /// In en, this message translates to:
  /// **'Performance Radar'**
  String get performanceRadar;

  /// No description provided for @pillarsBalance.
  ///
  /// In en, this message translates to:
  /// **'Pillars balance'**
  String get pillarsBalance;

  /// No description provided for @evolutionGlobalScoreTime.
  ///
  /// In en, this message translates to:
  /// **'Evolution of the global score over time'**
  String get evolutionGlobalScoreTime;

  /// No description provided for @multidimensionalPerformance.
  ///
  /// In en, this message translates to:
  /// **'Multidimensional Performance'**
  String get multidimensionalPerformance;

  /// No description provided for @balanceAcrossPillars.
  ///
  /// In en, this message translates to:
  /// **'Balance across technical pillars'**
  String get balanceAcrossPillars;

  /// No description provided for @thisAssessment.
  ///
  /// In en, this message translates to:
  /// **'this assessment'**
  String get thisAssessment;

  /// No description provided for @readinessScoreFor.
  ///
  /// In en, this message translates to:
  /// **'Readiness score for {name}'**
  String readinessScoreFor(String name);

  /// No description provided for @addMoreAssessmentsUnlock.
  ///
  /// In en, this message translates to:
  /// **'Add more assessments to unlock trend analysis.'**
  String get addMoreAssessmentsUnlock;

  /// No description provided for @notEnoughHistoricalData.
  ///
  /// In en, this message translates to:
  /// **'Not enough historical data for trend analysis. At least 2 assessments needed.'**
  String get notEnoughHistoricalData;

  /// No description provided for @assessmentIndex.
  ///
  /// In en, this message translates to:
  /// **'Assessment {index}'**
  String assessmentIndex(int index);

  /// No description provided for @spatialAssessment.
  ///
  /// In en, this message translates to:
  /// **'Spatial Assessment'**
  String get spatialAssessment;

  /// No description provided for @viewSavedAssessments.
  ///
  /// In en, this message translates to:
  /// **'View Saved Assessments'**
  String get viewSavedAssessments;

  /// No description provided for @generalAssessment.
  ///
  /// In en, this message translates to:
  /// **'General Assessment'**
  String get generalAssessment;

  /// No description provided for @pinchToExplore.
  ///
  /// In en, this message translates to:
  /// **'Pinch to explore. Tap highlighted pins to evaluate.'**
  String get pinchToExplore;

  /// No description provided for @unnamedFacility.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Facility'**
  String get unnamedFacility;

  /// No description provided for @unknownCity.
  ///
  /// In en, this message translates to:
  /// **'Unknown City'**
  String get unknownCity;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @globalReadiness.
  ///
  /// In en, this message translates to:
  /// **'GLOBAL READINESS'**
  String get globalReadiness;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @globalAssessmentMap.
  ///
  /// In en, this message translates to:
  /// **'Global Assessment Map'**
  String get globalAssessmentMap;

  /// No description provided for @calibratingSatelliteImagery.
  ///
  /// In en, this message translates to:
  /// **'Calibrating Satellite Imagery...'**
  String get calibratingSatelliteImagery;

  /// No description provided for @syncingAssessmentCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Syncing assessment coordinates'**
  String get syncingAssessmentCoordinates;

  /// No description provided for @fitToExtent.
  ///
  /// In en, this message translates to:
  /// **'Fit to Extent'**
  String get fitToExtent;

  /// No description provided for @assessedOn.
  ///
  /// In en, this message translates to:
  /// **'Assessed on {date}'**
  String assessedOn(String date);

  /// No description provided for @readinessScoreUppercase.
  ///
  /// In en, this message translates to:
  /// **'READINESS SCORE'**
  String get readinessScoreUppercase;

  /// No description provided for @initializing3dEngine.
  ///
  /// In en, this message translates to:
  /// **'Initializing 3D Engine...'**
  String get initializing3dEngine;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @signInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInLink;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
