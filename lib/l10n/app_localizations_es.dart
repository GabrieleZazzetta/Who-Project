// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Herramienta de Evaluación de Salud';

  @override
  String get authorizedPersonnelOnly => 'SOLO PERSONAL AUTORIZADO';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get signInToContinue =>
      'Inicie sesión para continuar sus actividades.';

  @override
  String get whoStaff => 'Personal de la OMS';

  @override
  String get externalPartner => 'Socio Externo';

  @override
  String get whoIdEmail => 'ID OMS / Correo';

  @override
  String get partnerEmail => 'Correo del Socio';

  @override
  String get wimsPassword => 'Contraseña WIMS';

  @override
  String get forgotPassword => '¿Olvidó su contraseña?';

  @override
  String get authenticate => 'Autenticar';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta? ';

  @override
  String get registerHere => 'Regístrate Aquí';

  @override
  String get settings => 'Ajustes';

  @override
  String get accountAndSync => 'CUENTA Y SINC';

  @override
  String get userProfile => 'Perfil de Usuario';

  @override
  String get offlineSync => 'Sincronización Offline';

  @override
  String get preferences => 'PREFERENCIAS';

  @override
  String get language => 'Idioma';

  @override
  String get about => 'ACERCA DE';

  @override
  String get whoGuidelines => 'Directrices OMS';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get appVersion => 'Versión de la App';

  @override
  String get logOut => 'Cerrar Sesión';

  @override
  String get chooseLanguage => 'Elegir Idioma';

  @override
  String get appTitleLine1 => 'Instalaciones de Salud';

  @override
  String get appTitleLine2 => 'Herramienta de Evaluación';

  @override
  String get appTitleMultiline =>
      'Instalaciones de Salud\nHerramienta de Evaluación';

  @override
  String get requiredField => 'Campo requerido';

  @override
  String get whoStaffEmailError =>
      'El personal de la OMS debe usar un correo @who.int';

  @override
  String get invalidEmailError => 'Introduce un correo electrónico válido';

  @override
  String get loginFailed => 'Error de inicio de sesión: ';

  @override
  String get home => 'Inicio';

  @override
  String get assessments => 'Evaluaciones';

  @override
  String get dashboard => 'Panel';

  @override
  String get infoDialogTitle => 'Herramienta de Evaluación de la OMS';

  @override
  String get infoDialogBody =>
      'Esta aplicación proporciona herramientas de evaluación estructural rápida para instalaciones de salud durante brotes de enfermedades infecciosas, basadas en pautas oficiales de la OMS.';

  @override
  String get close => 'Cerrar';

  @override
  String get statusActive => 'Activo';

  @override
  String get statusSoon => 'Pronto';

  @override
  String get moduleLocked => 'Módulo bloqueado actualmente.';

  @override
  String get selectFacilityType => 'Seleccionar Instalación';

  @override
  String facilitiesLabel(String emergencyName) {
    return 'Instalaciones para $emergencyName';
  }

  @override
  String facilitySelectionDescription(String emergencyName) {
    return 'Elige la configuración específica de la instalación de salud para proceder con el módulo de evaluación de $emergencyName.';
  }

  @override
  String get moduleLockedDevelopment => 'Módulo bloqueado o en desarrollo.';

  @override
  String get collapseMenu => 'Ocultar Menú';

  @override
  String get expandMenu => 'Expandir Menú';

  @override
  String get back => 'Volver';

  @override
  String get step1Title => 'Información de la Evaluación';

  @override
  String get step1Desc =>
      'Introduce un título para identificar fácilmente esta evaluación más adelante, junto con los detalles del evaluador.';

  @override
  String get assessmentTitleLabel =>
      'Título de Evaluación (ej. Hospital Norte - Base)';

  @override
  String get assessmentDateLabel => 'Fecha de la evaluación';

  @override
  String get selectDate => 'Seleccionar Fecha';

  @override
  String get assessorNameLabel =>
      'Nombre de la persona que realiza la evaluación';

  @override
  String get assessorEmailLabel =>
      'Correo electrónico de la persona que realiza la evaluación';

  @override
  String get assessorPhoneLabel =>
      'Teléfono de la persona que realiza la evaluación';

  @override
  String get step2Title => 'Ubicación Geográfica';

  @override
  String get countryLabel => 'País';

  @override
  String get regionLabel => 'Nombre de la región/provincia';

  @override
  String get districtLabel => 'Nombre del distrito';

  @override
  String get cityLabel => 'Nombre de la ciudad/pueblo/localidad';

  @override
  String get addressLabel => 'Dirección de la instalación / coordenadas GPS';

  @override
  String get locationRecordLabel => 'Tipo de ubicación de la instalación';

  @override
  String get step3Title => 'Identificación de la Instalación';

  @override
  String metadataAutofill(String emergencyType, String facilityType) {
    return 'Autocompletado: La evaluación está configurada para $emergencyType en una instalación tipo: \'$facilityType\'.';
  }

  @override
  String get facilityCodeLabel => 'Código de la instalación';

  @override
  String get facilityNameLabel => 'Nombre de la instalación';

  @override
  String get managingAuthorityLabel => 'Autoridad de gestión';

  @override
  String get directorNameLabel =>
      'Nombre del director/gerente de la instalación';

  @override
  String get directorPhoneLabel =>
      'Teléfono del director/gerente de la instalación';

  @override
  String get directorEmailLabel =>
      'Correo electrónico del director/gerente de la instalación';

  @override
  String get respondentNameLabel => 'Nombre del encuestado o informante clave';

  @override
  String get respondentPositionLabel =>
      'Cargo del encuestado o informante clave';

  @override
  String get structureTypeLabel => 'Tipo de estructura';

  @override
  String get existingFacilityTypeLabel =>
      'Tipo de instalación de salud existente';

  @override
  String get step4Title => 'Servicios de Salud Existentes';

  @override
  String get offersOutpatientLabel =>
      'La instalación ofrece servicios ambulatorios';

  @override
  String get offersInpatientLabel =>
      'La instalación ofrece servicios de hospitalización';

  @override
  String get inpatientCapacityDesc =>
      'Por favor proporciona detalles de capacidad de hospitalización.';

  @override
  String get totalBedsLabel => 'Número total de camas de hospitalización/noche';

  @override
  String get icuBedsLabel =>
      'Del número total de camas, ¿cuántas son de cuidados intensivos (UCI)?';

  @override
  String get has24hEmergencyLabel =>
      'La instalación tiene una unidad de emergencias 24 horas con personal';

  @override
  String get hasIcuOrHduLabel =>
      'La instalación tiene unidad de cuidados intensivos o de alta dependencia';

  @override
  String get facilityConfigurationTitle => 'Configuración de Instalación';

  @override
  String facilityConfigurationDesc(String emergencyType) {
    return 'Completa los pasos de pre-evaluación para configurar el entorno para $emergencyType.';
  }

  @override
  String stepProgress(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get backButton => 'Atrás';

  @override
  String get nextButton => 'Siguiente';

  @override
  String get submitButton => 'Enviar';

  @override
  String get unnamedAssessment => 'Evaluación sin nombre';

  @override
  String get dateOfBirthError => 'Por favor, selecciona tu fecha de nacimiento';

  @override
  String get passwordReqError => 'Cumple todos los requisitos de la contraseña';

  @override
  String get registrationSuccess => '¡Registro exitoso! Bienvenido.';

  @override
  String get registrationFailed => 'Error en el registro: ';

  @override
  String get joinPlatform => 'Únete a la Plataforma';

  @override
  String get createAccountDescGlobal =>
      'Crea tu cuenta para comenzar a gestionar evaluaciones de instalaciones de salud a nivel mundial.';

  @override
  String get authorizedPersonnel => 'SÓLO PERSONAL AUTORIZADO';

  @override
  String get createAccountTitle => 'Crear Cuenta';

  @override
  String get createAccountDescAuth =>
      'Ingresa tus detalles para registrarte como usuario autorizado.';

  @override
  String get createAccountDescStart => 'Crea tu cuenta para empezar.';

  @override
  String get whoStaffRole => 'Personal de la OMS';

  @override
  String get externalPartnerRole => 'Socio Externo';

  @override
  String get firstNameLabel => 'Nombre';

  @override
  String get lastNameLabel => 'Apellido';

  @override
  String get dobLabel => 'Fecha de Nacimiento';

  @override
  String get whoEmailLabel => 'Correo de la OMS';

  @override
  String get emailLabel => 'Correo Electrónico';

  @override
  String get requiredValidation => 'Obligatorio';

  @override
  String get createPasswordLabel => 'Crear Contraseña';

  @override
  String get passwordMustContain => 'La contraseña debe contener:';

  @override
  String get chars8Plus => '8+ Caract.';

  @override
  String get uppercase => 'Mayúscula';

  @override
  String get number => 'Número';

  @override
  String get special => 'Especial';

  @override
  String get registerAccountBtn => 'Registrar Cuenta';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get addNote => 'Añadir Nota';

  @override
  String get editNote => 'Editar Nota';

  @override
  String get enterObservations => 'Ingresa tus observaciones aquí...';

  @override
  String get cancel => 'Cancelar';

  @override
  String get saveNote => 'Guardar Nota';

  @override
  String get takePhoto => 'Tomar una Foto';

  @override
  String get chooseGallery => 'Elegir de la Galería';

  @override
  String get errorPickingImage => 'Error al elegir imagen: ';

  @override
  String get cameraAccessRequired => 'Acceso a la Cámara Requerido';

  @override
  String get cameraAccessMsg =>
      'Para capturar evidencia de la instalación, esta aplicación requiere permisos de cámara. Por favor, habilita el acceso en la Configuración del Sistema de tu dispositivo.';

  @override
  String get understood => 'Entendido';

  @override
  String get overallCompletion => 'Finalización General';

  @override
  String completedPct(String pct) {
    return '$pct% Completado';
  }

  @override
  String get areaChecklist => 'Lista de Verificación del Área';

  @override
  String get areaAssessmentChecklist =>
      'Lista de Verificación de Evaluación del Área';

  @override
  String get meetsTarget => 'Cumple\n(3 pts)';

  @override
  String get partiallyMeets => 'Cumple Parc.\n(2 pts)';

  @override
  String get doesNotMeet => 'No Cumple\n(1 pt)';

  @override
  String get addPhoto => 'Añadir Foto';

  @override
  String get evaluationCriteria => 'Criterios de Evaluación';

  @override
  String get gotIt => 'Entendido';

  @override
  String get howToImprove => 'CÓMO MEJORAR TU DISEÑO';

  @override
  String get savedAssessments => 'Evaluaciones Guardadas';

  @override
  String get analytics => 'Analíticas';

  @override
  String get searchAssessment => 'Buscar evaluación por nombre...';

  @override
  String get viewOnMap => 'Ver en el Mapa';

  @override
  String get sortBy => 'ORDENAR POR';

  @override
  String get newestFirst => 'Más recientes primero';

  @override
  String get highestScore => 'Puntuación más alta';

  @override
  String get lowestScore => 'Puntuación más baja';

  @override
  String get dateFilter => 'FILTRO DE FECHA';

  @override
  String get clearDateFilter => 'Borrar Filtro de Fecha';

  @override
  String get noAssessmentsMatch =>
      'Ninguna evaluación coincide con tus filtros.';

  @override
  String get selectAssessmentToView =>
      'Selecciona una evaluación para ver detalles';

  @override
  String get openInteractiveMap => 'Abrir Mapa Interactivo';

  @override
  String get criticalFails => 'Fallos Críticos';

  @override
  String get zonesEvaluated => 'Zonas Evaluadas';

  @override
  String get zoneBreakdown => 'Desglose por Zona';

  @override
  String get deleteAssessment => 'Eliminar Evaluación';

  @override
  String get deleteAssessmentConfirm =>
      '¿Estás seguro de que deseas eliminar permanentemente esta evaluación? Esta acción no se puede deshacer.';

  @override
  String get delete => 'Eliminar';

  @override
  String get assessmentDeleted => 'Evaluación eliminada con éxito.';

  @override
  String get inProgress => 'En Progreso';

  @override
  String get completed => 'Completado';

  @override
  String get allCountries => 'Todos los Países';

  @override
  String get allYears => 'Todos los Años';

  @override
  String get dataAnalytics => 'Analítica de Datos';

  @override
  String get advancedCharts => 'Gráficos Avanzados';

  @override
  String get noReportsAvailable =>
      'No hay reportes disponibles para esta selección.';

  @override
  String get assessmentsCount => 'Evaluaciones';

  @override
  String get assessmentsCountInfo =>
      'Número total de evaluaciones de instalaciones completadas.';

  @override
  String get avgReadiness => 'Preparación Promedio';

  @override
  String get avgReadinessInfo =>
      'El porcentaje promedio que indica qué tan bien las instalaciones evaluadas cumplen con los estándares requeridos.';

  @override
  String get criticalFailsInfo =>
      'Número de criterios de alta prioridad que no cumplieron con los requisitos mínimos.';

  @override
  String get complianceBreakdown => 'Desglose de Cumplimiento';

  @override
  String distributionCriteria(int total) {
    return 'Distribución de $total criterios evaluados';
  }

  @override
  String get complianceBreakdownInfo =>
      'Visualiza el porcentaje de criterios que cumplen completamente (Cumple), cumplen parcialmente (Parcial) o fallan (Falla) los estándares.';

  @override
  String get meets => 'Cumple';

  @override
  String get partial => 'Parcial';

  @override
  String get fails => 'Falla';

  @override
  String get categoryPerformance => 'Rendimiento por Categoría';

  @override
  String get readinessScoreTech =>
      'Puntaje de preparación a través de áreas técnicas';

  @override
  String get categoryPerformanceInfo =>
      'Puntajes promedio de cumplimiento agrupados por categorías técnicas como IPC, WASH y Logística.';

  @override
  String get geographicalRanking => 'Clasificación Geográfica';

  @override
  String get avgReadinessCountry => 'Puntaje promedio de preparación por país';

  @override
  String get geographicalRankingInfo =>
      'Compara el rendimiento de preparación entre diferentes países o regiones.';

  @override
  String get countryRegion => 'País / Región';

  @override
  String get reportingYear => 'Año de Reporte';

  @override
  String get advancedAnalytics => 'Analíticas Avanzadas';

  @override
  String get noDataToDisplay => 'No hay datos para mostrar.';

  @override
  String get readinessTrend => 'Tendencia de Preparación';

  @override
  String get evolutionOfGlobalScore => 'Evolución del puntaje global';

  @override
  String get performanceRadar => 'Radar de Rendimiento';

  @override
  String get pillarsBalance => 'Equilibrio de pilares';

  @override
  String get evolutionGlobalScoreTime =>
      'Evolución del puntaje global en el tiempo';

  @override
  String get multidimensionalPerformance => 'Rendimiento Multidimensional';

  @override
  String get balanceAcrossPillars => 'Equilibrio a través de pilares técnicos';

  @override
  String get thisAssessment => 'esta evaluación';

  @override
  String readinessScoreFor(String name) {
    return 'Puntaje de preparación para $name';
  }

  @override
  String get addMoreAssessmentsUnlock =>
      'Agrega más evaluaciones para desbloquear el análisis de tendencias.';

  @override
  String get notEnoughHistoricalData =>
      'No hay suficientes datos históricos para el análisis de tendencias. Se necesitan al menos 2 evaluaciones.';

  @override
  String assessmentIndex(int index) {
    return 'Evaluación $index';
  }

  @override
  String get spatialAssessment => 'Evaluación Espacial';

  @override
  String get viewSavedAssessments => 'Ver Evaluaciones Guardadas';

  @override
  String get generalAssessment => 'Evaluación General';

  @override
  String get pinchToExplore =>
      'Pellizca para explorar. Toca los pines resaltados para evaluar.';

  @override
  String get unnamedFacility => 'Instalación Sin Nombre';

  @override
  String get unknownCity => 'Ciudad Desconocida';

  @override
  String get unknown => 'Desconocido';

  @override
  String get globalReadiness => 'PREPARACIÓN GLOBAL';

  @override
  String get viewDetails => 'Ver Detalles';

  @override
  String get globalAssessmentMap => 'Mapa de Evaluación Global';

  @override
  String get calibratingSatelliteImagery =>
      'Calibrando Imágenes Satelitales...';

  @override
  String get syncingAssessmentCoordinates =>
      'Sincronizando coordenadas de evaluación';

  @override
  String get fitToExtent => 'Ajustar a la Vista';

  @override
  String assessedOn(String date) {
    return 'Evaluado el $date';
  }

  @override
  String get readinessScoreUppercase => 'PUNTAJE DE PREPARACIÓN';

  @override
  String get initializing3dEngine => 'Inicializando Motor 3D...';

  @override
  String get filterAll => 'Todos';

  @override
  String get signInLink => 'Iniciar sesión';
}
