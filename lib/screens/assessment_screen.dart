import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/assessment_models.dart';

class AssessmentScreen extends StatefulWidget {
  final SpatialZone zone;

  const AssessmentScreen({super.key, required this.zone});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();

  TabController? _tabController;
  List<String> _sectionNames = [];
  Map<String, List<AssessmentQuestion>> _groupedQuestions = {};

  bool get isGeneralAssessment =>
      widget.zone.id == 'general_facility_assessment';

  @override
  void initState() {
    super.initState();
    if (isGeneralAssessment) {
      _groupQuestionsForGeneral();
      _tabController = TabController(length: _sectionNames.length, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _groupQuestionsForGeneral() {
    _groupedQuestions = {
      'Accesses & Flows': [],
      'Systems & Finishing': [],
      'Waste Management': [],
      'Water & Sanitation': []
    };

    for (var q in widget.zone.checklist) {
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
  }

  void _updateAnswer(AssessmentQuestion question, ComplianceLevel level) {
    setState(() {
      if (question.selectedCompliance == level) {
        question.selectedCompliance = ComplianceLevel.pending;
      } else {
        question.selectedCompliance = level;
      }
    });
  }

  Future<void> _addNoteDialog(AssessmentQuestion question) async {
    TextEditingController noteController =
        TextEditingController(text: question.note);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Add Note",
            style: TextStyle(
                color: Color(0xFF003D73), fontWeight: FontWeight.bold)),
        content: TextField(
          controller: noteController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Enter your observations here...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005DA8),
                foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, noteController.text),
            child: const Text("Save Note"),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        question.note = result.trim().isEmpty ? null : result.trim();
      });
    }
  }

  void _showPhotoMenu(BuildContext context, AssessmentQuestion question) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF005DA8)),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(question, ImageSource.camera);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: Color(0xFF005DA8)),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(question, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(
      AssessmentQuestion question, ImageSource source) async {
    try {
      final XFile? photo =
          await _picker.pickImage(source: source, imageQuality: 80);
      
      if (!mounted) return;

      if (photo != null) {
        setState(() {
          question.mediaPaths ??= [];
          question.mediaPaths!.add(photo.path);
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error picking image: $e"),
            backgroundColor: Colors.red),
      );
    }
  }

  // --- NUOVA LOGICA: VISUALIZZATORE A SCHERMO INTERO CON ZOOM ---
  void _showFullScreenImage(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(
              10), // Leggero margine dai bordi del telefono
          child: Stack(
            alignment: Alignment.center,
            children: [
              // InteractiveViewer permette il "Pinch to Zoom" (zoom con le due dita)
              InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: kIsWeb
                    ? Image.network(path, fit: BoxFit.contain)
                    : Image.file(File(path), fit: BoxFit.contain),
              ),
              // Bottone di chiusura in alto a destra
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
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.zone.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        bottom: isGeneralAssessment && _tabController != null
            ? TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: const Color(0xFF005DA8),
                indicatorWeight: 3,
                labelColor: const Color(0xFF005DA8),
                unselectedLabelColor: Colors.grey.shade500,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: _sectionNames.map((name) => Tab(text: name)).toList(),
              )
            : null,
      ),
      body: Column(
        children: [
          if (isGeneralAssessment) ...[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Overall Completion",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                      Text(
                        "${widget.zone.completionPercentage.toStringAsFixed(0)}%",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF005DA8)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: widget.zone.completionPercentage / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF005DA8)),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade200),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Area Assessment Checklist",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${widget.zone.completionPercentage.toStringAsFixed(0)}% Completed",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
          Expanded(
            child: isGeneralAssessment && _tabController != null
                ? TabBarView(
                    controller: _tabController,
                    children: _sectionNames.map((section) {
                      final questionsInSection = _groupedQuestions[section]!;
                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: questionsInSection.length,
                        itemBuilder: (context, index) {
                          return _buildQuestionCard(questionsInSection[index]);
                        },
                      );
                    }).toList(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: widget.zone.checklist.length,
                    itemBuilder: (context, index) {
                      return _buildQuestionCard(widget.zone.checklist[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(AssessmentQuestion question) {
    bool showRecommendation =
        question.selectedCompliance == ComplianceLevel.doesNotMeet ||
            question.selectedCompliance == ComplianceLevel.partiallyMeets;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: question.isCriticalFailure
              ? Colors.red.shade300
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildComplianceButton(
                  question: question,
                  level: ComplianceLevel.meetsTarget,
                  label: "Meets Target\n(3 pts)",
                  color: Colors.green.shade600,
                  icon: Icons.check_circle,
                ),
                const SizedBox(width: 8),
                _buildComplianceButton(
                  question: question,
                  level: ComplianceLevel.partiallyMeets,
                  label: "Partial\n(2 pts)",
                  color: Colors.orange.shade500,
                  icon: Icons.warning_amber_rounded,
                ),
                const SizedBox(width: 8),
                _buildComplianceButton(
                  question: question,
                  level: ComplianceLevel.doesNotMeet,
                  label: "Does Not Meet\n(1 pt)",
                  color: Colors.red.shade600,
                  icon: Icons.error_outline,
                ),
              ],
            ),
            if (showRecommendation) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: question.isCriticalFailure
                      ? Colors.red.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                      left: BorderSide(
                          color: question.isCriticalFailure
                              ? Colors.red
                              : Colors.orange,
                          width: 4)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb,
                        color: question.isCriticalFailure
                            ? Colors.red
                            : Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "HOW TO IMPROVE YOUR DESIGN",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: question.isCriticalFailure
                                  ? Colors.red.shade800
                                  : Colors.orange.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            question.recommendationText,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (question.note != null && question.note!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.edit_note,
                        color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(question.note!,
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontStyle: FontStyle.italic)),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => question.note = null),
                      child:
                          const Icon(Icons.close, color: Colors.grey, size: 18),
                    )
                  ],
                ),
              ),
            ],
            if (question.mediaPaths != null &&
                question.mediaPaths!.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: question.mediaPaths!.length,
                  itemBuilder: (context, imgIndex) {
                    final path = question.mediaPaths![imgIndex];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Stack(
                        children: [
                          // --- AGGIUNTO IL GESTURE DETECTOR SULLA MINIATURA ---
                          GestureDetector(
                            onTap: () => _showFullScreenImage(context, path),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: kIsWeb
                                  ? Image.network(path,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover)
                                  : Image.file(File(path),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  question.mediaPaths!.removeAt(imgIndex);
                                  if (question.mediaPaths!.isEmpty) {
                                    question.mediaPaths = null;
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle),
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
            ],
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showPhotoMenu(context, question),
                  icon: const Icon(Icons.add_a_photo_outlined, size: 20),
                  label: const Text("Add Photo"),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700),
                ),
                TextButton.icon(
                  onPressed: () => _addNoteDialog(question),
                  icon: const Icon(Icons.edit_note, size: 20),
                  label: Text(question.note == null ? "Add Note" : "Edit Note"),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceButton({
    required AssessmentQuestion question,
    required ComplianceLevel level,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    bool isSelected = question.selectedCompliance == level;

    return Expanded(
      child: GestureDetector(
        onTap: () => _updateAnswer(question, level),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            border: Border.all(
                color: isSelected ? color : Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3))
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
