// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Outil d\'Évaluation de Santé';

  @override
  String get authorizedPersonnelOnly => 'PERSONNEL AUTORISÉ UNIQUEMENT';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get signInToContinue => 'Connectez-vous pour continuer vos activités.';

  @override
  String get whoStaff => 'Personnel de l\'OMS';

  @override
  String get externalPartner => 'Partenaire Externe';

  @override
  String get whoIdEmail => 'ID OMS / Email';

  @override
  String get partnerEmail => 'Email du Partenaire';

  @override
  String get wimsPassword => 'Mot de passe WIMS';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get authenticate => 'S\'authentifier';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get registerHere => 'Inscrivez-vous ici';

  @override
  String get settings => 'Paramètres';

  @override
  String get accountAndSync => 'COMPTE ET SYNC';

  @override
  String get userProfile => 'Profil Utilisateur';

  @override
  String get offlineSync => 'Synchronisation Hors Ligne';

  @override
  String get preferences => 'PRÉFÉRENCES';

  @override
  String get language => 'Langue';

  @override
  String get about => 'À PROPOS';

  @override
  String get whoGuidelines => 'Lignes directrices OMS';

  @override
  String get privacyPolicy => 'Confidentialité';

  @override
  String get appVersion => 'Version de l\'App';

  @override
  String get logOut => 'Déconnexion';

  @override
  String get chooseLanguage => 'Choisir la Langue';

  @override
  String get appTitleLine1 => 'Établissements de Santé';

  @override
  String get appTitleLine2 => 'Outil d\'Évaluation';

  @override
  String get appTitleMultiline =>
      'Établissements de Santé\nOutil d\'Évaluation';

  @override
  String get requiredField => 'Champ requis';

  @override
  String get whoStaffEmailError =>
      'Le personnel de l\'OMS doit utiliser un email @who.int';

  @override
  String get invalidEmailError => 'Veuillez entrer une adresse email valide';

  @override
  String get loginFailed => 'Échec de la connexion : ';

  @override
  String get home => 'Accueil';

  @override
  String get assessments => 'Évaluations';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get infoDialogTitle => 'Outil d\'Évaluation de l\'OMS';

  @override
  String get infoDialogBody =>
      'Cette application fournit des outils d\'évaluation structurelle rapide pour les établissements de santé lors d\'épidémies de maladies infectieuses, selon les directives officielles de l\'OMS.';

  @override
  String get close => 'Fermer';

  @override
  String get statusActive => 'Actif';

  @override
  String get statusSoon => 'Bientôt';

  @override
  String get moduleLocked => 'Module actuellement verrouillé.';

  @override
  String get selectFacilityType => 'Sélectionner l\'Établissement';

  @override
  String facilitiesLabel(String emergencyName) {
    return 'Établissements pour $emergencyName';
  }

  @override
  String facilitySelectionDescription(String emergencyName) {
    return 'Choisissez la configuration spécifique de l\'établissement de santé pour procéder au module d\'évaluation de $emergencyName.';
  }

  @override
  String get moduleLockedDevelopment =>
      'Module verrouillé ou en développement.';

  @override
  String get collapseMenu => 'Réduire le Menu';

  @override
  String get expandMenu => 'Développer le Menu';

  @override
  String get back => 'Retour';

  @override
  String get step1Title => 'Informations sur l\'Évaluation';

  @override
  String get step1Desc =>
      'Veuillez entrer un titre pour identifier facilement cette évaluation, ainsi que les détails de l\'évaluateur.';

  @override
  String get assessmentTitleLabel =>
      'Titre de l\'Évaluation (ex: Hôpital Nord - Base)';

  @override
  String get assessmentDateLabel => 'Date de l\'évaluation';

  @override
  String get selectDate => 'Sélectionner la Date';

  @override
  String get assessorNameLabel => 'Nom de la personne réalisant l\'évaluation';

  @override
  String get assessorEmailLabel =>
      'Email de la personne réalisant l\'évaluation';

  @override
  String get assessorPhoneLabel =>
      'Téléphone de la personne réalisant l\'évaluation';

  @override
  String get step2Title => 'Localisation Géographique';

  @override
  String get countryLabel => 'Pays';

  @override
  String get regionLabel => 'Nom de la région/province';

  @override
  String get districtLabel => 'Nom du district';

  @override
  String get cityLabel => 'Nom de la ville/village/localité';

  @override
  String get addressLabel => 'Adresse de l\'établissement / coordonnées GPS';

  @override
  String get locationRecordLabel => 'Type d\'emplacement de l\'établissement';

  @override
  String get step3Title => 'Identification de l\'Établissement';

  @override
  String metadataAutofill(String emergencyType, String facilityType) {
    return 'Remplissage auto : L\'évaluation est configurée pour $emergencyType dans un établissement de type : \'$facilityType\'.';
  }

  @override
  String get facilityCodeLabel => 'Code de l\'établissement';

  @override
  String get facilityNameLabel => 'Nom de l\'établissement';

  @override
  String get managingAuthorityLabel => 'Autorité de gestion';

  @override
  String get directorNameLabel =>
      'Nom du directeur/gestionnaire de l\'établissement';

  @override
  String get directorPhoneLabel =>
      'Téléphone du directeur/gestionnaire de l\'établissement';

  @override
  String get directorEmailLabel =>
      'Email du directeur/gestionnaire de l\'établissement';

  @override
  String get respondentNameLabel => 'Nom du répondant ou informateur clé';

  @override
  String get respondentPositionLabel => 'Poste du répondant ou informateur clé';

  @override
  String get structureTypeLabel => 'Type de structure';

  @override
  String get existingFacilityTypeLabel =>
      'Type d\'établissement de santé existant';

  @override
  String get step4Title => 'Services de Santé Existants';

  @override
  String get offersOutpatientLabel =>
      'L\'établissement propose des services de consultations externes';

  @override
  String get offersInpatientLabel =>
      'L\'établissement propose des services d\'hospitalisation';

  @override
  String get inpatientCapacityDesc =>
      'Veuillez fournir les détails sur la capacité d\'hospitalisation.';

  @override
  String get totalBedsLabel => 'Nombre total de lits d\'hospitalisation/nuitée';

  @override
  String get icuBedsLabel =>
      'Sur le nombre total de lits d\'hospitalisation, combien sont des lits de soins intensifs (USI)?';

  @override
  String get has24hEmergencyLabel =>
      'L\'établissement dispose d\'un service d\'urgences 24h/24';

  @override
  String get hasIcuOrHduLabel =>
      'L\'établissement dispose d\'une unité de soins intensifs ou de haute dépendance';

  @override
  String get facilityConfigurationTitle => 'Configuration de l\'Établissement';

  @override
  String facilityConfigurationDesc(String emergencyType) {
    return 'Complétez les étapes de pré-évaluation pour configurer l\'environnement pour $emergencyType.';
  }

  @override
  String stepProgress(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get backButton => 'Retour';

  @override
  String get nextButton => 'Suivant';

  @override
  String get submitButton => 'Soumettre';

  @override
  String get unnamedAssessment => 'Évaluation sans nom';

  @override
  String get dateOfBirthError =>
      'Veuillez sélectionner votre Date de Naissance';

  @override
  String get passwordReqError =>
      'Veuillez respecter toutes les exigences de mot de passe';

  @override
  String get registrationSuccess => 'Inscription réussie ! Bienvenue.';

  @override
  String get registrationFailed => 'Échec de l\'inscription : ';

  @override
  String get joinPlatform => 'Rejoignez la Plateforme';

  @override
  String get createAccountDescGlobal =>
      'Créez votre compte pour commencer à gérer les évaluations des établissements de santé à l\'échelle mondiale.';

  @override
  String get authorizedPersonnel => 'PERSONNEL AUTORISÉ UNIQUEMENT';

  @override
  String get createAccountTitle => 'Créer un Compte';

  @override
  String get createAccountDescAuth =>
      'Entrez vos coordonnées pour vous inscrire en tant qu\'utilisateur autorisé.';

  @override
  String get createAccountDescStart => 'Créez votre compte pour commencer.';

  @override
  String get whoStaffRole => 'Personnel de l\'OMS';

  @override
  String get externalPartnerRole => 'Partenaire Externe';

  @override
  String get firstNameLabel => 'Prénom';

  @override
  String get lastNameLabel => 'Nom de famille';

  @override
  String get dobLabel => 'Date de Naissance';

  @override
  String get whoEmailLabel => 'Adresse E-mail OMS';

  @override
  String get emailLabel => 'Adresse E-mail';

  @override
  String get requiredValidation => 'Requis';

  @override
  String get createPasswordLabel => 'Créer un Mot de Passe';

  @override
  String get passwordMustContain => 'Le mot de passe doit contenir :';

  @override
  String get chars8Plus => '8+ Caract.';

  @override
  String get uppercase => 'Majuscule';

  @override
  String get number => 'Nombre';

  @override
  String get special => 'Spécial';

  @override
  String get registerAccountBtn => 'Créer le Compte';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get addNote => 'Ajouter une Note';

  @override
  String get editNote => 'Modifier la Note';

  @override
  String get enterObservations => 'Entrez vos observations ici...';

  @override
  String get cancel => 'Annuler';

  @override
  String get saveNote => 'Enregistrer la Note';

  @override
  String get takePhoto => 'Prendre une Photo';

  @override
  String get chooseGallery => 'Choisir dans la Galerie';

  @override
  String get errorPickingImage => 'Erreur lors de la sélection de l\'image : ';

  @override
  String get cameraAccessRequired => 'Accès à la Caméra Requis';

  @override
  String get cameraAccessMsg =>
      'Pour capturer des preuves de l\'installation, cette application nécessite des autorisations pour la caméra. Veuillez activer l\'accès dans les Paramètres Système de votre appareil.';

  @override
  String get understood => 'Compris';

  @override
  String get overallCompletion => 'Achèvement Global';

  @override
  String completedPct(String pct) {
    return '$pct% Terminé';
  }

  @override
  String get areaChecklist => 'Liste de Contrôle de la Zone';

  @override
  String get areaAssessmentChecklist =>
      'Liste de Contrôle de l\'Évaluation de la Zone';

  @override
  String get meetsTarget => 'Atteint\n(3 pts)';

  @override
  String get partiallyMeets => 'Atteint Part.\n(2 pts)';

  @override
  String get doesNotMeet => 'N\'atteint pas\n(1 pt)';

  @override
  String get addPhoto => 'Ajouter une Photo';

  @override
  String get evaluationCriteria => 'Critères d\'Évaluation';

  @override
  String get gotIt => 'Compris';

  @override
  String get howToImprove => 'COMMENT AMÉLIORER VOTRE CONCEPTION';

  @override
  String get savedAssessments => 'Évaluations Enregistrées';

  @override
  String get analytics => 'Analytique';

  @override
  String get searchAssessment => 'Rechercher une évaluation par nom...';

  @override
  String get viewOnMap => 'Voir sur la Carte';

  @override
  String get sortBy => 'TRIER PAR';

  @override
  String get newestFirst => 'Plus récents en premier';

  @override
  String get highestScore => 'Score le plus élevé';

  @override
  String get lowestScore => 'Score le plus bas';

  @override
  String get dateFilter => 'FILTRE DE DATE';

  @override
  String get clearDateFilter => 'Effacer le Filtre de Date';

  @override
  String get noAssessmentsMatch =>
      'Aucune évaluation ne correspond à vos filtres.';

  @override
  String get selectAssessmentToView =>
      'Sélectionnez une évaluation pour les détails';

  @override
  String get openInteractiveMap => 'Ouvrir la Carte Interactive';

  @override
  String get criticalFails => 'Échecs Critiques';

  @override
  String get zonesEvaluated => 'Zones Évaluées';

  @override
  String get zoneBreakdown => 'Répartition par Zone';

  @override
  String get deleteAssessment => 'Supprimer l\'Évaluation';

  @override
  String get deleteAssessmentConfirm =>
      'Êtes-vous sûr de vouloir supprimer définitivement cette évaluation ? Cette action ne peut pas être annulée.';

  @override
  String get delete => 'Supprimer';

  @override
  String get assessmentDeleted => 'Évaluation supprimée avec succès.';

  @override
  String get inProgress => 'En Cours';

  @override
  String get completed => 'Terminé';

  @override
  String get allCountries => 'Tous les Pays';

  @override
  String get allYears => 'Toutes les Années';

  @override
  String get dataAnalytics => 'Analyse des Données';

  @override
  String get advancedCharts => 'Graphiques Avancés';

  @override
  String get noReportsAvailable =>
      'Aucun rapport disponible pour cette sélection.';

  @override
  String get assessmentsCount => 'Évaluations';

  @override
  String get assessmentsCountInfo =>
      'Nombre total d\'évaluations d\'installations terminées.';

  @override
  String get avgReadiness => 'Préparation Moy.';

  @override
  String get avgReadinessInfo =>
      'Le pourcentage moyen indiquant dans quelle mesure les installations évaluées répondent aux normes requises.';

  @override
  String get criticalFailsInfo =>
      'Nombre de critères prioritaires qui n\'ont pas satisfait aux exigences minimales.';

  @override
  String get complianceBreakdown => 'Répartition de la Conformité';

  @override
  String distributionCriteria(int total) {
    return 'Distribution de $total critères évalués';
  }

  @override
  String get complianceBreakdownInfo =>
      'Visualise le pourcentage de critères qui respectent pleinement (Atteint), respectent partiellement (Partiel) ou échouent (Échec) aux normes.';

  @override
  String get meets => 'Atteint';

  @override
  String get partial => 'Partiel';

  @override
  String get fails => 'Échec';

  @override
  String get categoryPerformance => 'Performance par Catégorie';

  @override
  String get readinessScoreTech =>
      'Score de préparation dans les domaines techniques';

  @override
  String get categoryPerformanceInfo =>
      'Scores moyens de conformité regroupés par catégories techniques telles que l\'IPC, le WASH et la Logistique.';

  @override
  String get geographicalRanking => 'Classement Géographique';

  @override
  String get avgReadinessCountry => 'Score moyen de préparation par pays';

  @override
  String get geographicalRankingInfo =>
      'Compare les performances de préparation entre différents pays ou régions.';

  @override
  String get countryRegion => 'Pays / Région';

  @override
  String get reportingYear => 'Année de Déclaration';

  @override
  String get advancedAnalytics => 'Analytique Avancée';

  @override
  String get noDataToDisplay => 'Aucune donnée à afficher.';

  @override
  String get readinessTrend => 'Tendance de Préparation';

  @override
  String get evolutionOfGlobalScore => 'Évolution du score global';

  @override
  String get performanceRadar => 'Radar de Performance';

  @override
  String get pillarsBalance => 'Équilibre des piliers';

  @override
  String get evolutionGlobalScoreTime =>
      'Évolution du score global au fil du temps';

  @override
  String get multidimensionalPerformance => 'Performance Multidimensionnelle';

  @override
  String get balanceAcrossPillars => 'Équilibre entre les piliers techniques';

  @override
  String get thisAssessment => 'cette évaluation';

  @override
  String readinessScoreFor(String name) {
    return 'Score de préparation pour $name';
  }

  @override
  String get addMoreAssessmentsUnlock =>
      'Ajoutez d\'autres évaluations pour débloquer l\'analyse des tendances.';

  @override
  String get notEnoughHistoricalData =>
      'Données historiques insuffisantes pour l\'analyse des tendances. Au moins 2 évaluations sont nécessaires.';

  @override
  String assessmentIndex(int index) {
    return 'Évaluation $index';
  }

  @override
  String get spatialAssessment => 'Évaluation Spatiale';

  @override
  String get viewSavedAssessments => 'Voir les Évaluations Enregistrées';

  @override
  String get generalAssessment => 'Évaluation Générale';

  @override
  String get pinchToExplore =>
      'Pincez pour explorer. Touchez les épingles mises en évidence pour évaluer.';

  @override
  String get unnamedFacility => 'Installation Sans Nom';

  @override
  String get unknownCity => 'Ville Inconnue';

  @override
  String get unknown => 'Inconnu';

  @override
  String get globalReadiness => 'PRÉPARATION GLOBALE';

  @override
  String get viewDetails => 'Voir les Détails';

  @override
  String get globalAssessmentMap => 'Carte d\'Évaluation Globale';

  @override
  String get calibratingSatelliteImagery =>
      'Étalonnage de l\'Imagerie Satellitaire...';

  @override
  String get syncingAssessmentCoordinates =>
      'Synchronisation des coordonnées d\'évaluation';

  @override
  String get fitToExtent => 'Ajuster à l\'Étendue';

  @override
  String assessedOn(String date) {
    return 'Évalué le $date';
  }

  @override
  String get readinessScoreUppercase => 'SCORE DE PRÉPARATION';

  @override
  String get initializing3dEngine => 'Initialisation du Moteur 3D...';

  @override
  String get filterAll => 'Tous';

  @override
  String get signInLink => 'Se connecter';
}
