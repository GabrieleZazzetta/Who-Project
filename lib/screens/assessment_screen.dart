import 'package:flutter/material.dart';
// IMPORTANTE: Usa il nome del tuo pacchetto corretto qui sotto
import '/models/assessment_models.dart';

class AssessmentScreen extends StatefulWidget {
  final MicroArea microArea;

  const AssessmentScreen({super.key, required this.microArea});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.microArea.name),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showDesignPrinciples(context),
          )
        ],
      ),
      body: Column(
        children: [
          // Header informativo
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              children: [
                const Icon(Icons.assignment, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Evaluate the following criteria based on WHO Annex 2 standards.",
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                ),
              ],
            ),
          ),
          
          // Lista delle domande
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.microArea.questions.length,
              itemBuilder: (context, index) {
                final question = widget.microArea.questions[index];
                return _buildQuestionCard(question);
              },
            ),
          ),

          // Bottone di salvataggio
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pop(context); // Torna alle bolle
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Assessment saved locally!")),
                );
              },
              child: const Text("Save Assessment", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuestionCard(AssessmentQuestion question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Codice citazione (es. 4.1.1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                question.citation,
                style: TextStyle(fontSize: 12, color: Colors.grey[800], fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            
            // Testo domanda
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            
            // Opzioni di Punteggio (Score)
            const Text("Score:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreButton(question, 1, "Does not meet", Colors.red[100]!, Colors.red),
                _buildScoreButton(question, 2, "Partial", Colors.orange[100]!, Colors.orange),
                _buildScoreButton(question, 3, "Meets", Colors.green[100]!, Colors.green),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Campo commenti
            TextField(
              decoration: const InputDecoration(
                labelText: "Comments / Observations",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (val) {
                question.comment = val; // Salvataggio "grezzo" nel modello
              },
              controller: TextEditingController(text: question.comment),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper per i bottoni colorati del punteggio
  Widget _buildScoreButton(AssessmentQuestion question, int value, String label, Color bgColors, Color activeColor) {
    bool isSelected = question.score == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          question.score = value;
        });
      },
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              "$value",
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showDesignPrinciples(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Design Principles", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...widget.microArea.designPrinciples.map((e) => ListTile(
                leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                title: Text(e),
              )),
            ],
          ),
        );
      },
    );
  }
}