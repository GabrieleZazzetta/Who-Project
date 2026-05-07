import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/assessment_models.dart';

class AdvancedAnalyticsScreen extends StatelessWidget {
  final List<FacilityLayout> data;

  const AdvancedAnalyticsScreen({super.key, required this.data});

  // CONFIGURAZIONE E TEMA
  final Color _primaryBlue = const Color(0xFF005DA8);
  final Color _slateDark = const Color(0xFF1E293B);
  final Color _slateLight = const Color(0xFF64748B);

  // LOGICA DI COSTRUZIONE DELL'INTERFACCIA
  @override
  Widget build(BuildContext context) {
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Readiness Trend",
                      "Evolution of the global score over time"),
                  _buildLineChartCard(sortedData),
                  const SizedBox(height: 32),
                  _buildSectionHeader("Multidimensional Performance",
                      "Balance across technical pillars"),
                  _buildRadarChartCard(data),
                  const SizedBox(height: 40),
                ],
              ),
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
  Widget _buildLineChartCard(List<FacilityLayout> sortedData) {
    final validData = sortedData.where((d) => d.dateCreated != null).toList();

    if (validData.length < 2) {
      return _buildEmptyStateCard(
          "Not enough historical data for trend analysis. At least 2 assessments needed.");
    }

    List<FlSpot> spots = [];
    for (int i = 0; i < validData.length; i++) {
      spots.add(FlSpot(i.toDouble(), validData[i].globalReadinessScore));
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
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
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < validData.length) {
                    if (index == 0 ||
                        index == validData.length - 1 ||
                        validData.length < 6) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat('MMM dd')
                              .format(validData[index].dateCreated!),
                          style: TextStyle(
                              color: _slateLight,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 20,
                getTitlesWidget: (value, meta) => Text("${value.toInt()}%",
                    style: TextStyle(color: _slateLight, fontSize: 10)),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (validData.length - 1).toDouble(),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: _primaryBlue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: _primaryBlue.withOpacity(0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Grafico a ragnatela per il confronto tra le diverse categorie tecniche
  Widget _buildRadarChartCard(List<FacilityLayout> allData) {
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
      height: 350,
      padding: const EdgeInsets.all(24),
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
                          angle: angle);
                    case 1:
                      return RadarChartTitle(
                          text: 'WASH\n${wash.toStringAsFixed(0)}%',
                          angle: angle);
                    case 2:
                      return RadarChartTitle(
                          text: 'LAYOUT\n${layout.toStringAsFixed(0)}%',
                          angle: angle);
                    case 3:
                      return RadarChartTitle(
                          text: 'LOGISTICS\n${logistics.toStringAsFixed(0)}%',
                          angle: angle);
                    default:
                      return const RadarChartTitle(text: '');
                  }
                },
                titleTextStyle: TextStyle(
                    color: _slateDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w800),
              ),
              swapAnimationDuration: const Duration(milliseconds: 400),
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

