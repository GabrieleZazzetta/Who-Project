import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../models/assessment_models.dart';
import '../l10n/app_localizations.dart';

class AdvancedAnalyticsScreen extends StatelessWidget {
  final List<FacilityLayout> data;

  const AdvancedAnalyticsScreen({super.key, required this.data});

  // CONSTANTS & THEMING
  final Color _primaryBlue = const Color(0xFF005DA8);
  final Color _slateDark = const Color(0xFF1E293B);
  final Color _slateLight = const Color(0xFF64748B);

  // MAIN UI BUILDER
  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // DATA PREPARATION
    // Sorts the assessment history chronologically to ensure the line chart
    // correctly displays the facility's readiness evolution over time.
    // Null dates are safely pushed to the end.
    final sortedData = List<FacilityLayout>.from(data)
      ..sort((a, b) {
        if (a.dateCreated == null) return 1;
        if (b.dateCreated == null) return -1;
        return a.dateCreated!.compareTo(b.dateCreated!);
      });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.advancedAnalytics,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: _slateDark,
                fontSize: isTablet ? 24 : 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: _slateDark),
      ),
      body: data.isEmpty
          ? Center(
              child: Text(AppLocalizations.of(context)!.noDataToDisplay,
                  style: TextStyle(color: _slateLight, fontSize: 16)))
          : ScreenTypeLayout.builder(
              mobile: (context) =>
                  _buildMobileLayout(context, sortedData, isLandscape),
              tablet: (context) => _buildTabletLayout(context, sortedData),
              desktop: (context) => _buildTabletLayout(context, sortedData),
            ),
    );
  }

  // MOBILE LAYOUT
  Widget _buildMobileLayout(
      BuildContext context, List<FacilityLayout> sortedData, bool isLandscape) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: isLandscape
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildSectionHeader(
                          context,
                          AppLocalizations.of(context)!.readinessTrend,
                          AppLocalizations.of(context)!.evolutionOfGlobalScore),
                      _buildLineChartCard(context, sortedData,
                          isLandscape: true),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      _buildSectionHeader(
                          context,
                          AppLocalizations.of(context)!.performanceRadar,
                          AppLocalizations.of(context)!.pillarsBalance),
                      _buildRadarChartCard(context, data, isLandscape: true),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                    context,
                    AppLocalizations.of(context)!.readinessTrend,
                    AppLocalizations.of(context)!.evolutionGlobalScoreTime),
                _buildLineChartCard(context, sortedData),
                const SizedBox(height: 32),
                _buildSectionHeader(
                    context,
                    AppLocalizations.of(context)!.multidimensionalPerformance,
                    AppLocalizations.of(context)!.balanceAcrossPillars),
                _buildRadarChartCard(context, data, isSmartphonePortrait: true),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  // TABLET & DESKTOP LAYOUT
  Widget _buildTabletLayout(
      BuildContext context, List<FacilityLayout> sortedData) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLandscape)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                          context,
                          AppLocalizations.of(context)!.readinessTrend,
                          AppLocalizations.of(context)!
                              .evolutionGlobalScoreTime),
                      _buildLineChartCard(context, sortedData,
                          isTabletPortrait: false),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                          context,
                          AppLocalizations.of(context)!
                              .multidimensionalPerformance,
                          AppLocalizations.of(context)!.balanceAcrossPillars),
                      _buildRadarChartCard(context, data,
                          isTabletPortrait: false),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                    context,
                    AppLocalizations.of(context)!.readinessTrend,
                    AppLocalizations.of(context)!.evolutionGlobalScoreTime),
                _buildLineChartCard(context, sortedData,
                    isTabletPortrait: true),
                const SizedBox(height: 48),
                _buildSectionHeader(
                    context,
                    AppLocalizations.of(context)!.multidimensionalPerformance,
                    AppLocalizations.of(context)!.balanceAcrossPillars),
                _buildRadarChartCard(context, data, isTabletPortrait: true),
              ],
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, String subtitle) {
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

  // CHART WIDGETS
  // Line chart visualization
  Widget _buildLineChartCard(
      BuildContext context, List<FacilityLayout> sortedData,
      {bool isLandscape = false, bool isTabletPortrait = false}) {
    final validData = sortedData.where((d) => d.dateCreated != null).toList();

    // Handle single data point edge case
    if (validData.length == 1) {
      final single = validData.first;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: _cardDecoration(),
        child: Column(
          children: [
            Icon(Icons.insights_rounded,
                size: 40, color: _primaryBlue.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(
              "${single.globalReadinessScore.toStringAsFixed(1)}%",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: _primaryBlue),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.readinessScoreFor(
                  single.facilityName.isNotEmpty
                      ? single.facilityName
                      : AppLocalizations.of(context)!.thisAssessment),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _slateLight,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.addMoreAssessmentsUnlock,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: _slateLight.withValues(alpha: 0.6), fontSize: 11),
            ),
          ],
        ),
      );
    }

    if (validData.length < 2) {
      return _buildEmptyStateCard(
          context, AppLocalizations.of(context)!.notEnoughHistoricalData);
    }

    List<FlSpot> spots = [];
    for (int i = 0; i < validData.length; i++) {
      spots.add(FlSpot(i.toDouble(), validData[i].globalReadinessScore));
    }

    // Calculate time period
    final DateTime firstDate = validData.first.dateCreated!;
    final DateTime lastDate = validData.last.dateCreated!;
    final bool sameDay = firstDate.year == lastDate.year &&
        firstDate.month == lastDate.month &&
        firstDate.day == lastDate.day;
    final String periodLabel = sameDay
        ? DateFormat('d MMM yyyy').format(firstDate)
        : '${DateFormat('d MMM yyyy').format(firstDate)}  →  ${DateFormat('d MMM yyyy').format(lastDate)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart configuration
        Container(
          height: isLandscape ? 260 : (isTabletPortrait ? 400 : 380),
          padding: const EdgeInsets.fromLTRB(8, 24, 16, 16),
          decoration: _cardDecoration(),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: Colors.grey.shade200, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 38,
                    interval: 20,
                    getTitlesWidget: (value, meta) => Text(
                      "${value.toInt()}%",
                      style: TextStyle(color: _slateLight, fontSize: 10),
                    ),
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (validData.length - 1).toDouble(),
              minY: 0,
              maxY: 100,
              // Tooltip configuration
              // Generates a dynamic multi-line tooltip showing the score,
              // facility name (or fallback index), and the exact creation date.
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => Colors.white,
                  tooltipBorderRadius: BorderRadius.circular(10),
                  tooltipBorder:
                      BorderSide(color: Colors.grey.shade200, width: 1),
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final int index = spot.x.toInt();
                      final String name = index < validData.length
                          ? (validData[index].facilityName.isNotEmpty
                              ? validData[index].facilityName
                              : AppLocalizations.of(context)!
                                  .assessmentIndex(index + 1))
                          : '';
                      final String dateStr = index < validData.length
                          ? DateFormat('d MMM yyyy')
                              .format(validData[index].dateCreated!)
                          : '';
                      return LineTooltipItem(
                        "${spot.y.toStringAsFixed(1)}%\n",
                        TextStyle(
                            color: _primaryBlue,
                            fontWeight: FontWeight.w900,
                            fontSize: 15),
                        children: [
                          TextSpan(
                            text: "$name\n",
                            style: TextStyle(
                                color: _slateDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 10),
                          ),
                          TextSpan(
                            text: dateStr,
                            style: TextStyle(
                                color: _slateLight,
                                fontWeight: FontWeight.w400,
                                fontSize: 9),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: _primaryBlue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, pct, bar, index) =>
                        FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2.5,
                      strokeColor: _primaryBlue,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        _primaryBlue.withValues(alpha: 0.18),
                        _primaryBlue.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Period indicator
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 4),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 11, color: _slateLight.withValues(alpha: 0.5)),
              const SizedBox(width: 5),
              Text(
                periodLabel,
                style: TextStyle(
                  fontSize: 11,
                  color: _slateLight.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Radar chart visualization
  Widget _buildRadarChartCard(
      BuildContext context, List<FacilityLayout> allData,
      {bool isLandscape = false,
      bool isSmartphonePortrait = false,
      bool isTabletPortrait = false}) {
    // Scoring matrix per technical pillar.
    // Index 0: Accumulated score value. Index 1: Total possible maximum score.
    Map<AssessmentCategory, List<int>> categoryScores = {
      AssessmentCategory.infectionPreventionControl: [0, 0],
      AssessmentCategory.wash: [0, 0],
      AssessmentCategory.spatialLayout: [0, 0],
      AssessmentCategory.logistics: [0, 0],
    };

    // Aggregates raw score values across all answered questions.
    // Excludes Pending or Not Applicable answers to avoid skewing the percentage.
    for (var facility in allData) {
      for (var zone in facility.zones) {
        for (var q in zone.checklist) {
          if (q.selectedCompliance != ComplianceLevel.pending &&
              q.selectedCompliance != ComplianceLevel.notApplicable) {
            categoryScores[q.category]![1] += 3;
            categoryScores[q.category]![0] += q.scoreValue;
          }
        }
      }
    }

    double getPct(AssessmentCategory cat) {
      if (categoryScores[cat]![1] == 0) return 0;
      return (categoryScores[cat]![0] / categoryScores[cat]![1]) * 100;
    }

    double ipc = getPct(AssessmentCategory.infectionPreventionControl);
    double wash = getPct(AssessmentCategory.wash);
    double layout = getPct(AssessmentCategory.spatialLayout);
    double logistics = getPct(AssessmentCategory.logistics);

    return Container(
      height: isLandscape
          ? 280
          : (isTabletPortrait ? 500 : (isSmartphonePortrait ? 420 : 350)),
      padding: const EdgeInsets.fromLTRB(52, 24, 52, 24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Expanded(
            child: RadarChart(
              RadarChartData(
                dataSets: [
                  RadarDataSet(
                    fillColor: _primaryBlue.withValues(alpha: 0.2),
                    borderColor: _primaryBlue,
                    entryRadius: 4,
                    dataEntries: [
                      RadarEntry(value: ipc),
                      RadarEntry(value: wash),
                      RadarEntry(value: layout),
                      RadarEntry(value: logistics),
                    ],
                    borderWidth: 2,
                  ),
                ],
                radarBackgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                radarBorderData: const BorderSide(color: Colors.transparent),
                titlePositionPercentageOffset: 0.15,
                tickCount: 5,
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                tickBorderData:
                    BorderSide(color: Colors.grey.shade300, width: 1),
                gridBorderData:
                    BorderSide(color: Colors.grey.shade200, width: 1.5),
                getTitle: (index, angle) {
                  switch (index) {
                    case 0:
                      return RadarChartTitle(
                          text: 'IPC\n${ipc.toStringAsFixed(0)}%', angle: 0);
                    case 1:
                      return RadarChartTitle(
                          text: 'WASH\n${wash.toStringAsFixed(0)}%', angle: 0);
                    case 2:
                      return RadarChartTitle(
                          text: 'LAYOUT\n${layout.toStringAsFixed(0)}%',
                          angle: 0);
                    case 3:
                      return RadarChartTitle(
                          text: 'LOGISTICS\n${logistics.toStringAsFixed(0)}%',
                          angle: 0);
                    default:
                      return const RadarChartTitle(text: '');
                  }
                },
                titleTextStyle: TextStyle(
                    color: _slateDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w800),
              ),
              duration: const Duration(milliseconds: 400),
            ),
          ),
        ],
      ),
    );
  }

  // UTILITY WIDGETS & STYLES
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
        border: Border.all(color: Colors.grey.shade100));
  }

  // Empty state handling
  Widget _buildEmptyStateCard(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Icon(Icons.auto_graph_rounded, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: _slateLight, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
