import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assessment_models.dart';
import '../services/database_service.dart';
import 'interactive_map_screen.dart';

class AssessmentsListScreen extends StatefulWidget {
  const AssessmentsListScreen({super.key});

  @override
  State<AssessmentsListScreen> createState() => _AssessmentsListScreenState();
}

class _AssessmentsListScreenState extends State<AssessmentsListScreen> {
  bool _isLoading = true;
  List<FacilityLayout> _allAssessments = [];
  List<FacilityLayout> _filteredAssessments = [];
  
  String _currentFilter = 'All'; // Filtri: All, Incomplete, Passed, Critical Fails
  DateTime? _filterDate;

  @override
  void initState() {
    super.initState();
    _loadAssessments();
  }

  // Carica i dati veri dal Database
  Future<void> _loadAssessments() async {
    setState(() => _isLoading = true);
    final data = await DatabaseService.instance.getAllAssessments();
    
    // Ordina dalla più recente alla più vecchia
    data.sort((a, b) => b.dateCreated?.compareTo(a.dateCreated ?? DateTime.now()) ?? 0);
    
    setState(() {
      _allAssessments = data;
      _isLoading = false;
    });
    _applyFilters();
  }

  // --- IL CERVELLO DELLA VALUTAZIONE (Algoritmo Preciso PRO) ---
  String _getAssessmentStatus(FacilityLayout facility) {
    int totalQuestions = 0;
    int answeredQuestions = 0;
    bool hasCritical = false;

    for (var zone in facility.zones) {
      totalQuestions += zone.checklist.length;
      for (var q in zone.checklist) {
        if (q.selectedCompliance != ComplianceLevel.pending) {
          answeredQuestions++;
        }
        if (q.isCriticalFailure) {
          hasCritical = true;
        }
      }
    }

    double completionPct = totalQuestions == 0 ? 0 : (answeredQuestions / totalQuestions) * 100;

    if (hasCritical) return 'Critical Fails';
    if (completionPct < 100) return 'Incomplete';
    return 'Passed';
  }

  // Applica i filtri grafici in memoria usando l'algoritmo esatto
  void _applyFilters() {
    List<FacilityLayout> temp = List.from(_allAssessments);

    // 1. Filtro di Stato
    if (_currentFilter != 'All') {
      temp = temp.where((f) => _getAssessmentStatus(f) == _currentFilter).toList();
    }

    // 2. Filtro per Data
    if (_filterDate != null) {
      temp = temp.where((f) => 
        f.dateCreated!.year == _filterDate!.year && 
        f.dateCreated!.month == _filterDate!.month && 
        f.dateCreated!.day == _filterDate!.day
      ).toList();
    }

    setState(() {
      _filteredAssessments = temp;
    });
  }

  // Funzione per eliminare con Dialog di conferma (Funzione PRO)
  Future<void> _confirmDelete(FacilityLayout facility) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Delete Assessment", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003D73))),
        content: const Text("Are you sure you want to permanently delete this assessment? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseService.instance.deleteAssessment(facility.id);
      _loadAssessments(); // Ricarica la lista
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Assessment deleted successfully."), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        title: const Text("Saved Assessments", style: TextStyle(color: Color(0xFF003D73), fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // 1. ZONA FILTRI
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Incomplete'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Passed'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Critical Fails'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _filterDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _filterDate = picked);
                          _applyFilters();
                        }
                      },
                      icon: const Icon(Icons.date_range, size: 20),
                      label: Text(_filterDate == null ? "Filter by Date" : DateFormat('dd MMM yyyy').format(_filterDate!)),
                      style: TextButton.styleFrom(foregroundColor: const Color(0xFF005DA8)),
                    ),
                    if (_filterDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() => _filterDate = null);
                          _applyFilters();
                        },
                      )
                  ],
                ),
              ],
            ),
          ),
          
          // 2. LISTA DELLE CARD
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _filteredAssessments.isEmpty
                ? const Center(child: Text("No assessments found.", style: TextStyle(color: Colors.grey, fontSize: 16)))
                : RefreshIndicator(
                    onRefresh: _loadAssessments,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredAssessments.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _buildAssessmentCard(_filteredAssessments[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Costruisce la Card Istituzionale "PRO" (con Cerchio e Cestino)
  Widget _buildAssessmentCard(FacilityLayout facility) {
    // 1. Calcoliamo la percentuale esatta
    int totalQuestions = 0;
    int answeredQuestions = 0;
    int criticalFailsCount = 0;

    for (var zone in facility.zones) {
      totalQuestions += zone.checklist.length;
      for (var q in zone.checklist) {
        if (q.selectedCompliance != ComplianceLevel.pending) answeredQuestions++;
        if (q.isCriticalFailure) criticalFailsCount++;
      }
    }
    double completionPct = totalQuestions == 0 ? 0 : (answeredQuestions / totalQuestions) * 100;

    // 2. Otteniamo lo stato e i colori
    String stateLabel = _getAssessmentStatus(facility);
    Color stateColor;
    if (stateLabel == 'Critical Fails') {
      stateColor = Colors.red.shade600;
    } else if (stateLabel == 'Passed') {
      stateColor = Colors.green.shade600;
    } else {
      stateColor = Colors.orange.shade500;
    }

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: stateColor.withOpacity(0.5), width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          // RIAPRI L'ISPEZIONE (Aggiornato con la navigazione della Factory)
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InteractiveMapScreen(
                emergencyType: facility.emergencyType, 
                facilityType: FacilityType.existingFacilityWithWard, 
                assessmentId: facility.id, 
              ),
            ),
          );
          _loadAssessments(); // Ricarica al ritorno
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ROW (Titolo, Badge e Cestino)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facility.facilityName.isEmpty ? "Unnamed Facility" : facility.facilityName, 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${facility.emergencyType.name.toUpperCase()} Assessment • ${DateFormat('dd MMM yyyy').format(facility.dateCreated ?? DateTime.now())}",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: stateColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                    child: Text(stateLabel.toUpperCase(), style: TextStyle(color: stateColor, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 0.5)),
                  ),
                  const SizedBox(width: 8),
                  // IL PULSANTE ELIMINA
                  GestureDetector(
                    onTap: () => _confirmDelete(facility),
                    child: Icon(Icons.delete_outline, color: Colors.red.shade300, size: 26),
                  ),
                ],
              ),
              
              Divider(color: Colors.grey.shade200, height: 32),
              
              // STATS ROW (Le 3 colonne)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 1. Progress Circle
                  Column(
                    children: [
                      Text("Progress", style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: completionPct / 100,
                              strokeWidth: 4,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(stateColor),
                            ),
                            Center(
                              child: Text(
                                "${completionPct.toInt()}%",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: stateColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // 2. Global Readiness
                  Column(
                    children: [
                      Text("Readiness", style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("${facility.globalReadinessScore.toStringAsFixed(0)}%", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  
                  // 3. Critical Fails
                  Column(
                    children: [
                      Text("Critical Fails", style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(criticalFailsCount.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: criticalFailsCount > 0 ? Colors.red.shade600 : Colors.green.shade600)),
                    ],
                  ),
                  
                  // 4. Continua Icona
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey.shade300, size: 24),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Costruisce la grafica delle "Capsule" per i filtri
  Widget _buildFilterChip(String label) {
    bool isSelected = _currentFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() => _currentFilter = label);
        _applyFilters();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF005DA8) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? const Color(0xFF005DA8) : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}