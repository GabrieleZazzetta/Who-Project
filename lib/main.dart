import 'package:flutter/material.dart';
import 'models/assessment_models.dart';
import 'screens/macro_facility_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WHO Assessment Tool',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const EmergencySelectionScreen(),
    );
  }
}

class EmergencySelectionScreen extends StatelessWidget {
  const EmergencySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WHO Assessment Tool")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select Emergency Context", 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),
            
            // Bottone MPOX
            _buildEmergencyCard(
              context, 
              "Mpox Outbreak", 
              EmergencyType.mpox, 
              Colors.purple
            ),
            
            // Placeholder per altre emergenze
            _buildEmergencyCard(
              context, 
              "Ebola (Coming Soon)", 
              EmergencyType.ebola, 
              Colors.grey
            ),
            _buildEmergencyCard(
              context, 
              "SARS (Coming Soon)", 
              EmergencyType.sars, 
              Colors.grey
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context, String title, EmergencyType type, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        leading: Icon(Icons.warning_amber_rounded, color: color, size: 40),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: type == EmergencyType.mpox 
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacilitySelectionScreen(emergency: type)
                  ),
                );
              }
            : null, // Disabilita il click se non è Mpox
      ),
    );
  }
}

class FacilitySelectionScreen extends StatelessWidget {
  final EmergencyType emergency;

  const FacilitySelectionScreen({super.key, required this.emergency});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Facility Type")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFacilityItem(
            context, 
            "Screening, triage and temporary isolation", 
            "Fig. 2 - Tents/Temporary structures for early detection.",
            FacilityType.screeningAndIsolation
          ),
          _buildFacilityItem(
            context, 
            "Existing health facility with dedicated Mpox ward", 
            "Fig. 4 - Repurposed wing within a hospital.", 
            FacilityType.existingFacilityWithWard // QUESTA APRE LA NUOVA SCHERMATA
          ),
          _buildFacilityItem(
            context, 
            "Mpox stand-alone treatment centre", 
            "Fig. 5 - Large scale temporary treatment center.", 
            FacilityType.standAloneCenter
          ),
          _buildFacilityItem(
            context, 
            "Screening/Isolation in congregate settings", 
            "Fig. 6 - For camps and refugee settings.", 
            FacilityType.congregateSetting
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityItem(BuildContext context, String title, String subtitle, FacilityType type) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: () {
          if (type == FacilityType.existingFacilityWithWard) {
            // Navigazione alla schermata MACRO (i rettangoli)
            Navigator.push(
              context, 
              // CORREZIONE: Ho rimosso "const" qui sotto vvv
              MaterialPageRoute(builder: (context) => MacroFacilityScreen())
            );
          } else {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text("Not implemented yet"))
             );
          }
        },
      ),
    );
  }
}