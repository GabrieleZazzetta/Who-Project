import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../models/assessment_models.dart';

class AdvancedAnalyticsScreen extends StatelessWidget {
  final List<FacilityLayout> data;

  const AdvancedAnalyticsScreen({super.key, required this.data});

  // CONFIGURAZIONE E TEMA
  final Color _primaryBlue = const Color(0xFF005DA8);
  final Color _slateDark = const Color(0xFF1E293B);
  final Color _slateLight = const Color(0xFF64748B);

  // LOGICA DI COSTRUZIONE DELL'INTERFACCIA CON SUPPORTO ADATTIVO
  @override
  Widget build(BuildContext context) {
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    // Ordinamento cronologico per l'analisi temporale dei trend
    final sortedData = List<FacilityLayout>.from(data)
      ..sort((a, b) {
        if (a.dateCreated == null) return 1;
        if (b.dateCreated == null) return -1;
        return a.dateCreated!.compareTo(b.dateCreated!);
      });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text("Advanced Analytics",
            style: TextStyle(
                fontWeight: FontWeight.w800, color: _slateDark, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: _slateDark),
      ),
      body: data.isEmpty
          ? Center(
              child: Text("No data to display.",
                  style: TextStyle(color: _slateLight, fontSize: 16)))
          : ScreenTypeLayout.builder(
              mobile: (context) => _buildMobileLayout(sortedData, isLandscape),
              tablet: (context) => _buildTabletLayout(sortedData),
              desktop: (context) => _buildTabletLayout(sortedData),
            ),
    );
  }

  // LAYOUT VERTICALE OTTIMIZZATO PER MOBILE E LANDSCAPE
  Widget _buildMobileLayout(List<FacilityLayout> sortedData, bool isLandscape) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: isLandscape
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildSectionHeader("Readiness Trend", "Evolution of global score"),
                      _buildLineChartCard(sortedData, isLandscape: true),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      _buildSectionHeader("Performance Radar", "Pillars balance"),
                      _buildRadarChartCard(data, isLandscape: true),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Readiness Trend", "Evolution of the global score over time"),
                _buildLineChartCard(sortedData),
                const SizedBox(height: 32),
                _buildSectionHeader("Multidimensional Performance", "Balance across technical pillars"),
                _buildRadarChartCard(data, isSmartphonePortrait: true),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  // LAYOUT ADATTIVO PER TABLET E DESKTOP
  Widget _buildTabletLayout(List<FacilityLayout> sortedData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
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
                    _buildSectionHeader("Readiness Trend", "Evolution of the global score over time"),
                    _buildLineChartCard(sortedData),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Multidimensional Performance", "Balance across technical pillars"),
                    _buildRadarChartCard(data),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
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

  // COMPONENTI DEI GRAFICI
  // Grafico a linee per la visualizzazione del trend di readiness
  Widget _buildLineChartCard(List<FacilityLayout> sortedData, {bool isLandscape = false}) {
    final validData = sortedData.where((d) => d.dateCreated != null).toList();

    // Caso con un solo assessment: mostriamo un riepilogo testuale invece di un grafico vuoto
    if (validData.length == 1) {
      final single = validData.first;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: _cardDecoration(),
        child: Column(
          children: [
            Icon(Icons.insights_rounded, size: 40, color: _primaryBlue.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(
              "${single.globalReadinessScore.toStringAsFixed(1)}%",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: _primaryBlue),
            ),
            const SizedBox(height: 4),
            Text(
              "Readiness score for ${single.facilityName.isNotEmpty ? single.facilityName : 'this assessment'}",
              textAlign: TextAlign.center,
              style: TextStyle(color: _slateLight, fontWeight: FontWeight.w500, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Text(
              "Add more assessments to unlock trend analysis.",
              textAlign: TextAlign.center,
              style: TextStyle(color: _slateLight.withOpacity(0.6), fontSize: 11),
            ),
          ],
        ),
      );
    }

    if (validData.length < 2) {
      return _buildEmptyStateCard(
          "Not enough historical data for trend analysis. At least 2 assessments needed.");
    }

    List<FlSpot> spots = [];
    for (int i = 0; i < validData.length; i++) {
      spots.add(FlSpot(i.toDouble(), validData[i].globalReadinessScore));
    }

    // Periodo coperto dai dati
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
        // ── Grafico ──────────────────────────────────────────────────
        Container(
          height: isLandscape ? 260 : 380,
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
                // Nessuna etichetta sull'asse X: il grafico è pulitissimo.
                // La data compare nel tooltip al tocco.
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
              // TOOLTIP PREMIUM: score + nome facility + data
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => Colors.white,
                  tooltipBorderRadius: BorderRadius.circular(10),
                  tooltipBorder: BorderSide(color: Colors.grey.shade200, width: 1),
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final int index = spot.x.toInt();
                      final String name = index < validData.length
                          ? (validData[index].facilityName.isNotEmpty
                              ? validData[index].facilityName
                              : 'Assessment ${index + 1}')
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
                    getDotPainter: (spot, pct, bar, index) => FlDotCirclePainter(
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
                        _primaryBlue.withOpacity(0.18),
                        _primaryBlue.withOpacity(0.0),
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
        // ── Striscia periodo ────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 4),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 11, color: _slateLight.withOpacity(0.5)),
              const SizedBox(width: 5),
              Text(
                periodLabel,
                style: TextStyle(
                  fontSize: 11,
                  color: _slateLight.withOpacity(0.7),
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

  // Grafico a ragnatela per il confronto tra le diverse categorie tecniche
  Widget _buildRadarChartCard(List<FacilityLayout> allData, {bool isLandscape = false, bool isSmartphonePortrait = false}) {
    Map<AssessmentCategory, List<int>> categoryScores = {
      AssessmentCategory.infectionPreventionControl: [0, 0],
      AssessmentCategory.wash: [0, 0],
      AssessmentCategory.spatialLayout: [0, 0],
      AssessmentCategory.logistics: [0, 0],
    };

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
      height: isLandscape ? 280 : (isSmartphonePortrait ? 420 : 350),
      padding: const EdgeInsets.fromLTRB(52, 24, 52, 24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Expanded(
            child: RadarChart(
              RadarChartData(
                dataSets: [
                  RadarDataSet(
                    fillColor: _primaryBlue.withOpacity(0.2),
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
                          text: 'IPC\n${ipc.toStringAsFixed(0)}%',
                          angle: 0);
                    case 1:
                      return RadarChartTitle(
                          text: 'WASH\n${wash.toStringAsFixed(0)}%',
                          angle: 0);
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

  // STILI E WIDGET DI SUPPORTO
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

  // Gestione dello stato vuoto o mancanza di dati storici
  Widget _buildEmptyStateCard(String message) {
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

