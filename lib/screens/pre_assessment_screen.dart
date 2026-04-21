import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assessment_models.dart';
import '../services/database_service.dart';
import '../data/facility_data_factory.dart';
import 'interactive_map_screen.dart';

class PreAssessmentScreen extends StatefulWidget {
  final EmergencyType emergencyType;
  final FacilityType facilityType;

  const PreAssessmentScreen(
      {super.key, required this.emergencyType, required this.facilityType});

  @override
  State<PreAssessmentScreen> createState() => _PreAssessmentScreenState();
}

class _PreAssessmentScreenState extends State<PreAssessmentScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;

  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // --- 1. Assessment Info ---
  // NUOVO CAMPO: Titolo dell'ispezione
  final TextEditingController _assessmentNameController =
      TextEditingController();

  DateTime? _assessmentDate = DateTime.now();
  final TextEditingController _assessorNameController = TextEditingController();
  final TextEditingController _assessorEmailController =
      TextEditingController();
  final TextEditingController _assessorPhoneController =
      TextEditingController();

  // --- 2. Location ---
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _locationRecord;

  // --- 3. Identification ---
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

  // --- 4. Services ---
  String? _offersOutpatient;
  String? _offersInpatient;
  final TextEditingController _inpatientBedsController =
      TextEditingController();
  final TextEditingController _icuBedsController = TextEditingController();
  String? _has24hEmergency;
  String? _hasIcuOrHdu;

  @override
  void dispose() {
    _assessmentNameController.dispose(); // <-- Dispose del nuovo campo
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

  void _submitForm() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    final layoutData = FacilityDataFactory.getLayout(
        widget.emergencyType, widget.facilityType);
    layoutData.dateCreated = DateTime.now();

    // Assegniamo il titolo personalizzato (o uno di default se lo lasciano vuoto)
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
      ..facilityName = _facilityNameController
          .text // Questo rimane il nome reale della struttura
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

    final generatedId =
        await DatabaseService.instance.saveAssessment(layoutData);

    if (mounted) Navigator.pop(context);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InteractiveMapScreen(
            emergencyType: widget.emergencyType,
            facilityType: widget.facilityType,
            assessmentId: generatedId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Facility Configuration",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF003D73))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF003D73)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Step ${_currentStep + 1} of $_totalSteps",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold)),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5))
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _prevStep,
                      child: const Text("Back",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                else
                  const Spacer(),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: _nextStep,
                    child: Text(
                        _currentStep == _totalSteps - 1
                            ? "Start Assessment"
                            : "Next",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return _buildPageWrapper(
      formKey: _formKeys[0],
      title: "Assessment Information",
      icon: Icons.person_pin,
      children: [
        _buildInfoBanner(
            "Please enter a title to easily identify this assessment later, along with the assessor details."),

        // --- IL NUOVO CAMPO TITOLO ISPEZIONE ---
        _buildQuestionField("Assessment Title (e.g. Hospital North - Baseline)",
            _buildTextInput(_assessmentNameController, Icons.title)),

        _buildQuestionField(
          "Date of assessment",
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                  context: context,
                  initialDate: _assessmentDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030));
              if (date != null) setState(() => _assessmentDate = date);
            },
            child: InputDecorator(
              decoration: _inputDecoration(Icons.calendar_today),
              child: Text(
                  _assessmentDate != null
                      ? DateFormat('dd/MM/yyyy').format(_assessmentDate!)
                      : "Select Date",
                  style: const TextStyle(fontSize: 15)),
            ),
          ),
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
                    TextFormField(
                      controller: _icuBedsController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(Icons.bed),
                      validator: (value) => null,
                    )),
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

  Widget _buildPageWrapper(
      {required GlobalKey<FormState> formKey,
      required String title,
      required IconData icon,
      required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon,
                        size: 32, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(title,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.primary))),
                  ],
                ),
                const SizedBox(height: 32),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionField(String question, Widget inputField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B))),
          const SizedBox(height: 10),
          inputField,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade400),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      errorStyle: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoBanner(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade100)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.blue, height: 1.4))),
        ],
      ),
    );
  }

  Widget _buildTextInput(TextEditingController controller, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(icon),
      validator: (value) => null,
    );
  }

  Widget _buildNumberInput(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration(Icons.numbers),
      validator: (value) => null,
    );
  }

  Widget _buildDropdown(List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: _inputDecoration(Icons.arrow_drop_down_circle_outlined),
      items: items
          .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e,
                  style: const TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis)))
          .toList(),
      validator: (value) => null,
      onChanged: onChanged,
    );
  }
}
