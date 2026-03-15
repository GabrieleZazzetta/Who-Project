import 'package:flutter/material.dart';
import '../models/assessment_models.dart';

class AssessmentScreen extends StatefulWidget {
  final SpatialZone zone;

  const AssessmentScreen({super.key, required this.zone});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  // Funzione per aggiornare lo stato quando si seleziona una risposta
  void _updateAnswer(AssessmentQuestion question, ComplianceLevel level) {
    setState(() {
      question.selectedCompliance = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        // Niente "leading", così appare la freccia per tornare alla mappa
        title: Row(
          children: [
            Image.asset(
              'assets/images/who_logo.png',
              height: 28,
              fit: BoxFit.contain,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                widget.zone.name, 
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline, size: 28),
            tooltip: 'Save & Return',
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Header con la percentuale di completamento della stanza
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Area Assessment Checklist",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
          
          // Lista delle domande
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.zone.checklist.length,
              itemBuilder: (context, index) {
                final question = widget.zone.checklist[index];
                return _buildQuestionCard(question);
              },
            ),
          ),
        ],
      ),
      // Tasto Flottante per salvare e tornare alla mappa
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigator.pop rimanda alla mappa, la quale chiamerà _refreshMap()
          Navigator.pop(context);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text("Save & Return to Map", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // Widget per la singola domanda
  Widget _buildQuestionCard(AssessmentQuestion question) {
    // Determiniamo se mostrare il suggerimento (se la risposta è "Does Not Meet" o "Partially Meets")
    bool showRecommendation = question.selectedCompliance == ComplianceLevel.doesNotMeet || 
                              question.selectedCompliance == ComplianceLevel.partiallyMeets;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // Se c'è un errore critico, il bordo della card diventa rosso
        side: BorderSide(
          color: question.isCriticalFailure ? Colors.red.shade300 : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Testo della domanda
            Text(
              question.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            
            // Bottoni touch-friendly per le risposte
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

            // LA KILLER FEATURE: Il suggerimento architettonico/clinico dinamico
            if (showRecommendation) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: question.isCriticalFailure ? Colors.red.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(
                      color: question.isCriticalFailure ? Colors.red : Colors.orange, 
                      width: 4
                    )
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb, 
                      color: question.isCriticalFailure ? Colors.red : Colors.orange,
                    ),
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
                              color: question.isCriticalFailure ? Colors.red.shade800 : Colors.orange.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            question.recommendationText,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // Bottoni aggiuntivi (Media e Note)
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Logica futura: Aprire la fotocamera
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Camera module coming soon..."))
                    );
                  },
                  icon: const Icon(Icons.camera_alt_outlined, size: 20),
                  label: const Text("Add Photo"),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey.shade700),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Logica futura: Aggiungere note testuali
                  },
                  icon: const Icon(Icons.edit_note, size: 20),
                  label: const Text("Add Note"),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey.shade700),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Costruisce i singoli bottoni di valutazione
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
              color: isSelected ? color : Colors.grey.shade300,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
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
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}