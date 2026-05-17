import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/assessment_models.dart';
import '../data/facility_data_factory.dart';

class PreAssessmentScreen extends StatefulWidget {
  final EmergencyType emergencyType;
  final FacilityType facilityType;

  const PreAssessmentScreen(
      {super.key, required this.emergencyType, required this.facilityType});

  @override
  State<PreAssessmentScreen> createState() => _PreAssessmentScreenState();
}

class _PreAssessmentScreenState extends State<PreAssessmentScreen> {
  // STATO E CONFIGURAZIONE DEI FORM
  int _currentStep = 0;
  final int _totalSteps = 4;
  bool _isSidebarExpanded = true;

  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Informazioni generali dell'assessment
  final TextEditingController _assessmentNameController =
      TextEditingController();
  DateTime? _assessmentDate = DateTime.now();
  final TextEditingController _assessorNameController = TextEditingController();
  final TextEditingController _assessorEmailController =
      TextEditingController();
  final TextEditingController _assessorPhoneController =
      TextEditingController();

  // Dati di localizzazione geografica
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _locationRecord;

  // Identificazione della struttura sanitaria
  final TextEditingController _facilityCodeController = TextEditingController();
  final TextEditingController _facilityNameController = TextEditingController();
  String? _managingAuthority;
  final TextEditingController _directorNameController = TextEditingController();
  final TextEditingController _directorPhoneController =
      TextEditingController();
  final TextEditingController _directorEmailController =
      TextEditingController();
  final TextEditingController _respondentNameController =
      TextEditingController();
  final TextEditingController _respondentPositionController =
      TextEditingController();
  String? _structureType;
  String? _existingFacilityType;

  // Servizi e capacità della struttura
  String? _offersOutpatient;
  String? _offersInpatient;
  final TextEditingController _inpatientBedsController =
      TextEditingController();
  final TextEditingController _icuBedsController = TextEditingController();
  String? _has24hEmergency;
  String? _hasIcuOrHdu;

  @override
  void dispose() {
    _assessmentNameController.dispose();
    _assessorNameController.dispose();
    _assessorEmailController.dispose();
    _assessorPhoneController.dispose();
    _countryController.dispose();
    _regionController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _facilityCodeController.dispose();
    _facilityNameController.dispose();
    _directorNameController.dispose();
    _directorPhoneController.dispose();
    _directorEmailController.dispose();
    _respondentNameController.dispose();
    _respondentPositionController.dispose();
    _inpatientBedsController.dispose();
    _icuBedsController.dispose();
    super.dispose();
  }

  // LOGICA DI NAVIGAZIONE E INVIO
  String _getFacilityTypeName(FacilityType type) {
    switch (type) {
      case FacilityType.screeningAndIsolation:
        return "Screening and temporary isolation for mpox";
      case FacilityType.existingFacilityWithWard:
        return "Existing Healthcare facility with mpox dedicated ward";
      case FacilityType.standAloneCenter:
        return "Mpox stand-alone treatment centre";
      case FacilityType.congregateSetting:
        return "Screening for Internally Displaced People (IDP) and refugee camps";
    }
  }

