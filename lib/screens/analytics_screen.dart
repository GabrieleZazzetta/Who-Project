import 'package:flutter/material.dart';
import '../models/assessment_models.dart';
import '../services/database_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseService.instance.getAllAssessments();

    // Estraiamo Paesi e Anni unici per popolare i filtri
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

  // --- LOGICA DI FILTRAGGIO ---
  List<FacilityLayout> get _filteredData {
    return _allAssessments.where((f) {
      bool matchCountry = _selectedCountry == 'All Countries' ||
          f.generalInfo?.country == _selectedCountry;
      bool matchYear = _selectedYear == 'All Years' ||
          f.dateCreated?.year.toString() == _selectedYear;
      return matchCountry && matchYear;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final data = _filteredData;

    // --- CALCOLO DELLE STATISTICHE ---
    double totalReadiness = 0;
    int totalQuestionsAnswered = 0;
    int meetsTargetCount = 0;
    int partialCount = 0;
    int doesNotMeetCount = 0;
    int criticalFailsCount = 0;

    for (var facility in data) {
      totalReadiness += facility.globalReadinessScore;
      for (var zone in facility.zones) {
        for (var q in zone.checklist) {
          if (q.selectedCompliance != ComplianceLevel.pending) {
            totalQuestionsAnswered++;
            if (q.selectedCompliance == ComplianceLevel.meetsTarget)
              meetsTargetCount++;
            if (q.selectedCompliance == ComplianceLevel.partiallyMeets)
              partialCount++;
            if (q.selectedCompliance == ComplianceLevel.doesNotMeet)
              doesNotMeetCount++;
            if (q.isCriticalFailure) criticalFailsCount++;
          }
        }
      }
    }

    double avgReadiness = data.isEmpty ? 0 : totalReadiness / data.length;

    // Percentuali per la Stacked Bar
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
        title: const Text("Data Analytics",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF003D73))),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF003D73)),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. ZONA FILTRI FISSA IN ALTO
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                        "Country",
                        _selectedCountry,
                        _availableCountries,
                        (val) => setState(() => _selectedCountry = val!)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                        "Year",
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
                child: Text("No data available for this selection.",
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 16)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 2. I TRE KPI PRINCIPALI
                  Row(
                    children: [
                      Expanded(
                          child: _buildKpiCard(
                              "Assessments",
                              data.length.toString(),
                              Icons.analytics,
                              Colors.blue)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildKpiCard(
                              "Avg Readiness",
                              "${avgReadiness.toStringAsFixed(1)}%",
                              Icons.health_and_safety,
                              avgReadiness > 70
                                  ? Colors.green
                                  : Colors.orange)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildKpiCard(
                              "Critical Fails",
                              criticalFailsCount.toString(),
                              Icons.warning_amber_rounded,
                              criticalFailsCount > 0
                                  ? Colors.red
                                  : Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 3. COMPLIANCE BREAKDOWN (La barra a strati PRO)
                  const Text("Compliance Breakdown",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A))),
                  const SizedBox(height: 8),
                  Text(
                      "Based on $totalQuestionsAnswered total evaluated criteria.",
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10)
                        ]),
                    child: Column(
                      children: [
                        // La barra colorata
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 24,
                            child: Row(
                              children: [
                                if (meetsPct > 0)
                                  Expanded(
                                      flex: (meetsPct * 100).toInt(),
                                      child: Container(
                                          color: Colors.green.shade500)),
                                if (partialPct > 0)
                                  Expanded(
                                      flex: (partialPct * 100).toInt(),
                                      child: Container(
                                          color: Colors.orange.shade400)),
                                if (failsPct > 0)
                                  Expanded(
                                      flex: (failsPct * 100).toInt(),
                                      child: Container(
                                          color: Colors.red.shade500)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Legenda
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildLegendItem("Meets Target", meetsPct,
                                Colors.green.shade500),
                            _buildLegendItem(
                                "Partial", partialPct, Colors.orange.shade400),
                            _buildLegendItem(
                                "Does Not Meet", failsPct, Colors.red.shade500),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 4. CLASSIFICA GEOGRAFICA (Geo-Ranking)
                  const Text("Geographical Ranking",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A))),
                  const SizedBox(height: 16),
                  _buildGeographicalRanking(),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  // --- COMPONENTI UI PRIVATI ---

  Widget _buildDropdown(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: items
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600))))
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
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 4),
          Text(title,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, double pct, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                width: 12,
                height: 12,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        Text("${(pct * 100).toStringAsFixed(1)}%",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildGeographicalRanking() {
    // Raggruppiamo i dati per nazione in base ai dati filtrati attualmente
    Map<String, List<double>> countryScores = {};
    for (var f in _filteredData) {
      String country = f.generalInfo?.country ?? 'Unknown';
      if (country.trim().isEmpty) country = 'Unknown';
      if (!countryScores.containsKey(country)) countryScores[country] = [];
      countryScores[country]!.add(f.globalReadinessScore);
    }

    // Calcoliamo le medie
    List<MapEntry<String, double>> ranking = countryScores.entries.map((e) {
      double avg = e.value.reduce((a, b) => a + b) / e.value.length;
      return MapEntry(e.key, avg);
    }).toList();

    // Ordiniamo dal migliore al peggiore
    ranking.sort((a, b) => b.value.compareTo(a.value));

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ranking.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.grey.shade100),
        itemBuilder: (context, index) {
          final entry = ranking[index];
          Color barColor = entry.value >= 80
              ? Colors.green
              : (entry.value >= 50 ? Colors.orange : Colors.red);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Posizione in classifica
                Text("#${index + 1}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("${entry.value.toStringAsFixed(1)}%",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: barColor)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: entry.value / 100,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(barColor),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
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
