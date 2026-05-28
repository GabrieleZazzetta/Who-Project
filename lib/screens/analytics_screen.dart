import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../models/assessment_models.dart';
import '../services/database_service.dart';
import '../l10n/app_localizations.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // LOGICA DI STATO E CONFIGURAZIONE GRAFICA
  bool _isLoading = true;
  List<FacilityLayout> _allAssessments = [];

  String _selectedCountry = 'All Countries';
  String _selectedYear = 'All Years';

  final List<String> _availableCountries = ['All Countries'];
  final List<String> _availableYears = ['All Years'];

  final Color _primaryBlue = const Color(0xFF005DA8);
  final Color _slateDark = const Color(0xFF1E293B);
  final Color _slateLight = const Color(0xFF64748B);

  final Color _colorMeets = const Color(0xFF10B981);
  final Color _colorPartial = const Color(0xFFF59E0B);
  final Color _colorFails = const Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // LOGICA DI CARICAMENTO DATI
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

    if (mounted) {
      setState(() {
        _allAssessments = data;
        _availableCountries.addAll(countries.toList()..sort());
        _availableYears.addAll(years.toList()..sort((a, b) => b.compareTo(a)));
        _isLoading = false;
      });
    }
  }

  // Calcolo dinamico del set di dati filtrato
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

  // METODO DI RENDERING PRINCIPALE ADATTIVO
  // MODAL INFORMATIVO PREMIUM
  void _showMetricInfo(String title, String description) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.info_outline_rounded, color: _primaryBlue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: _slateDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              description,
              style: TextStyle(
                  fontSize: 16,
                  color: _slateLight,
                  height: 1.6,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.gotIt,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: Center(child: CircularProgressIndicator(color: _primaryBlue)));
    }

    final data = _filteredData;

    // ELABORAZIONE STATISTICHE AGGREGATE PER L'ANALISI
    double totalReadiness = 0;
    int totalQuestionsAnswered = 0;
    int meetsTargetCount = 0;
    int partialCount = 0;
    int doesNotMeetCount = 0;
    int criticalFailsCount = 0;

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
            } else if (q.selectedCompliance == ComplianceLevel.partiallyMeets) {
              partialCount++;
            } else if (q.selectedCompliance == ComplianceLevel.doesNotMeet) {
              doesNotMeetCount++;
            }
            if (q.isCriticalFailure) criticalFailsCount++;

            categoryScores[q.category]![1] += 3;
            categoryScores[q.category]![0] += q.scoreValue;
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
        title: Text(AppLocalizations.of(context)!.dataAnalytics,
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
                tooltip: AppLocalizations.of(context)!.advancedCharts,
                icon: Icon(Icons.insights_rounded, color: _primaryBlue),
                onPressed: () {
                  context.push('/advanced-analytics', extra: data);
                },
              ),
            ),
        ],
      ),
      body: getValueForScreenType<Widget>(
        context: context,
        mobile: _buildVerticalLayout(data, avgReadiness, criticalFailsCount, totalQuestionsAnswered, meetsTargetCount, meetsPct, partialCount, partialPct, doesNotMeetCount, failsPct, categoryScores),
        tablet: _buildAdaptiveLayout(data, avgReadiness, criticalFailsCount, totalQuestionsAnswered, meetsTargetCount, meetsPct, partialCount, partialPct, doesNotMeetCount, failsPct, categoryScores),
        desktop: _buildAdaptiveLayout(data, avgReadiness, criticalFailsCount, totalQuestionsAnswered, meetsTargetCount, meetsPct, partialCount, partialPct, doesNotMeetCount, failsPct, categoryScores),
      ),
    );
  }

  // LAYOUT VERTICALE OTTIMIZZATO PER MOBILE E LANDSCAPE
  Widget _buildVerticalLayout(List<FacilityLayout> data, double avgReadiness, int criticalFailsCount, int totalQuestionsAnswered, int meetsTargetCount, double meetsPct, int partialCount, double partialPct, int doesNotMeetCount, double failsPct, Map<AssessmentCategory, List<int>> categoryScores) {
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return CustomScrollView(
      slivers: [
        _buildFiltersSliver(),
        if (data.isEmpty) _buildEmptyStateSliver()
        else SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildKpiRow(data.length, avgReadiness, criticalFailsCount),
              const SizedBox(height: 32),
              
              // In landscape mostriamo le sezioni affiancate per ottimizzare lo spazio
              if (isLandscape)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildComplianceSection(totalQuestionsAnswered, meetsTargetCount, meetsPct, partialCount, partialPct, doesNotMeetCount, failsPct)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildCategorySection(categoryScores)),
                  ],
                )
              else ...[
                _buildComplianceSection(totalQuestionsAnswered, meetsTargetCount, meetsPct, partialCount, partialPct, doesNotMeetCount, failsPct),
                const SizedBox(height: 32),
                _buildCategorySection(categoryScores),
              ],
              
              const SizedBox(height: 32),
              _buildRankingSection(),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }

  // LAYOUT ADATTIVO PER TABLET E DESKTOP
  Widget _buildAdaptiveLayout(List<FacilityLayout> data, double avgReadiness, int criticalFailsCount, int totalQuestionsAnswered, int meetsTargetCount, double meetsPct, int partialCount, double partialPct, int doesNotMeetCount, double failsPct, Map<AssessmentCategory, List<int>> categoryScores) {
    return CustomScrollView(
      slivers: [
        _buildFiltersSliver(),
        if (data.isEmpty) _buildEmptyStateSliver()
        else SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildKpiRow(data.length, avgReadiness, criticalFailsCount),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildComplianceSection(totalQuestionsAnswered, meetsTargetCount, meetsPct, partialCount, partialPct, doesNotMeetCount, failsPct)),
                  const SizedBox(width: 32),
                  Expanded(child: _buildCategorySection(categoryScores)),
                ],
              ),
              const SizedBox(height: 32),
              _buildRankingSection(),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }

  // COMPONENTI SLIVER E BLOCCHI LOGICI
  
  SliverToBoxAdapter _buildFiltersSliver() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: _buildDropdown(
                  AppLocalizations.of(context)!.countryRegion,
                  _selectedCountry,
                  _availableCountries,
                  (val) => setState(() => _selectedCountry = val!)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdown(
                  AppLocalizations.of(context)!.reportingYear,
                  _selectedYear,
                  _availableYears,
                  (val) => setState(() => _selectedYear = val!)),
            ),
          ],
        ),
      ),
    );
  }

  SliverFillRemaining _buildEmptyStateSliver() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.noReportsAvailable,
                style: TextStyle(color: _slateLight, fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // COMPONENTI UI: KPI E INDICATORI
  Widget _buildKpiRow(int count, double avgReadiness, int criticalFails) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final bool isSmartphonePortrait = !isTablet && !isLandscape;

    final Widget rowWidget = Row(
      crossAxisAlignment: isSmartphonePortrait
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.center,
      children: [
        Expanded(
            child: _buildKpiCard(AppLocalizations.of(context)!.assessmentsCount, count.toString(),
                Icons.fact_check_outlined, _primaryBlue,
                info: AppLocalizations.of(context)!.assessmentsCountInfo)),
        const SizedBox(width: 12),
        Expanded(
            child: _buildKpiCard(AppLocalizations.of(context)!.avgReadiness,
                "${avgReadiness.toStringAsFixed(1)}%",
                Icons.health_and_safety_outlined, _primaryBlue,
                info: AppLocalizations.of(context)!.avgReadinessInfo)),
        const SizedBox(width: 12),
        Expanded(
            child: _buildKpiCard(AppLocalizations.of(context)!.criticalFails, criticalFails.toString(),
                Icons.warning_amber_rounded, _slateDark,
                info: AppLocalizations.of(context)!.criticalFailsInfo)),
      ],
    );

    if (isSmartphonePortrait) {
      return IntrinsicHeight(child: rowWidget);
    }
    return rowWidget;
  }

  Widget _buildComplianceSection(int total, int meetsCount, double meetsPct, int partialCount, double partialPct, int doesNotMeetCount, double failsPct) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(AppLocalizations.of(context)!.complianceBreakdown, AppLocalizations.of(context)!.distributionCriteria(total), 
          info: AppLocalizations.of(context)!.complianceBreakdownInfo),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 28,
                  child: Row(
                    children: [
                      if (meetsPct > 0) Expanded(flex: (meetsPct * 1000).toInt(), child: Container(color: _colorMeets)),
                      if (partialPct > 0) Expanded(flex: (partialPct * 1000).toInt(), child: Container(color: _colorPartial)),
                      if (failsPct > 0) Expanded(flex: (failsPct * 1000).toInt(), child: Container(color: _colorFails)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildLegendItem(AppLocalizations.of(context)!.meets, meetsCount, meetsPct, _colorMeets),
                  _buildLegendItem(AppLocalizations.of(context)!.partial, partialCount, partialPct, _colorPartial),
                  _buildLegendItem(AppLocalizations.of(context)!.fails, doesNotMeetCount, failsPct, _colorFails),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(Map<AssessmentCategory, List<int>> scores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(AppLocalizations.of(context)!.categoryPerformance, AppLocalizations.of(context)!.readinessScoreTech, 
          info: AppLocalizations.of(context)!.categoryPerformanceInfo),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration(),
          child: Column(
            children: scores.entries.map((entry) {
              double percentage = entry.value[1] == 0 ? 0 : (entry.value[0] / entry.value[1]) * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_getCategoryAcronym(entry.key), style: TextStyle(fontWeight: FontWeight.w700, color: _slateDark, fontSize: 13)),
                        Text("${percentage.toStringAsFixed(1)}%", style: TextStyle(fontWeight: FontWeight.w900, color: _primaryBlue, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(_primaryBlue),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(AppLocalizations.of(context)!.geographicalRanking, AppLocalizations.of(context)!.avgReadinessCountry,
          info: AppLocalizations.of(context)!.geographicalRankingInfo),
        _buildGeographicalRanking(),
      ],
    );
  }

  // COMPONENTI UI E STILI RIUTILIZZABILI
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

  Widget _buildSectionHeader(String title, String subtitle, {String? info}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
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
          ),
          if (info != null)
            IconButton(
              icon: Icon(Icons.info_outline_rounded,
                  size: 20, color: _slateLight.withOpacity(0.6)),
              onPressed: () => _showMetricInfo(title, info),
            ),
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
                  .map((e) {
                    String displayE = e;
                    if (e == 'All Countries') displayE = AppLocalizations.of(context)!.allCountries;
                    else if (e == 'All Years') displayE = AppLocalizations.of(context)!.allYears;
                    return DropdownMenuItem(
                      value: e,
                      child: Text(displayE,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _slateDark)));
                  })
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color,
      {String? info}) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final bool isSmartphonePortrait = !isTablet && !isLandscape;

    return InkWell(
      onTap: info != null ? () => _showMetricInfo(title, info) : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: isSmartphonePortrait
            ? const BoxConstraints(minHeight: 140)
            : null,
        padding: isSmartphonePortrait
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 14)
            : const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: 24),
                ),
                if (info != null)
                  Icon(Icons.info_outline_rounded,
                      size: 16, color: _slateLight.withOpacity(0.4)),
              ],
            ),
            if (isSmartphonePortrait)
              const Spacer()
            else
              const SizedBox(height: 16),
            Text(value,
                style: TextStyle(
                    fontSize: isSmartphonePortrait ? 21 : 24,
                    fontWeight: FontWeight.w900,
                    color: _slateDark)),
            const SizedBox(height: 4),
            Text(title,
                style: TextStyle(
                    fontSize: isSmartphonePortrait ? 10.5 : 12,
                    fontWeight: FontWeight.w600,
                    color: _slateLight,
                    height: 1.25)),
          ],
        ),
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
