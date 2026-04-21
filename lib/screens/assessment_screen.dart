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

  // Variabili per il Carosello (Solo per il General Assessment)
  TabController? _tabController;
  List<String> _sectionNames = [];
  Map<String, List<AssessmentQuestion>> _groupedQuestions = {};

  // Questo controlla se stiamo guardando la "bolla fantasma" o una bolla normale
  bool get isGeneralAssessment =>
      widget.zone.id == 'general_facility_assessment';

  @override
  void initState() {
    super.initState();

    // Selezioniamo l'interfaccia a Tabs SOLO se è il General Assessment
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

  // --- MOTORE DI RAGGRUPPAMENTO (Solo per General Assessment) ---
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

  // Aggiorna lo stato della risposta
  void _updateAnswer(AssessmentQuestion question, ComplianceLevel level) {
    setState(() {
      if (question.selectedCompliance == level) {
        question.selectedCompliance = ComplianceLevel.pending;
      } else {
        question.selectedCompliance = level;
      }
    });
  }

  // --- LOGICA AGGIUNTA NOTA ---
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

    if (result != null) {
      setState(() {
        question.note = result.trim().isEmpty ? null : result.trim();
      });
    }
  }

  // --- LOGICA FOTOCAMERA ---
  Future<void> _takePhoto(AssessmentQuestion question) async {
    try {
      final XFile? photo =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (photo != null) {
        setState(() {
          question.mediaPath = photo.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error taking photo: $e"),
            backgroundColor: Colors.red),
      );
    }
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
        // Mostra il menu a scorrimento SOLO se è l'ispezione generale
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
          // ==========================================
          // HEADER DINAMICO (Cambia in base alla modalità)
          // ==========================================
          if (isGeneralAssessment) ...[
            // HEADER PRO (Per il General Assessment)
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
            // HEADER CLASSICO (Per le bolle normali della mappa)
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
                          .withOpacity(0.1),
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

          // ==========================================
          // CORPO DELLA PAGINA (Tabs o Singola Lista)
          // ==========================================
          Expanded(
            child: isGeneralAssessment && _tabController != null
                ? TabBarView(
                    // VISTA A CAROSELLO (Per il General Assessment)
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
                    // VISTA STANDARD (Per le bolle normali)
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

            // NOTA SALVATA
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

            // FOTO SALVATA
            if (question.mediaPath != null) ...[
              const SizedBox(height: 12),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.network(question.mediaPath!,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover)
                        : Image.file(File(question.mediaPath!),
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => question.mediaPath = null),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(Icons.delete,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _takePhoto(question),
                  icon: const Icon(Icons.camera_alt_outlined, size: 20),
                  label: Text(question.mediaPath == null
                      ? "Add Photo"
                      : "Retake Photo"),
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
                        color: color.withOpacity(0.3),
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
