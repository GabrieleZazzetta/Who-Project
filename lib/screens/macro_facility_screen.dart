import 'package:flutter/material.dart';
import '../models/assessment_models.dart';
import '../data/mock_data.dart';
import 'micro_bubble_screen.dart';


class MacroFacilityScreen extends StatelessWidget {
  // Carichiamo i dati specifici per la Fig. 4 (Existing Facility)
  final List<MacroArea> areas = MockData.getMpoxExistingFacilityStructure();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mpox Ward Layout (Fig. 4)"),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Intestazione
            Text(
              "Select an Area to Assess",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Click on a zone to view detailed functional areas (bubbles).",
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            
            // Lista delle Macro Aree (I Box Rettangolari)
            Expanded(
              child: ListView.builder(
                itemCount: areas.length,
                itemBuilder: (context, index) {
                  final area = areas[index];
                  return _buildMacroAreaCard(context, area);
                },
              ),
            ),
            
            // Bottone "How to improve design" (Richiesto da specifica)
            SafeArea(
              child: ElevatedButton.icon(
                icon: Icon(Icons.lightbulb_outline),
                label: Text("How to improve your design"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Qui mostreremo i PDF o i consigli generali
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Opening Design Guidelines..."))
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroAreaCard(BuildContext context, MacroArea area) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // COLLEGAMENTO ALLA SCHERMATA A BOLLE
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => MicroBubbleScreen(area: area)
            )
          );
        },
        child: Container(
          height: 100, // Altezza fissa per dare l'idea di "blocco"
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.blue.shade800, width: 6)),
          ),
          child: Row(
            children: [
              // Icona generica in base all'area (opzionale, per ora fissa)
              Icon(Icons.domain, size: 40, color: Colors.blue[800]),
              SizedBox(width: 20),
              // Testi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      area.name, // Es. "Entry & Screening Zone"
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${area.subAreas.length} functional units", // Es. "2 functional units"
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}