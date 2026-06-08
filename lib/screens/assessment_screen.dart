import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../models/assessment_models.dart';
import '../l10n/app_localizations.dart';

class AssessmentScreen extends StatefulWidget {
  final SpatialZone zone;

  const AssessmentScreen({super.key, required this.zone});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with SingleTickerProviderStateMixin {
  // STATE & DEPENDENCIES
  final ImagePicker _picker = ImagePicker();
  TabController? _tabController;
  List<String> _sectionNames = [];
  Map<String, List<AssessmentQuestion>> _groupedQuestions = {};

  bool get _isGeneralAssessment =>
      widget.zone.id == 'general_facility_assessment';

  @override
  void initState() {
    super.initState();
    if (_isGeneralAssessment) {
      _initializeGeneralAssessmentTabs();
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // DATA MAPPING
  // Segregates questions into distinct functional tabs for general assessments.
  // Routing is based on specific ID prefixes inherited from the database schema.
  void _initializeGeneralAssessmentTabs() {
    _groupedQuestions = {
      'Accesses & Flows': [],
      'Systems & Finishing': [],
      'Waste Management': [],
      'Water & Sanitation': []
    };

    for (final q in widget.zone.checklist) {
      if (q.id.startsWith('gen_2_1')) {
        _groupedQuestions['Accesses & Flows']!.add(q);
      } else if (q.id.startsWith('gen_2_2')) {
        _groupedQuestions['Systems & Finishing']!.add(q);
      } else if (q.id.startsWith('gen_2_3')) {
        _groupedQuestions['Waste Management']!.add(q);
      } else if (q.id.startsWith('gen_2_4')) {
        _groupedQuestions['Water & Sanitation']!.add(q);
      }
    }

    _sectionNames = _groupedQuestions.keys.toList();
    _tabController = TabController(length: _sectionNames.length, vsync: this);
  }

  void _updateCompliance(AssessmentQuestion question, ComplianceLevel level) {
    setState(() {
      question.selectedCompliance = (question.selectedCompliance == level)
          ? ComplianceLevel.pending
          : level;
    });
  }

  // MEDIA & INPUT HANDLING
  Future<void> _showNoteDialog(AssessmentQuestion question) async {
    final noteController = TextEditingController(text: question.note);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)!.addNote,
          style:
              const TextStyle(color: Color(0xFF003D73), fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: noteController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enterObservations,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(AppLocalizations.of(context)!.cancel,
                style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005DA8),
              foregroundColor: Colors.white,
            ),
            onPressed: () => context.pop(noteController.text),
            child: Text(AppLocalizations.of(context)!.saveNote),
          ),
        ],
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      question.note = result.trim().isEmpty ? null : result.trim();
    });
  }

  void _showMediaPickerSheet(AssessmentQuestion question) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF005DA8)),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.of(context).pop();
                _captureMedia(question, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: Color(0xFF005DA8), size: 24),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _captureMedia(question, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureMedia(
      AssessmentQuestion question, ImageSource source) async {
    try {
      final XFile? photo =
          await _picker.pickImage(source: source, imageQuality: 80);

      if (!mounted || photo == null) return;

      setState(() {
        question.mediaPaths ??= [];
        question.mediaPaths!.add(photo.path);
      });
    } catch (e) {
      if (!mounted) return;

      final errorStr = e.toString().toLowerCase();
      final isPermissionError = errorStr.contains('permission') ||
          errorStr.contains('denied') ||
          errorStr.contains('photo_access_denied') ||
          errorStr.contains('camera_access_denied');

      if (isPermissionError) {
        _showPermissionDeniedDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.errorPickingImage +
                  e.toString()),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.linked_camera_outlined,
                      size: 40, color: Colors.amber.shade800),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.cameraAccessRequired,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.cameraAccessMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey.shade600, height: 1.4),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  key: const Key('btn_close_permission_dialog'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005DA8),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.understood,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openFullScreenViewer(String path) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: kIsWeb || path.startsWith('http')
                  ? Image.network(path, fit: BoxFit.contain)
                  : Image.file(File(path), fit: BoxFit.contain),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MAIN UI BUILDER
  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color(0xFF0F172A), size: 24),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.zone.name,
          style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.5),
          overflow: TextOverflow.ellipsis,
        ),
        bottom: _isGeneralAssessment && _tabController != null
            ? TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: const Color(0xFF005DA8),
                indicatorWeight: 4,
                labelColor: const Color(0xFF005DA8),
                unselectedLabelColor: Colors.grey.shade500,
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w800, fontSize: isTablet ? 16 : 13),
                unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: isTablet ? 16 : 13),
                tabs: _sectionNames.map((name) => Tab(text: name)).toList(),
              )
            : null,
      ),
      // ADAPTIVE LAYOUT
      // Implements a soft constraint of 1200px to prevent visual distortion on ultrawide desktop monitors,
      // while allowing full utilization of tablet screen real estate.
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildProgressHeader(),
            Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  )
                ],
              ),
            ),
            Expanded(
              child: _isGeneralAssessment && _tabController != null
                  ? TabBarView(
                      controller: _tabController,
                      children: _sectionNames.map((section) {
                        final questions = _groupedQuestions[section]!;
                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1200),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: questions.length,
                              itemBuilder: (context, index) =>
                                  _buildQuestionCard(questions[index]),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: widget.zone.checklist.length,
                          itemBuilder: (context, index) =>
                              _buildQuestionCard(widget.zone.checklist[index]),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ADAPTIVE HEADER COMPONENT
  Widget _buildProgressHeader() {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    final bool isMobilePortrait = !isTablet && !isLandscape;

    if (_isGeneralAssessment) {
      return Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isLandscape ? 8 : 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Layout adjustment for landscape orientation to optimize vertical space
                isLandscape
                    ? Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: widget.zone.completionPercentage / 100,
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF005DA8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "${widget.zone.completionPercentage.toStringAsFixed(0)}%",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF005DA8)),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.overallCompletion,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A)),
                              ),
                              Text(
                                "${widget.zone.completionPercentage.toStringAsFixed(0)}%",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF005DA8)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: widget.zone.completionPercentage / 100,
                              minHeight: 12,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF005DA8)),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      );
    }

    final String titleText = isMobilePortrait
        ? AppLocalizations.of(context)!.areaChecklist
        : AppLocalizations.of(context)!.areaAssessmentChecklist;
    final double titleFontSize = isMobilePortrait ? 18 : 20;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              titleText,
              style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppLocalizations.of(context)!.completedPct(
                  widget.zone.completionPercentage.toStringAsFixed(0)),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  // QUESTION CARD WIDGET
  // Handles the rendering of individual checklist elements.
  // Leverages intrinsic height and responsive typographies depending on device width and orientation.
  Widget _buildQuestionCard(AssessmentQuestion question) {
    final requiresRecommendation =
        question.selectedCompliance == ComplianceLevel.doesNotMeet ||
            question.selectedCompliance == ComplianceLevel.partiallyMeets;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final bool isTablet = MediaQuery.of(context).size.width >= 800;

    final double questionFontSize =
        (isTablet && isPortrait) ? 20.0 : (isTablet ? 17.0 : 15.0);

    final complianceRow = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildComplianceSelector(
            question: question,
            level: ComplianceLevel.meetsTarget,
            label: AppLocalizations.of(context)!.meetsTarget,
            color: Colors.green.shade600,
            icon: Icons.check_circle,
            isTablet: isTablet,
          ),
          const SizedBox(width: 12),
          _buildComplianceSelector(
            question: question,
            level: ComplianceLevel.partiallyMeets,
            label: AppLocalizations.of(context)!.partiallyMeets,
            color: Colors.orange.shade500,
            icon: Icons.warning_amber_rounded,
            isTablet: isTablet,
          ),
          const SizedBox(width: 12),
          _buildComplianceSelector(
            question: question,
            level: ComplianceLevel.doesNotMeet,
            label: AppLocalizations.of(context)!.doesNotMeet,
            color: Colors.red.shade600,
            icon: Icons.error_outline,
            isTablet: isTablet,
          ),
        ],
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 40 : 20,
        vertical: isTablet ? 32 : 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          left: question.isCriticalFailure
              ? BorderSide(color: Colors.red.shade400, width: 4)
              : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic structural layout adapting to screen aspect ratio
          if (isLandscape && isTablet)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 48.0, top: 4.0),
                    child: _buildRichQuestionText(
                        question.text, questionFontSize, isTablet),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: complianceRow,
                ),
              ],
            )
          else ...[
            _buildRichQuestionText(question.text, questionFontSize, isTablet),
            const SizedBox(height: 24),
            complianceRow,
          ],
          if (requiresRecommendation)
            _buildRecommendationBlock(question, isTablet),
          if (question.note != null && question.note!.isNotEmpty)
            _buildNoteBlock(question, isTablet),
          if (question.mediaPaths != null && question.mediaPaths!.isNotEmpty)
            _buildMediaGallery(question),
          const SizedBox(height: 24),
          Align(
            alignment:
                isLandscape ? Alignment.centerLeft : Alignment.centerRight,
            child: Wrap(
              alignment: isLandscape ? WrapAlignment.start : WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                TextButton.icon(
                  onPressed: () => _showMediaPickerSheet(question),
                  icon: const Icon(Icons.add_a_photo_outlined, size: 22),
                  label: Text(AppLocalizations.of(context)!.addPhoto,
                      style: TextStyle(fontSize: isTablet ? 15 : 14)),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12)),
                ),
                TextButton.icon(
                  onPressed: () => _showNoteDialog(question),
                  icon: const Icon(Icons.edit_note, size: 22),
                  label: Text(
                      question.note == null
                          ? AppLocalizations.of(context)!.addNote
                          : "Edit Note",
                      style: TextStyle(fontSize: isTablet ? 15 : 14)),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildComplianceSelector({
    required AssessmentQuestion question,
    required ComplianceLevel level,
    required String label,
    required Color color,
    required IconData icon,
    bool isTablet = false,
  }) {
    final isSelected = question.selectedCompliance == level;
    final criteriaText = globalComplianceCriteria[question.id]?[level];

    return Expanded(
      child: GestureDetector(
        onTap: () => _updateCompliance(question, level),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            border: Border.all(
                color: isSelected ? color : Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3))
                  ]
                : [],
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: isTablet ? 16 : 12, horizontal: 8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon,
                          color: isSelected ? Colors.white : color,
                          size: isTablet ? 28 : 24),
                      const SizedBox(height: 8),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 13 : 11,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (criteriaText != null)
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () => _showCriteriaDialog(
                        label.split('\n')[0], criteriaText, color),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.info_outline,
                          size: isTablet ? 20 : 16,
                          color: isSelected
                              ? Colors.white70
                              : Colors.grey.shade400),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCriteriaDialog(String title, String criteria, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        titlePadding: const EdgeInsets.only(left: 24, right: 24, top: 24),
        title: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: color, size: 28),
            const SizedBox(width: 12),
            Text(title,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w900, fontSize: 20)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.evaluationCriteria,
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
            const SizedBox(height: 12),
            Text(criteria,
                style: const TextStyle(
                    fontSize: 16, height: 1.5, color: Color(0xFF0F172A))),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () => context.pop(),
            child: Text(AppLocalizations.of(context)!.gotIt,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationBlock(AssessmentQuestion question, bool isTablet) {
    final isCritical = question.isCriticalFailure;
    final baseColor = isCritical ? Colors.red : Colors.orange;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: isCritical ? Colors.red.shade50 : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: baseColor, width: 4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb, color: baseColor, size: isTablet ? 28 : 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.howToImprove,
                    style: TextStyle(
                      fontSize: isTablet ? 13 : 12,
                      fontWeight: FontWeight.bold,
                      color: isCritical
                          ? Colors.red.shade800
                          : Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    question.recommendationText,
                    style: TextStyle(
                        fontSize: (isTablet && isPortrait)
                            ? 17.0
                            : (isTablet ? 15.0 : 13.0),
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteBlock(AssessmentQuestion question, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.edit_note,
                color: Colors.blue.shade700, size: isTablet ? 24 : 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                question.note!,
                style: TextStyle(
                    fontSize: isTablet ? 15 : 14,
                    color: Colors.blue.shade900,
                    fontStyle: FontStyle.italic),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => question.note = null),
              child: const Icon(Icons.close, color: Colors.grey, size: 20),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMediaGallery(AssessmentQuestion question) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: question.mediaPaths!.length,
          itemBuilder: (context, index) {
            final path = question.mediaPaths![index];
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => _openFullScreenViewer(path),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb || path.startsWith('http')
                          ? Image.network(path,
                              height: 100, width: 100, fit: BoxFit.cover)
                          : Image.file(File(path),
                              height: 100, width: 100, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          question.mediaPaths!.removeAt(index);
                          if (question.mediaPaths!.isEmpty) {
                            question.mediaPaths = null;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRichQuestionText(String text, double fontSize, bool isTablet) {
    final parts = text.split('\n\n');
    if (parts.length > 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            parts[0].toUpperCase(),
            style: TextStyle(
              fontSize: fontSize * 0.75,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF005DA8),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            parts[1],
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              height: 1.4,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      );
    }
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        height: 1.4,
        color: const Color(0xFF0F172A),
      ),
    );
  }
}
