import 'package:flutter/material.dart';

class AssessmentsListScreen extends StatelessWidget {
  const AssessmentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("My Assessments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Search coming soon")));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sezione: IN CORSO
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 12),
            child: Text("IN PROGRESS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          ),
          _buildAssessmentCard(
            context: context,
            facilityName: "Central City Hospital",
            type: "Existing Facility (Mpox Ward)",
            date: "Today, 10:30 AM",
            score: 45,
            status: "Incomplete",
            statusColor: Colors.orange,
            icon: Icons.local_hospital,
          ),
          
          const SizedBox(height: 24),
          
          // Sezione: COMPLETATI
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 12),
            child: Text("COMPLETED", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          ),
          _buildAssessmentCard(
            context: context,
            facilityName: "Camp Alpha - Sector B",
            type: "Congregate Setting",
            date: "Oct 12, 2023",
            score: 85,
            status: "Passed",
            statusColor: Colors.green,
            icon: Icons.house_siding,
          ),
          const SizedBox(height: 12),
          _buildAssessmentCard(
            context: context,
            facilityName: "Regional Clinic South",
            type: "Screening & Triage",
            date: "Oct 10, 2023",
            score: 32,
            status: "Critical Fails",
            statusColor: Colors.red,
            icon: Icons.health_and_safety,
          ),
        ],
      ),
      // Pulsante per avviare un nuovo assessment
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // In un'app reale, questo riporterebbe alla tab Home
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Go to Home tab to start a new assessment")));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Costruttore della singola Card di Assessment
  Widget _buildAssessmentCard({
    required BuildContext context, required String facilityName, required String type,
    required String date, required int score, required String status,
    required Color statusColor, required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Opening $facilityName...")));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(10)),
                      child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(facilityName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(type, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        ],
                      ),
                    ),
                    // Score Circle
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: statusColor.withOpacity(0.5), width: 2),
                      ),
                      child: Text(
                        "$score%",
                        style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Text(date, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text(status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}