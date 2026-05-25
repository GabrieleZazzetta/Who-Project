// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Strumento di Valutazione Strutture Sanitarie';

  @override
  String get authorizedPersonnelOnly => 'SOLO PERSONALE AUTORIZZATO';

  @override
  String get welcomeBack => 'Bentornato';

  @override
  String get signInToContinue =>
      'Accedi per continuare le tue attività di valutazione.';

  @override
  String get whoStaff => 'Personale OMS';

  @override
  String get externalPartner => 'Partner Esterno';

  @override
  String get whoIdEmail => 'ID OMS / Email';

  @override
  String get partnerEmail => 'Email Partner';

  @override
  String get wimsPassword => 'Password WIMS';

  @override
  String get forgotPassword => 'Password Dimenticata?';

  @override
  String get authenticate => 'Autenticati';

  @override
  String get dontHaveAccount => 'Non hai un account? ';

  @override
  String get registerHere => 'Registrati Qui';

  @override
  String get settings => 'Impostazioni';

  @override
  String get accountAndSync => 'ACCOUNT E SINC';

  @override
  String get userProfile => 'Profilo Utente';

  @override
  String get offlineSync => 'Sincronizzazione Offline';

  @override
  String get preferences => 'PREFERENZE';

  @override
  String get language => 'Lingua';

  @override
  String get about => 'INFORMAZIONI';

  @override
  String get whoGuidelines => 'Linee Guida OMS';

  @override
  String get privacyPolicy => 'Informativa sulla Privacy';

  @override
  String get appVersion => 'Versione App';

  @override
  String get logOut => 'Disconnetti';

  @override
  String get chooseLanguage => 'Scegli Lingua';

  @override
  String get appTitleLine1 => 'Strutture Sanitarie';

  @override
  String get appTitleLine2 => 'Strumento di Valutazione';

  @override
  String get appTitleMultiline =>
      'Strutture Sanitarie\nStrumento di Valutazione';

  @override
  String get requiredField => 'Campo obbligatorio';

  @override
  String get whoStaffEmailError =>
      'Il personale WHO deve usare un\'email @who.int';

  @override
  String get invalidEmailError => 'Inserisci un indirizzo email valido';

  @override
  String get loginFailed => 'Accesso fallito: ';

  @override
  String get home => 'Home';

  @override
  String get assessments => 'Valutazioni';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get infoDialogTitle => 'Strumento di Valutazione WHO';

  @override
  String get infoDialogBody =>
      'Questa applicazione fornisce strumenti per la valutazione strutturale rapida delle strutture sanitarie durante epidemie di malattie infettive, in base alle linee guida ufficiali dell\'OMS.';

  @override
  String get close => 'Chiudi';

  @override
  String get statusActive => 'Attivo';

  @override
  String get statusSoon => 'Presto';

  @override
  String get moduleLocked => 'Modulo attualmente bloccato.';

  @override
  String get selectFacilityType => 'Seleziona Struttura';

  @override
  String facilitiesLabel(String emergencyName) {
    return 'Strutture per $emergencyName';
  }

  @override
  String facilitySelectionDescription(String emergencyName) {
    return 'Scegli la specifica configurazione della struttura sanitaria per procedere con il modulo di valutazione per $emergencyName.';
  }

  @override
  String get moduleLockedDevelopment =>
      'Modulo bloccato o in fase di sviluppo.';

  @override
  String get collapseMenu => 'Comprimi Menu';

  @override
  String get expandMenu => 'Espandi Menu';

  @override
  String get back => 'Indietro';

  @override
  String get step1Title => 'Informazioni sulla Valutazione';

  @override
  String get step1Desc =>
      'Inserisci un titolo per identificare facilmente questa valutazione in futuro, insieme ai dettagli del valutatore.';

  @override
  String get assessmentTitleLabel =>
      'Titolo Valutazione (es. Ospedale Nord - Base)';

  @override
  String get assessmentDateLabel => 'Data della valutazione';

  @override
  String get selectDate => 'Seleziona Data';

  @override
  String get assessorNameLabel =>
      'Nome della persona che conduce la valutazione';

  @override
  String get assessorEmailLabel =>
      'Email della persona che conduce la valutazione';

  @override
  String get assessorPhoneLabel =>
      'Telefono della persona che conduce la valutazione';

  @override
  String get step2Title => 'Posizione Geografica';

  @override
  String get countryLabel => 'Nazione';

  @override
  String get regionLabel => 'Nome della regione/provincia';

  @override
  String get districtLabel => 'Nome del distretto';

  @override
  String get cityLabel => 'Nome della città/villaggio/località';

  @override
  String get addressLabel => 'Indirizzo della struttura / coordinate GPS';

  @override
  String get locationRecordLabel => 'Tipo di posizione della struttura';

  @override
  String get step3Title => 'Identificazione della Struttura';

  @override
  String metadataAutofill(String emergencyType, String facilityType) {
    return 'Compilazione Automatica: La valutazione è impostata per $emergencyType in una struttura di tipo: \'$facilityType\'.';
  }

  @override
  String get facilityCodeLabel => 'Codice della struttura';

  @override
  String get facilityNameLabel => 'Nome della struttura';

  @override
  String get managingAuthorityLabel => 'Autorità di gestione';

  @override
  String get directorNameLabel => 'Nome del direttore/manager della struttura';

  @override
  String get directorPhoneLabel =>
      'Telefono del direttore/manager della struttura';

  @override
  String get directorEmailLabel =>
      'Email del direttore/manager della struttura';

  @override
  String get respondentNameLabel => 'Nome del rispondente o informatore chiave';

  @override
  String get respondentPositionLabel =>
      'Posizione del rispondente o informatore chiave';

  @override
  String get structureTypeLabel => 'Tipo di struttura';

  @override
  String get existingFacilityTypeLabel =>
      'Tipo di struttura sanitaria esistente';

  @override
  String get step4Title => 'Servizi Sanitari Esistenti';

  @override
  String get offersOutpatientLabel =>
      'La struttura offre servizi ambulatoriali';

  @override
  String get offersInpatientLabel => 'La struttura offre servizi di degenza';

  @override
  String get inpatientCapacityDesc =>
      'Si prega di fornire i dettagli sulla capacità di degenza.';

  @override
  String get totalBedsLabel =>
      'Numero totale di posti letto per degenza/pernottamento';

  @override
  String get icuBedsLabel =>
      'Del totale dei posti letto, quanti sono di terapia intensiva (ICU)?';

  @override
  String get has24hEmergencyLabel =>
      'La struttura ha un\'unità di emergenza aperta 24 ore su 24';

  @override
  String get hasIcuOrHduLabel =>
      'La struttura ha un\'unità di terapia intensiva o sub-intensiva';

  @override
  String get facilityConfigurationTitle => 'Configurazione Struttura';

  @override
  String facilityConfigurationDesc(String emergencyType) {
    return 'Completa i passaggi di pre-valutazione per configurare l\'ambiente per $emergencyType.';
  }

  @override
  String stepProgress(int current, int total) {
    return 'Passaggio $current di $total';
  }

  @override
  String get backButton => 'Indietro';

  @override
  String get nextButton => 'Avanti';

  @override
  String get submitButton => 'Invia';

  @override
  String get unnamedAssessment => 'Valutazione Senza Nome';

  @override
  String get dateOfBirthError => 'Seleziona la tua Data di Nascita';

  @override
  String get passwordReqError => 'Soddisfa tutti i requisiti della password';

  @override
  String get registrationSuccess => 'Registrazione riuscita! Benvenuto.';

  @override
  String get registrationFailed => 'Registrazione fallita: ';

  @override
  String get joinPlatform => 'Unisciti alla Piattaforma';

  @override
  String get createAccountDescGlobal =>
      'Crea il tuo account per iniziare a gestire le valutazioni delle strutture sanitarie a livello globale.';

  @override
  String get authorizedPersonnel => 'SOLO PERSONALE AUTORIZZATO';

  @override
  String get createAccountTitle => 'Crea Account';

  @override
  String get createAccountDescAuth =>
      'Inserisci i tuoi dettagli per registrarti come utente autorizzato.';

  @override
  String get createAccountDescStart => 'Crea il tuo account per iniziare.';

  @override
  String get whoStaffRole => 'Personale OMS';

  @override
  String get externalPartnerRole => 'Partner Esterno';

  @override
  String get firstNameLabel => 'Nome';

  @override
  String get lastNameLabel => 'Cognome';

  @override
  String get dobLabel => 'Data di Nascita';

  @override
  String get whoEmailLabel => 'Indirizzo Email OMS';

  @override
  String get emailLabel => 'Indirizzo Email';

  @override
  String get requiredValidation => 'Obbligatorio';

  @override
  String get createPasswordLabel => 'Crea Password';

  @override
  String get passwordMustContain => 'La password deve contenere:';

  @override
  String get chars8Plus => '8+ Caratteri';

  @override
  String get uppercase => 'Maiuscola';

  @override
  String get number => 'Numero';

  @override
  String get special => 'Speciale';

  @override
  String get registerAccountBtn => 'Registra Account';

  @override
  String get alreadyHaveAccount => 'Hai già un account? ';

  @override
  String get addNote => 'Aggiungi Nota';

  @override
  String get editNote => 'Modifica Nota';

  @override
  String get enterObservations => 'Inserisci qui le tue osservazioni...';

  @override
  String get cancel => 'Annulla';

  @override
  String get saveNote => 'Salva Nota';

  @override
  String get takePhoto => 'Scatta una Foto';

  @override
  String get chooseGallery => 'Scegli dalla Galleria';

  @override
  String get errorPickingImage =>
      'Errore durante la selezione dell\'immagine: ';

  @override
  String get cameraAccessRequired => 'Accesso alla Fotocamera Richiesto';

  @override
  String get cameraAccessMsg =>
      'Per catturare prove della struttura, questa app richiede i permessi per la fotocamera. Abilita l\'accesso nelle Impostazioni di Sistema del dispositivo.';

  @override
  String get understood => 'Capito';

  @override
  String get overallCompletion => 'Completamento Generale';

  @override
  String completedPct(String pct) {
    return 'Completato al $pct%';
  }

  @override
  String get areaChecklist => 'Checklist dell\'Area';

  @override
  String get areaAssessmentChecklist => 'Checklist di Valutazione dell\'Area';

  @override
  String get meetsTarget => 'Soddisfa\n(3 pt)';

  @override
  String get partiallyMeets => 'Soddisfa in parte\n(2 pt)';

  @override
  String get doesNotMeet => 'Non soddisfa\n(1 pt)';

  @override
  String get addPhoto => 'Aggiungi Foto';

  @override
  String get evaluationCriteria => 'Criteri di Valutazione';

  @override
  String get gotIt => 'Ho capito';

  @override
  String get howToImprove => 'COME MIGLIORARE IL DESIGN';

  @override
  String get savedAssessments => 'Valutazioni Salvate';

  @override
  String get analytics => 'Analitiche';

  @override
  String get searchAssessment => 'Cerca valutazione per nome...';

  @override
  String get viewOnMap => 'Visualizza sulla Mappa';

  @override
  String get sortBy => 'ORDINA PER';

  @override
  String get newestFirst => 'Più recenti';

  @override
  String get highestScore => 'Punteggio più alto';

  @override
  String get lowestScore => 'Punteggio più basso';

  @override
  String get dateFilter => 'FILTRO DATA';

  @override
  String get clearDateFilter => 'Rimuovi Filtro Data';

  @override
  String get noAssessmentsMatch => 'Nessuna valutazione corrisponde ai filtri.';

  @override
  String get selectAssessmentToView =>
      'Seleziona una valutazione per i dettagli';

  @override
  String get openInteractiveMap => 'Apri Mappa Interattiva';

  @override
  String get criticalFails => 'Errori Critici';

  @override
  String get zonesEvaluated => 'Zone Valutate';

  @override
  String get zoneBreakdown => 'Dettaglio Zone';

  @override
  String get deleteAssessment => 'Elimina Valutazione';

  @override
  String get deleteAssessmentConfirm =>
      'Sei sicuro di voler eliminare definitivamente questa valutazione? L\'azione non può essere annullata.';

  @override
  String get delete => 'Elimina';

  @override
  String get assessmentDeleted => 'Valutazione eliminata con successo.';

  @override
  String get inProgress => 'In Corso';

  @override
  String get completed => 'Completato';

  @override
  String get allCountries => 'Tutti i Paesi';

  @override
  String get allYears => 'Tutti gli Anni';

  @override
  String get dataAnalytics => 'Analitiche dei Dati';

  @override
  String get advancedCharts => 'Grafici Avanzati';

  @override
  String get noReportsAvailable =>
      'Nessun report disponibile per questa selezione.';

  @override
  String get assessmentsCount => 'Valutazioni';

  @override
  String get assessmentsCountInfo =>
      'Numero totale di valutazioni di strutture completate.';

  @override
  String get avgReadiness => 'Prontezza Media';

  @override
  String get avgReadinessInfo =>
      'La percentuale media che indica quanto le strutture valutate soddisfino gli standard richiesti.';

  @override
  String get criticalFailsInfo =>
      'Numero di criteri ad alta priorità che non hanno soddisfatto i requisiti minimi.';

  @override
  String get complianceBreakdown => 'Ripartizione della Conformità';

  @override
  String distributionCriteria(int total) {
    return 'Distribuzione di $total criteri valutati';
  }

  @override
  String get complianceBreakdownInfo =>
      'Visualizza la percentuale di criteri che soddisfano completamente (Soddisfa), soddisfano parzialmente (Parziale) o non soddisfano (Non Soddisfa) gli standard.';

  @override
  String get meets => 'Soddisfa';

  @override
  String get partial => 'Parziale';

  @override
  String get fails => 'Non Soddisfa';

  @override
  String get categoryPerformance => 'Performance per Categoria';

  @override
  String get readinessScoreTech => 'Punteggio di prontezza per aree tecniche';

  @override
  String get categoryPerformanceInfo =>
      'Punteggi medi di conformità raggruppati per categorie tecniche come IPC, WASH e Logistica.';

  @override
  String get geographicalRanking => 'Classifica Geografica';

  @override
  String get avgReadinessCountry => 'Punteggio medio di prontezza per paese';

  @override
  String get geographicalRankingInfo =>
      'Confronta le prestazioni di prontezza tra diversi paesi o regioni.';

  @override
  String get countryRegion => 'Paese / Regione';

  @override
  String get reportingYear => 'Anno di Riferimento';

  @override
  String get advancedAnalytics => 'Analitiche Avanzate';

  @override
  String get noDataToDisplay => 'Nessun dato da mostrare.';

  @override
  String get readinessTrend => 'Tendenza di Prontezza';

  @override
  String get evolutionOfGlobalScore => 'Evoluzione del punteggio globale';

  @override
  String get performanceRadar => 'Radar delle Prestazioni';

  @override
  String get pillarsBalance => 'Equilibrio dei pilastri';

  @override
  String get evolutionGlobalScoreTime =>
      'Evoluzione del punteggio globale nel tempo';

  @override
  String get multidimensionalPerformance => 'Prestazioni Multidimensionali';

  @override
  String get balanceAcrossPillars => 'Equilibrio tra i pilastri tecnici';

  @override
  String get thisAssessment => 'questa valutazione';

  @override
  String readinessScoreFor(String name) {
    return 'Punteggio di prontezza per $name';
  }

  @override
  String get addMoreAssessmentsUnlock =>
      'Aggiungi altre valutazioni per sbloccare l\'analisi dei trend.';

  @override
  String get notEnoughHistoricalData =>
      'Dati storici insufficienti per l\'analisi dei trend. Sono necessarie almeno 2 valutazioni.';

  @override
  String assessmentIndex(int index) {
    return 'Valutazione $index';
  }

  @override
  String get spatialAssessment => 'Valutazione Spaziale';

  @override
  String get viewSavedAssessments => 'Visualizza Valutazioni Salvate';

  @override
  String get generalAssessment => 'Valutazione Generale';

  @override
  String get pinchToExplore =>
      'Pizzica per esplorare. Tocca i pin evidenziati per valutare.';

  @override
  String get unnamedFacility => 'Struttura Senza Nome';

  @override
  String get unknownCity => 'Città Sconosciuta';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get globalReadiness => 'PRONTEZZA GLOBALE';

  @override
  String get viewDetails => 'Vedi Dettagli';

  @override
  String get globalAssessmentMap => 'Mappa di Valutazione Globale';

  @override
  String get calibratingSatelliteImagery =>
      'Calibrazione Immagini Satellitari...';

  @override
  String get syncingAssessmentCoordinates =>
      'Sincronizzazione coordinate di valutazione';

  @override
  String get fitToExtent => 'Adatta alla Vista';

  @override
  String assessedOn(String date) {
    return 'Valutato il $date';
  }

  @override
  String get readinessScoreUppercase => 'PUNTEGGIO DI PRONTEZZA';

  @override
  String get initializing3dEngine => 'Inizializzazione Motore 3D...';

  @override
  String get filterAll => 'Tutti';

  @override
  String get signInLink => 'Accedi';

  @override
  String get warningUnsavedDataTitle => 'Attenzione: Dati Non Salvati';

  @override
  String get warningUnsavedDataBody =>
      'Ci sono valutazioni offline non ancora inviate al server.\n\nSe procedi con il logout adesso, tutti i dati non sincronizzati verranno definitivamente persi. Sei sicuro di voler uscire?';

  @override
  String get logoutAndLoseData => 'Esci e Perdi i Dati';
}
