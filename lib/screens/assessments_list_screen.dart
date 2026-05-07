import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assessment_models.dart';
import '../services/database_service.dart';
import 'interactive_map_screen.dart';
import 'analytics_screen.dart';
import '../services/report_export_service.dart';
import 'global_map_screen_3d.dart';

enum SortOption { newest, scoreHighToLow, scoreLowToHigh }

class AssessmentsListScreen extends StatefulWidget {
  const AssessmentsListScreen({super.key});

  @override
  State<AssessmentsListScreen> createState() => _AssessmentsListScreenState();
}

class _AssessmentsListScreenState extends State<AssessmentsListScreen> {
  // STATO E CONFIGURAZIONE
  bool _isLoading = true;
  List<FacilityLayout> _allAssessments = [];
  List<FacilityLayout> _filteredAssessments = [];

  final TextEditingController _searchController = TextEditingController();
  String _currentFilter = 'All';
  DateTime? _filterDate;
  SortOption _currentSort = SortOption.newest;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applyFilters);
    _loadAssessments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // LOGICA DI CARICAMENTO E FILTRAGGIO DATI
  Future<void> _loadAssessments() async {
    setState(() => _isLoading = true);
    final data = await DatabaseService.instance.getAllAssessments();

    setState(() {
      _allAssessments = data;
      _isLoading = false;
    });
    _applyFilters();
  }

  // Calcolo dello stato dell'assessment in base alla completezza e alle criticità
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

    double completionPct =
        totalQuestions == 0 ? 0 : (answeredQuestions / totalQuestions) * 100;

    if (completionPct < 100) return 'In Progress';
    if (hasCritical) return 'Critical Fails';
    return 'Completed';
  }

  // Applicazione dei filtri di ricerca, categoria e data con ordinamento finale
  void _applyFilters() {
    List<FacilityLayout> temp = List.from(_allAssessments);

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      temp = temp
          .where((f) => f.facilityName.toLowerCase().contains(query))
          .toList();
    }

    if (_currentFilter != 'All') {
      temp =
          temp.where((f) => _getAssessmentStatus(f) == _currentFilter).toList();
    }

    if (_filterDate != null) {
      temp = temp
          .where((f) =>
              f.dateCreated?.year == _filterDate!.year &&
              f.dateCreated?.month == _filterDate!.month &&
              f.dateCreated?.day == _filterDate!.day)
          .toList();
    }

    if (_currentSort == SortOption.newest) {
      temp.sort((a, b) =>
          b.dateCreated?.compareTo(a.dateCreated ?? DateTime.now()) ?? 0);
    } else if (_currentSort == SortOption.scoreHighToLow) {
      temp.sort(
          (a, b) => b.globalReadinessScore.compareTo(a.globalReadinessScore));
    } else if (_currentSort == SortOption.scoreLowToHigh) {
      temp.sort(
          (a, b) => a.globalReadinessScore.compareTo(b.globalReadinessScore));
    }

    setState(() {
      _filteredAssessments = temp;
    });
  }

  // GESTIONE DELLA CANCELLAZIONE
  Future<void> _confirmDelete(FacilityLayout facility) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Delete Assessment",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF003D73))),
        content: const Text(
            "Are you sure you want to permanently delete this assessment? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseService.instance.deleteAssessment(facility.id);
      _loadAssessments();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Assessment deleted successfully."),
              backgroundColor: Colors.green),
        );
      }
    }
  }

  // METODO DI RENDERING PRINCIPALE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        title: const Text("Saved Assessments",
            style: TextStyle(
                color: Color(0xFF003D73), fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnalyticsScreen()),
                );
              },
              icon: const Icon(Icons.analytics, color: Color(0xFF005DA8)),
              label: const Text("Analytics",
                  style: TextStyle(
                      color: Color(0xFF005DA8), fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(backgroundColor: Colors.blue.shade50),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Barra di ricerca e accesso alla visualizzazione mappa
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search assessment by name...",
                          prefixIcon: const Icon(Icons.search,
                              color: Color(0xFF005DA8)),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    FocusScope.of(context).unfocus();
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF005DA8),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF005DA8).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: IconButton(
                        icon:
                            const Icon(Icons.map_outlined, color: Colors.white),
                        tooltip: "View on Map",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GlobalMapScreen3D()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_allAssessments.isNotEmpty) ...[
                  _buildGeoStats(),
                ]
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade200),

          // Sezione filtri rapidi e ordinamento cronologico/punteggio
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
                      _buildFilterChip('In Progress'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Completed'),
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
                      label: Text(_filterDate == null
                          ? "Filter by Date"
                          : DateFormat('dd MMM yyyy').format(_filterDate!)),
                      style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF005DA8)),
                    ),
                    if (_filterDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear,
                            color: Colors.grey, size: 20),
                        onPressed: () {
                          setState(() => _filterDate = null);
                          _applyFilters();
                        },
                      ),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<SortOption>(
                        value: _currentSort,
                        icon: const Icon(Icons.sort,
                            color: Color(0xFF005DA8), size: 20),
                        style: const TextStyle(
                            color: Color(0xFF005DA8),
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                        items: const [
                          DropdownMenuItem(
                              value: SortOption.newest,
                              child: Text("Newest First")),
                          DropdownMenuItem(
                              value: SortOption.scoreHighToLow,
                              child: Text("Highest Score")),
                          DropdownMenuItem(
                              value: SortOption.scoreLowToHigh,
                              child: Text("Lowest Score")),
                        ],
                        onChanged: (SortOption? newValue) {
                          if (newValue != null) {
                            setState(() => _currentSort = newValue);
                            _applyFilters();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista dei risultati filtrati
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF005DA8)))
                : _filteredAssessments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text("No assessments match your filters.",
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 16)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadAssessments,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredAssessments.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return _buildAssessmentCard(
                                _filteredAssessments[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  // COMPONENTI UI E METODI DI SUPPORTO
  // Visualizzazione dei parametri geografici e media dei punteggi per regione
  Widget _buildGeoStats() {
    Map<String, List<double>> regionScores = {};
    for (var f in _allAssessments) {
      String region = f.generalInfo?.region ?? '';
      if (region.trim().isEmpty) continue;

      if (!regionScores.containsKey(region)) regionScores[region] = [];
      regionScores[region]!.add(f.globalReadinessScore);
    }

    if (regionScores.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Geographical Overview (Average Readiness)",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: regionScores.keys.length,
              itemBuilder: (context, index) {
                String region = regionScores.keys.elementAt(index);
                List<double> scores = regionScores[region]!;
                double average = scores.reduce((a, b) => a + b) / scores.length;

                Color statColor = average >= 80
                    ? Colors.green
                    : (average >= 50 ? Colors.orange : Colors.red);

                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statColor.withOpacity(0.05),
                    border: Border.all(color: statColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        region,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey.shade800),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: average / 100,
                              backgroundColor: Colors.grey.shade200,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(statColor),
                              borderRadius: BorderRadius.circular(4),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text("${average.toStringAsFixed(0)}%",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: statColor,
                                  fontSize: 13)),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Costruzione della card per il singolo assessment con indicatori di progresso e punteggio
  Widget _buildAssessmentCard(FacilityLayout facility) {
    int totalQuestions = 0;
    int answeredQuestions = 0;
    int criticalFailsCount = 0;

    for (var zone in facility.zones) {
      totalQuestions += zone.checklist.length;
      for (var q in zone.checklist) {
        if (q.selectedCompliance != ComplianceLevel.pending) {
          answeredQuestions++;
        }
        if (q.isCriticalFailure) criticalFailsCount++;
      }
    }
    double completionPct =
        totalQuestions == 0 ? 0 : (answeredQuestions / totalQuestions) * 100;

    String stateLabel = _getAssessmentStatus(facility);
    Color stateColor;
    if (stateLabel == 'Critical Fails') {
      stateColor = Colors.red.shade600;
    } else if (stateLabel == 'Completed') {
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
          FacilityType typeToOpen = FacilityType.existingFacilityWithWard;
          final savedTypeStr = facility.generalInfo?.assessedFacilityType;

          if (savedTypeStr == "Mpox stand-alone treatment centre") {
            typeToOpen = FacilityType.standAloneCenter;
          } else if (savedTypeStr ==
              "Screening for Internally Displaced People (IDP) and refugee camps") {
            typeToOpen = FacilityType.congregateSetting;
          } else if (savedTypeStr ==
              "Screening and temporary isolation for mpox") {
            typeToOpen = FacilityType.screeningAndIsolation;
          }

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InteractiveMapScreen(
                emergencyType: facility.emergencyType,
                facilityType: typeToOpen,
                assessmentId: facility.id,
              ),
            ),
          );
          _loadAssessments();
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facility.facilityName.isEmpty
                              ? "Unnamed Assessment"
                              : facility.facilityName,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${facility.emergencyType.name.toUpperCase()} • ${DateFormat('dd MMM yyyy').format(facility.dateCreated ?? DateTime.now())}",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: stateColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(stateLabel.toUpperCase(),
                        style: TextStyle(
                            color: stateColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 0.5)),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Generating Editable Report..."),
                              duration: Duration(seconds: 1)),
                        );
                        await ReportExportService
                            .exportAssessmentToEditableWord(context, facility);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Failed to generate report: $e"),
                              backgroundColor: Colors.red),
                        );
                      }
                    },
                    child: const Icon(Icons.download_rounded,
                        color: Color(0xFF005DA8), size: 26),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _confirmDelete(facility),
                    child: Icon(Icons.delete_outline,
                        color: Colors.red.shade300, size: 26),
                  ),
                ],
              ),
              Divider(color: Colors.grey.shade200, height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Progress",
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
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
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(stateColor),
                            ),
                            Center(
                              child: Text(
                                "${completionPct.toInt()}%",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: stateColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Readiness",
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                          "${facility.globalReadinessScore.toStringAsFixed(0)}%",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Critical Fails",
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(criticalFailsCount.toString(),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: criticalFailsCount > 0
                                  ? Colors.red.shade600
                                  : Colors.green.shade600)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.grey.shade300, size: 24),
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

  // Chip interattivo per il filtraggio rapido degli stati
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
          border: Border.all(
              color:
                  isSelected ? const Color(0xFF005DA8) : Colors.grey.shade300),
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
