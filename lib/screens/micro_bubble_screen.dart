import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/assessment_models.dart'; 
import '../screens/assessment_screen.dart';

class MicroBubbleScreen extends StatelessWidget {
  final MacroArea area;

  const MicroBubbleScreen({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(area.name),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          // Intestazione descrittiva
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            width: double.infinity,
            child: Text(
              "Select a functional unit (bubble) to start the assessment based on WHO metrics.",
              style: TextStyle(fontSize: 16, color: Colors.blue[900]),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Griglia delle Bolle
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 bolle per riga (puoi metterne 3 se vuoi)
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.0, // Le rende quadrate (cerchi perfetti)
              ),
              itemCount: area.subAreas.length,
              itemBuilder: (context, index) {
                final subArea = area.subAreas[index];
                return _buildBubble(context, subArea);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(BuildContext context, MicroArea subArea) {
    return InkWell(
      onTap: () {
        // NAVIGAZIONE AL FORM DI VALUTAZIONE
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssessmentScreen(microArea: subArea),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blue.shade300, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icona (cambia colore se è già stato valutato, logica futura)
            Icon(Icons.meeting_room_outlined, size: 40, color: Colors.blue[800]),
            const SizedBox(height: 10),
            // Nome della bolla
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                subArea.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}