import 'package:flutter/material.dart';
import '../models/assessment_models.dart';
import '../services/database_service.dart';
import 'advanced_analytics_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isLoading = true;
  List<FacilityLayout> _allAssessments = [];

  // Variabili per i filtri
  String _selectedCountry = 'All Countries';
  String _selectedYear = 'All Years';

  // Liste uniche per i dropdown
  List<String> _availableCountries = ['All Countries'];
  List<String> _availableYears = ['All Years'];

  // Colori PRO del brand (WHO style)
  final Color _primaryBlue = const Color(0xFF005DA8);
  final Color _slateDark = const Color(0xFF1E293B);
  final Color _slateLight = const Color(0xFF64748B);

  // Colori Semantici Rigorosi
  final Color _colorMeets = const Color(0xFF10B981); // Verde Smeraldo
  final Color _colorPartial = const Color(0xFFF59E0B); // Ambra/Giallo
  final Color _colorFails = const Color(0xFFEF4444); // Rosso

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseService.instance.getAllAssessments();

    Set<String> countries = {};
    Set<String> years = {};

    for (var f in data) {
      if (f.generalInfo?.country != null &&
          f.generalInfo!.country!.isNotEmpty) {
        countries.add(f.generalInfo!.country!);
      }
      if (f.dateCreated != null) {
        years.add(f.dateCreated!.year.toString());
      }
    }

    setState(() {
      _allAssessments = data;
      _availableCountries.addAll(countries.toList()..sort());
      _availableYears.addAll(
          years.toList()..sort((a, b) => b.compareTo(a))); // Più recenti prima
      _isLoading = false;
    });
  }

  List<FacilityLayout> get _filteredData {
    return _allAssessments.where((f) {
      bool matchCountry = _selectedCountry == 'All Countries' ||
          f.generalInfo?.country == _selectedCountry;
      bool matchYear = _selectedYear == 'All Years' ||
          f.dateCreated?.year.toString() == _selectedYear;
      return matchCountry && matchYear;
    }).toList();
  }

  String _getCategoryAcronym(AssessmentCategory category) {
    switch (category) {
      case AssessmentCategory.infectionPreventionControl:
        return "IPC";
      case AssessmentCategory.wash:
        return "WASH";
      case AssessmentCategory.spatialLayout:
        return "Spatial Layout";
      case AssessmentCategory.logistics:
        return "Logistics";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: Center(child: CircularProgressIndicator(color: _primaryBlue)));
    }

    final data = _filteredData;

    // --- CALCOLO DELLE STATISTICHE GLOBALI ---
    double totalReadiness = 0;
    int totalQuestionsAnswered = 0;
    int meetsTargetCount = 0;
    int partialCount = 0;
    int doesNotMeetCount = 0;
    int criticalFailsCount = 0;

    // Mappa per le performance di categoria: [ActualScore, MaxPossibleScore]
    Map<AssessmentCategory, List<int>> categoryScores = {
      AssessmentCategory.infectionPreventionControl: [0, 0],
      AssessmentCategory.wash: [0, 0],
      AssessmentCategory.spatialLayout: [0, 0],
      AssessmentCategory.logistics: [0, 0],
    };

    for (var facility in data) {
      totalReadiness += facility.globalReadinessScore;
      for (var zone in facility.zones) {
        for (var q in zone.checklist) {
          if (q.selectedCompliance != ComplianceLevel.pending &&
              q.selectedCompliance != ComplianceLevel.notApplicable) {
            totalQuestionsAnswered++;

            if (q.selectedCompliance == ComplianceLevel.meetsTarget) {
              meetsTargetCount++;
            }
            if (q.selectedCompliance == ComplianceLevel.partiallyMeets) {
              partialCount++;
            }
            if (q.selectedCompliance == ComplianceLevel.doesNotMeet) {
              doesNotMeetCount++;
            }
            if (q.isCriticalFailure) criticalFailsCount++;

            // Aggiorna le statistiche per categoria
            categoryScores[q.category]![1] += 3; // Max punteggio possibile
            categoryScores[q.category]![0] += q.scoreValue; // Punteggio reale
          }
        }
      }
    }

    double avgReadiness = data.isEmpty ? 0 : totalReadiness / data.length;

    double meetsPct = totalQuestionsAnswered == 0
        ? 0
        : (meetsTargetCount / totalQuestionsAnswered);
    double partialPct = totalQuestionsAnswered == 0
        ? 0
        : (partialCount / totalQuestionsAnswered);
    double failsPct = totalQuestionsAnswered == 0
        ? 0
        : (doesNotMeetCount / totalQuestionsAnswered);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text("Data Analytics",
            style: TextStyle(fontWeight: FontWeight.w800, color: _slateDark)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: _slateDark),
        shadowColor: Colors.black12,
        actions: [
          if (data.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                tooltip: "Advanced Charts",
                icon: Icon(Icons.insights_rounded, color: _primaryBlue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Passiamo i dati 'data' (che sono quelli già filtrati!)
                      builder: (context) => AdvancedAnalyticsScreen(data: data),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. ZONA FILTRI FISSA IN ALTO
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                        "Country / Region",
                        _selectedCountry,
                        _availableCountries,
                        (val) => setState(() => _selectedCountry = val!)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                        "Reporting Year",
                        _selectedYear,
                        _availableYears,
                        (val) => setState(() => _selectedYear = val!)),
                  ),
                ],
              ),
            ),
          ),

          if (data.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.analytics_outlined,
                        size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text("No reports available for this selection.",
                        style: TextStyle(
                            color: _slateLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 2. I TRE KPI PRINCIPALI (Colori Neutri/Brand)
                  Row(
                    children: [
                      Expanded(
                          child: _buildKpiCard(
                              "Assessments",
                              data.length.toString(),
                              Icons.fact_check_outlined,
                              _primaryBlue)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildKpiCard(
                              "Avg Readiness",
                              "${avgReadiness.toStringAsFixed(1)}%",
                              Icons.health_and_safety_outlined,
                              _primaryBlue)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildKpiCard(
                              "Critical Fails",
                              criticalFailsCount.toString(),
                              Icons.warning_amber_rounded,
                              _slateDark)), // Neutro scuro, non rosso!
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 3. COMPLIANCE BREAKDOWN (Unici colori semantici ammessi)
                  _buildSectionHeader("Compliance Breakdown",
                      "Distribution of $totalQuestionsAnswered evaluated criteria"),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: _cardDecoration(),
                    child: Column(
                      children: [
                        // Barra a strati
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 28, // Più spessa per un look PRO
                            child: Row(
                              children: [
                                if (meetsPct > 0)
                                  Expanded(
                                      flex: (meetsPct * 1000).toInt(),
                                      child: Container(color: _colorMeets)),
                                if (partialPct > 0)
                                  Expanded(
                                      flex: (partialPct * 1000).toInt(),
                                      child: Container(color: _colorPartial)),
                                if (failsPct > 0)
                                  Expanded(
                                      flex: (failsPct * 1000).toInt(),
                                      child: Container(color: _colorFails)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Legenda Dettagliata
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLegendItem("Meets Target", meetsTargetCount,
                                meetsPct, _colorMeets),
                            _buildLegendItem("Partial", partialCount,
                                partialPct, _colorPartial),
                            _buildLegendItem("Does Not Meet", doesNotMeetCount,
                                failsPct, _colorFails),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 4. CATEGORY PERFORMANCE (Nuovo Modulo Analitico)
                  _buildSectionHeader("Category Performance",
                      "Readiness score across main technical areas"),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: _cardDecoration(),
                    child: Column(
                      children: categoryScores.entries.map((entry) {
                        double percentage = entry.value[1] == 0
                            ? 0
                            : (entry.value[0] / entry.value[1]) * 100;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_getCategoryAcronym(entry.key),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: _slateDark,
                                          fontSize: 13)),
                                  Text("${percentage.toStringAsFixed(1)}%",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: _primaryBlue,
                                          fontSize: 14)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    _primaryBlue), // Colore neutro/brand
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 5. CLASSIFICA GEOGRAFICA (Geo-Ranking Neutro)
                  _buildSectionHeader("Geographical Ranking",
                      "Average readiness score by country"),
                  _buildGeographicalRanking(),

                  const SizedBox(height: 40), // Spazio finale
                ]),
              ),
            ),
        ],
      ),
    );
  }

  // --- COMPONENTI UI PRIVATI E STILI ---

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
        border: Border.all(color: Colors.grey.shade100));
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _slateDark)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(
                  fontSize: 13,
                  color: _slateLight,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _slateLight,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: _slateLight),
              items: items
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _slateDark))))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: _slateDark)),
          const SizedBox(height: 4),
          Text(title,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _slateLight)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, int count, double pct, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(3))),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: _slateDark,
                    fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        Text("${(pct * 100).toStringAsFixed(1)}% ($count)",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w800, color: _slateLight)),
      ],
    );
  }

  Widget _buildGeographicalRanking() {
    Map<String, List<double>> countryScores = {};
    for (var f in _filteredData) {
      String country = f.generalInfo?.country ?? 'Unknown';
      if (country.trim().isEmpty) country = 'Unknown';
      if (!countryScores.containsKey(country)) countryScores[country] = [];
      countryScores[country]!.add(f.globalReadinessScore);
    }

    List<MapEntry<String, double>> ranking = countryScores.entries.map((e) {
      double avg = e.value.reduce((a, b) => a + b) / e.value.length;
      return MapEntry(e.key, avg);
    }).toList();

    ranking.sort((a, b) => b.value.compareTo(a.value));

    return Container(
      decoration: _cardDecoration(),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ranking.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.grey.shade100),
        itemBuilder: (context, index) {
          final entry = ranking[index];
          // Niente più rosso/verde qui! Usiamo il blu con diversa opacità per eleganza
          Color barColor = _primaryBlue;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text("#${index + 1}",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: _slateLight.withOpacity(0.5))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: _slateDark)),
                          Text("${entry.value.toStringAsFixed(1)}%",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: _slateDark)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: entry.value / 100,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(barColor),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