  void _nextStep() {
    _formKeys[_currentStep].currentState?.save();
    FocusScope.of(context).unfocus();

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _submitForm();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      FocusScope.of(context).unfocus();
      setState(() => _currentStep--);
    }
  }

  // Finalizzazione del pre-assessment e inizializzazione del layout in memoria
  void _submitForm() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    final layoutData = FacilityDataFactory.getLayout(
        widget.emergencyType, widget.facilityType);
    layoutData.dateCreated = DateTime.now();

    layoutData.facilityName = _assessmentNameController.text.isNotEmpty
        ? _assessmentNameController.text
        : "Unnamed Assessment";

    layoutData.generalInfo = GeneralFacilityInfo()
      ..assessedDisease = widget.emergencyType.name.toUpperCase()
      ..assessedFacilityType = _getFacilityTypeName(widget.facilityType)
      ..assessmentDate = _assessmentDate
      ..assessorName = _assessorNameController.text
      ..assessorEmail = _assessorEmailController.text
      ..assessorPhone = _assessorPhoneController.text
      ..country = _countryController.text
      ..region = _regionController.text
      ..district = _districtController.text
      ..city = _cityController.text
      ..facilityAddressOrGps = _addressController.text
      ..facilityLocationRecord = _locationRecord
      ..facilityCode = _facilityCodeController.text
      ..facilityName = _facilityNameController.text
      ..managingAuthority = _managingAuthority
      ..facilityDirectorName = _directorNameController.text
      ..facilityDirectorPhone = _directorPhoneController.text
      ..facilityDirectorEmail = _directorEmailController.text
      ..respondentName = _respondentNameController.text
      ..respondentPosition = _respondentPositionController.text
      ..structureType = _structureType
      ..existingHealthcareFacilityType = _existingFacilityType
      ..offersOutpatient = _offersOutpatient
      ..offersInpatient = _offersInpatient
      ..inpatientBeds = int.tryParse(_inpatientBedsController.text)
      ..icuBeds = int.tryParse(_icuBedsController.text)
      ..has24hEmergency = _has24hEmergency
      ..hasIcuOrHdu = _hasIcuOrHdu;

    // CHIUSURA DIALOG DI CARICAMENTO
    if (mounted) context.pop();

    if (mounted) {
      // NAVIGAZIONE ALLA MAPPA INTERATTIVA
      // Utilizzo di context.go per sostituire la schermata attuale
      context.go('/map', extra: {
        'emergencyType': widget.emergencyType,
        'facilityType': widget.facilityType,
        'preFilledData': layoutData,
      });
    }
  }

  // METODO DI RENDERING PRINCIPALE E GESTIONE RESPONSIVE
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        final screenWidth = constraints.maxWidth;
        // Allineato alla logica di facility_selection: split layout per schermi larghi in landscape
        final useSplitLayout = isLandscape && screenWidth >= 900;

        if (useSplitLayout) {
          return _buildTabletLayout();
        }
        return _buildMobileLayout();
      },
    );
  }

  // LAYOUT TABLET (SPLIT VIEW PREMIUM)
  // Gestisce la visualizzazione affiancata: branding e progresso a sinistra, form a destra all'interno di una Card.
  Widget _buildTabletLayout() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: _isSidebarExpanded ? 350 : 90,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF003D73), Color(0xFF005DA8)],
              ),
            ),
            child: Stack(
              children: [
                // CONTENUTO SIDEBAR
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100), // Spazio per i tasti dinamici
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _isSidebarExpanded ? 40.0 : 0),
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: _isSidebarExpanded ? 270 : 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (_isSidebarExpanded) ...[
                                  Container(
                                    width: MediaQuery.of(context)
                                                .size
                                                .shortestSide >=
                                            600
                                        ? 190
                                        : 130,
                                    height: MediaQuery.of(context)
                                                .size
                                                .shortestSide >=
                                            600
                                        ? 190
                                        : 130,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            _isSidebarExpanded
                                                ? (MediaQuery.of(context)
                                                            .size
                                                            .shortestSide >=
                                                        600
                                                    ? 24
                                                    : 12)
                                                : 12),
                                        child: Image.asset(
                                          'assets/images/who_logo.png',
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              Icon(Icons.public,
                                                  size: _isSidebarExpanded
                                                      ? 60
                                                      : 30,
                                                  color:
                                                      const Color(0xFF005DA8)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height <
                                                  500
                                              ? 16
                                              : 32),
                                  Text(
                                    "Facility Configuration",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height <
                                                  500
                                              ? 22
                                              : 28,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Complete the pre-assessment steps to set up the environment for ${widget.emergencyType.name}.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height <
                                                  500
                                              ? 14
                                              : 18,
                                      color: Colors.white.withOpacity(0.8),
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  // INDICATORE DI PROGRESSO LATERALE
                                  Text(
                                      "Step ${_currentStep + 1} of $_totalSteps",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: (_currentStep + 1) / _totalSteps,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.2),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                      minHeight: 8,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // TASTO MENU (Dinamico) - POSIZIONATO IN ALTO A DESTRA DELLA SIDEBAR
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  top: 12,
                  left: _isSidebarExpanded ? null : 0,
                  right: _isSidebarExpanded ? 12 : 0,
                  child: _isSidebarExpanded
                      ? IconButton(
                          icon: Icon(
                              _isSidebarExpanded
                                  ? Icons.menu_open_rounded
                                  : Icons.menu_rounded,
                              color: Colors.white),
                          onPressed: () => setState(
                              () => _isSidebarExpanded = !_isSidebarExpanded),
                          tooltip: _isSidebarExpanded
                              ? "Collapse Menu"
                              : "Expand Menu",
                        )
                      : Center(
                          child: IconButton(
                            icon: Icon(
                                _isSidebarExpanded
                                    ? Icons.menu_open_rounded
                                    : Icons.menu_rounded,
                                color: Colors.white),
                            onPressed: () => setState(
                                () => _isSidebarExpanded = !_isSidebarExpanded),
                            tooltip: _isSidebarExpanded
                                ? "Collapse Menu"
                                : "Expand Menu",
                          ),
                        ),
                ),

                // TASTO BACK (Dinamico)
                // Espanso: Top-Left | Contratto: Below Menu Center
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  top: _isSidebarExpanded ? 12 : 55,
                  left: _isSidebarExpanded ? 12 : 0,
                  right: _isSidebarExpanded ? null : 0,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 22),
                      onPressed: () => context.pop(),
                      tooltip: "Back",
                    ),
                  ),
                ),
              ],
            ),
          ),

          // AREA FORM (Destra)
          // Il form espanso liberamente, senza Card, per un look arioso e nativo
          Expanded(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: IndexedStack(
                    index: _currentStep,
                    children: [
                      _buildStep1(),
                      _buildStep2(),
                      _buildStep3(),
                      _buildStep4(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // LAYOUT MOBILE E PORTRAIT
  // Struttura standard verticale con app bar e indicatore di progresso superiore.
  Widget _buildMobileLayout() {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: isTablet ? 80 : 56,
        title: Text("Facility Configuration",
            style: TextStyle(
                fontSize: isTablet ? 32 : 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF003D73))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
            color: const Color(0xFF003D73), size: isTablet ? 28 : 24),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Indicatore di avanzamento step
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: isLandscape ? 8 : 16,
              ),
              child: isLandscape
                  ? Row(
                      children: [
                        Text("Step ${_currentStep + 1} of $_totalSteps",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: (_currentStep + 1) / _totalSteps,
                              backgroundColor: Colors.grey.shade200,
                              color: Theme.of(context).colorScheme.primary,
                              minHeight: 4,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Step ${_currentStep + 1} of $_totalSteps",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: (_currentStep + 1) / _totalSteps,
                          backgroundColor: Colors.grey.shade200,
                          color: Theme.of(context).colorScheme.primary,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ],
                    ),
            ),
            // Contenuto scrollabile con form
            Expanded(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                  _buildStep4(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // COSTRUZIONE DEI SINGOLI STEP DEL FORM
  Widget _buildStep1() {
    return _buildPageWrapper(
      formKey: _formKeys[0],
      title: "Assessment Information",
      icon: Icons.person_pin,
      children: [
        _buildInfoBanner(
            "Please enter a title to easily identify this assessment later, along with the assessor details."),
        _buildQuestionField("Assessment Title (e.g. Hospital North - Baseline)",
            _buildTextInput(_assessmentNameController, Icons.title)),
        _buildQuestionField(
          "Date of assessment",
          Builder(builder: (context) {
            final isWideScreen = MediaQuery.of(context).size.width >= 800;
            return InkWell(
              onTap: () async {
                final date = await showDatePicker(
                    context: context,
                    initialDate: _assessmentDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030));

                if (!mounted) return;
                if (date != null) setState(() => _assessmentDate = date);
              },
              child: InputDecorator(
                decoration:
                    _inputDecoration(Icons.calendar_today, isWideScreen),
                child: Text(
                    _assessmentDate != null
                        ? DateFormat('dd/MM/yyyy').format(_assessmentDate!)
                        : "Select Date",
                    style: TextStyle(fontSize: isWideScreen ? 16 : 15)),
              ),
            );
          }),
        ),
        _buildQuestionField("Name of the person conducting the assessment",
            _buildTextInput(_assessorNameController, Icons.person)),
        _buildQuestionField(
            "Email of the person conducting the assessment",
            _buildTextInput(_assessorEmailController, Icons.email,
                keyboardType: TextInputType.emailAddress)),
        _buildQuestionField(
            "Phone of the person conducting the assessment",
            _buildTextInput(_assessorPhoneController, Icons.phone,
                keyboardType: TextInputType.phone)),
      ],
    );
  }

  Widget _buildStep2() {
    return _buildPageWrapper(
      formKey: _formKeys[1],
      title: "Geographical Location",
      icon: Icons.location_on,
      children: [
        _buildQuestionField(
            "Country", _buildTextInput(_countryController, Icons.flag)),
        _buildQuestionField("Region/province name",
            _buildTextInput(_regionController, Icons.map)),
        _buildQuestionField("District name",
            _buildTextInput(_districtController, Icons.location_city)),
        _buildQuestionField("City/Village/clan/locality name",
            _buildTextInput(_cityController, Icons.home)),
        _buildQuestionField("Address of facility / GPS coordinates",
            _buildTextInput(_addressController, Icons.pin_drop)),
        _buildQuestionField(
            "Record of facility location",
            _buildDropdown(["Urban", "Peri-/ex-urban", "Rural"],
                (val) => _locationRecord = val)),
      ],
    );
  }

  Widget _buildStep3() {
    return _buildPageWrapper(
      formKey: _formKeys[2],
      title: "Facility Identification",
      icon: Icons.local_hospital,
      children: [
        _buildInfoBanner(
            "Metadata Auto-fill: The assessment is set for ${widget.emergencyType.name.toUpperCase()} in a facility type: '${_getFacilityTypeName(widget.facilityType)}'."),
        _buildQuestionField("Facility code",
            _buildTextInput(_facilityCodeController, Icons.numbers)),
        _buildQuestionField("Facility name",
            _buildTextInput(_facilityNameController, Icons.business)),
        _buildQuestionField(
            "Managing authority",
            _buildDropdown([
              "Government / public",
              "Private for profit",
              "Private not for profit (e.g. NGO, faith-based)",
              "Military/Police/National Guard",
              "University",
              "Other ..."
            ], (val) => _managingAuthority = val)),
        _buildQuestionField("Facility director/manager’s name",
            _buildTextInput(_directorNameController, Icons.person_outline)),
        _buildQuestionField(
            "Facility director/manager’s telephone number",
            _buildTextInput(_directorPhoneController, Icons.phone_outlined,
                keyboardType: TextInputType.phone)),
        _buildQuestionField(
            "Facility director/manager’s email address",
            _buildTextInput(_directorEmailController, Icons.email_outlined,
                keyboardType: TextInputType.emailAddress)),
        _buildQuestionField(
            "Respondent or key informant’s name",
            _buildTextInput(
                _respondentNameController, Icons.record_voice_over)),
        _buildQuestionField("Respondent or key informant’s position",
            _buildTextInput(_respondentPositionController, Icons.work_outline)),
        _buildQuestionField(
            "Type of structure",
            _buildDropdown([
              "Permanent facility (existing facility built with i.e. concrete, bricks, etc.)",
              "Temporary (medium-term) facility (i.e. concrete slabs and wooden structure, rub halls, etc.)",
              "Temporary (short-term) facility (i.e. tents, etc.)"
            ], (val) => _structureType = val)),
        _buildQuestionField(
            "Type of existing healthcare facility",
            _buildDropdown([
              "First referral hospital / district hospital",
              "Regional / provincial referral hospital",
              "National referral hospital",
              "Other general hospital with specialties or single-specialty hospital",
              "Infectious diseases unit (IDU)",
              "Other ..."
            ], (val) => _existingFacilityType = val)),
      ],
    );
  }

  Widget _buildStep4() {
    return _buildPageWrapper(
      formKey: _formKeys[3],
      title: "Existing Healthcare Services",
      icon: Icons.medical_services,
      children: [
        _buildQuestionField("The facility offers outpatient services",
            _buildDropdown(["Yes", "No"], (val) => _offersOutpatient = val)),
        _buildQuestionField(
            "The facility offers inpatient services",
            _buildDropdown(["Yes", "No"], (val) {
              setState(() {
                _offersInpatient = val;
                if (val == "No") {
                  _inpatientBedsController.clear();
                  _icuBedsController.clear();
                  _has24hEmergency = null;
                  _hasIcuOrHdu = null;
                }
              });
            })),
        if (_offersInpatient == "Yes") ...[
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.blue.shade50.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoBanner("Please provide inpatient capacity details."),
                _buildQuestionField("Total number of overnight/ inpatient beds",
                    _buildNumberInput(_inpatientBedsController)),
                _buildQuestionField(
                    "Of the total number of inpatient beds, how many are intensive care unit (ICU) beds?",
                    Builder(builder: (context) {
                  final isWideScreen = MediaQuery.of(context).size.width >= 800;
                  return TextFormField(
                    controller: _icuBedsController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: isWideScreen ? 16 : 15),
                    decoration: _inputDecoration(Icons.bed, isWideScreen),
                    validator: (value) => null,
                  );
                })),
                _buildQuestionField(
                    "The facility has dedicated 24-hour staffed emergency unit",
                    _buildDropdown(
                        ["Yes", "No"], (val) => _has24hEmergency = val)),
                _buildQuestionField(
                    "The facility has intensive care or high-dependency unit",
                    _buildDropdown(["Yes", "No"], (val) => _hasIcuOrHdu = val)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // COMPONENTI UI E METODI DI SUPPORTO
  // Wrapper scrollabile unico: campi + bottoni in un solo flusso verticale
  Widget _buildPageWrapper(
      {required GlobalKey<FormState> formKey,
      required String title,
      required IconData icon,
      required List<Widget> children}) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final double pad = isLandscape ? 16.0 : 24.0;
    final double titleSize = isLandscape ? 18.0 : 24.0;
    final double titleSpacing = isLandscape ? 16.0 : 32.0;

    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isTabletLandscape = isTablet && isLandscape;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.all(pad),
      child: Center(
        child: ConstrainedBox(
          // Allargato a 800 per permettere al form di respirare nella nuova visualizzazione Premium
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon,
                          size: isLandscape ? 24 : 32,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(title,
                              style: TextStyle(
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.w900,
                                  color:
                                      Theme.of(context).colorScheme.primary))),
                    ],
                  ),
                  SizedBox(height: titleSpacing),
                  ...children,
                  // SEZIONE BOTTONI DI NAVIGAZIONE
                  // Integrati nel flusso scrollabile per massimizzare lo spazio verticale
                  SizedBox(height: isLandscape ? 16 : 32),
                  Builder(builder: (context) {
                    final bool isPortrait =
                        MediaQuery.of(context).orientation ==
                            Orientation.portrait;
                    final bool isTablet =
                        MediaQuery.of(context).size.shortestSide >= 600;
                    final bool isMobilePortrait = isPortrait && !isTablet;
                    final bool isMobileLandscape = !isPortrait && !isTablet;

                    // Dimensioni adattive per i bottoni
                    // Ancora più compatti in landscape per risparmiare spazio verticale
                    final double btnPadding =
                        isMobilePortrait ? 14 : (isMobileLandscape ? 12 : 20);
                    final double btnFontSize =
                        isMobilePortrait ? 15 : (isMobileLandscape ? 14 : 18);

                    return Row(
                      children: [
                        if (_currentStep > 0)
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding:
                                    EdgeInsets.symmetric(vertical: btnPadding),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.2, // Bordo più nitido
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              clipBehavior: Clip.antiAlias, // Evita sbavature
                              onPressed: _prevStep,
                              child: Text("Back",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary, // Colore solido
                                      fontSize: btnFontSize,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        else
                          const Spacer(),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding:
                                  EdgeInsets.symmetric(vertical: btnPadding),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            onPressed: _nextStep,
                            child: Text(
                                _currentStep == _totalSteps - 1
                                    ? "Start Assessment"
                                    : "Next",
                                style: TextStyle(
                                    fontSize: btnFontSize,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: isLandscape ? 8 : 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Spaziatura e dimensioni tipografiche adattive per tablet vs mobile
  Widget _buildQuestionField(String question, Widget inputField) {
    final bool isWideScreen = MediaQuery.of(context).size.width >= 800;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Se siamo su tablet (wide) in portrait, usiamo font molto più grandi. Altrimenti torniamo al design originale.
    final double fontSize = (isWideScreen && isPortrait)
        ? 19.0
        : (isWideScreen ? 16.0 : (isLandscape ? 13.0 : 15.0));
    final double paddingBottom = (isWideScreen && isPortrait)
        ? 32.0
        : (isWideScreen ? 28.0 : (isLandscape ? 14.0 : 24.0));
    final double spacing = (isWideScreen && isPortrait)
        ? 14.0
        : (isWideScreen ? 12.0 : (isLandscape ? 6.0 : 10.0));

    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B))),
          SizedBox(height: spacing),
          inputField,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(IconData icon, bool isWideScreen) {
    return InputDecoration(
      prefixIcon:
          Icon(icon, size: isWideScreen ? 24 : 20, color: Colors.grey.shade400),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(
          horizontal: isWideScreen ? 20 : 16, vertical: isWideScreen ? 20 : 16),
      errorStyle: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoBanner(String text) {
    final isWideScreen = MediaQuery.of(context).size.width >= 800;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.all(isWideScreen ? 20 : 16),
      decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade100)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, size: isWideScreen ? 24 : 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontSize: isWideScreen ? 15 : 13,
                      color: Colors.blue,
                      height: 1.4))),
        ],
      ),
    );
  }

  Widget _buildTextInput(TextEditingController controller, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    final isWideScreen = MediaQuery.of(context).size.width >= 800;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: isWideScreen ? 16 : 15),
      decoration: _inputDecoration(icon, isWideScreen),
      validator: (value) => null,
    );
  }

  Widget _buildNumberInput(TextEditingController controller) {
    final isWideScreen = MediaQuery.of(context).size.width >= 800;
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: isWideScreen ? 16 : 15),
      decoration: _inputDecoration(Icons.numbers, isWideScreen),
      validator: (value) => null,
    );
  }

  Widget _buildDropdown(List<String> items, Function(String?) onChanged) {
    final isWideScreen = MediaQuery.of(context).size.width >= 800;
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration:
          _inputDecoration(Icons.arrow_drop_down_circle_outlined, isWideScreen),
      items: items
          .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e,
                  style: TextStyle(fontSize: isWideScreen ? 16 : 15),
                  overflow: TextOverflow.ellipsis)))
          .toList(),
      validator: (value) => null,
      onChanged: onChanged,
    );
  }
}
