// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart' as widgets;
import 'package:fl_chart/fl_chart.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/intervention_model.dart';
import '../constants/intervention_constants.dart';
// ...existing code...

class PlannedVsCompletedChart extends widgets.StatefulWidget {
  final List<Intervention> interventions;
  const PlannedVsCompletedChart({
    super.key,
    required List<Intervention>? interventions,
  }) : interventions = interventions ?? const [];

  @override
  widgets.State<PlannedVsCompletedChart> createState() =>
      _PlannedVsCompletedChartState();
}

class _PlannedVsCompletedChartState
    extends widgets.State<PlannedVsCompletedChart>
    with widgets.SingleTickerProviderStateMixin {
  late final widgets.AnimationController _animationController;
  late final widgets.Animation<double> _animation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = widgets.AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = widgets.CurvedAnimation(
      parent: _animationController,
      curve: widgets.Curves.easeInOut,
    );
    _animationController.forward();
    _isAnimating = true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  widgets.Widget build(widgets.BuildContext context) {
    // Extract data from interventions
    final interventions = widget.interventions;
    final clientNames = interventions.map((i) => i.clientName).toList();
    // Placeholder: planned = 1 for each intervention (or replace with real logic if available)
    // Extraire les données réelles du modèle Intervention
    final planned = interventions
        .map((i) => i.installationDate.isAfter(DateTime.now()) ? 1 : 0)
        .toList();
    // Réalisées : status = terminé
    final done = interventions
        .map((i) => i.status.label.toLowerCase().contains('termin') ? 1 : 0)
        .toList();
    final maxY =
        ([
                  ...planned,
                  ...done,
                ].fold<int>(0, (prev, el) => el > prev ? el : prev) +
                2)
            .toDouble();
    final isMobile = widgets.MediaQuery.of(context).size.width < 600;
    final chartWidth = isMobile ? 320.0 : 420.0;
    final chartHeight = isMobile ? 180.0 : 240.0;
    final neonPlanned = widgets.Colors.cyanAccent.shade400;
    final neonDone = widgets.Colors.greenAccent.shade400;
    return GlassmorphicContainer(
      width: chartWidth,
      height: chartHeight + 60,
      borderRadius: 24,
      blur: 18,
      border: 1.8,
      linearGradient: widgets.LinearGradient(
        colors: [
          widgets.Colors.white.withOpacity(0.18),
          widgets.Colors.white.withOpacity(0.07),
        ],
        begin: widgets.Alignment.topLeft,
        end: widgets.Alignment.bottomRight,
      ),
      borderGradient: widgets.LinearGradient(
        colors: [neonPlanned.withOpacity(0.7), widgets.Colors.transparent],
      ),
      child: widgets.SingleChildScrollView(
        child: widgets.Column(
          mainAxisAlignment: widgets.MainAxisAlignment.center,
          children: [
            widgets.SizedBox(
              height: chartHeight,
              width: chartWidth,
              child: widgets.AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return BarChart(
                    BarChartData(
                      minY: 0,
                      maxY: maxY,
                      barGroups: List.generate(
                        clientNames.length,
                        (i) => BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: _isAnimating
                                  ? (planned[i] * _animation.value)
                                        .round()
                                        .toDouble()
                                  : planned[i].toDouble(),
                              color: neonPlanned,
                              width: 14,
                              borderRadius: widgets.BorderRadius.circular(6),
                            ),
                            BarChartRodData(
                              toY: _isAnimating
                                  ? (done[i] * _animation.value)
                                        .round()
                                        .toDouble()
                                  : done[i].toDouble(),
                              color: neonDone,
                              width: 14,
                              borderRadius: widgets.BorderRadius.circular(6),
                            ),
                          ],
                          showingTooltipIndicators: [0, 1],
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) => widgets.Text(
                              value.toInt().toString(),
                              style: const widgets.TextStyle(
                                color: widgets.Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= clientNames.length) {
                                return const widgets.SizedBox.shrink();
                              }
                              return widgets.Text(
                                clientNames[idx],
                                style: const widgets.TextStyle(
                                  color: widgets.Colors.white70,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                    ),
                  );
                },
              ),
            ),
            const widgets.SizedBox(height: 8),
            widgets.Row(
              mainAxisAlignment: widgets.MainAxisAlignment.center,
              children: [
                widgets.Container(
                  width: 16,
                  height: 16,
                  decoration: widgets.BoxDecoration(
                    color: neonPlanned,
                    borderRadius: widgets.BorderRadius.circular(4),
                  ),
                ),
                const widgets.SizedBox(width: 6),
                widgets.Text(
                  'Planifiées',
                  style: const widgets.TextStyle(color: widgets.Colors.white70),
                ),
                const widgets.SizedBox(width: 16),
                widgets.Container(
                  width: 16,
                  height: 16,
                  decoration: widgets.BoxDecoration(
                    color: neonDone,
                    borderRadius: widgets.BorderRadius.circular(4),
                  ),
                ),
                const widgets.SizedBox(width: 6),
                widgets.Text(
                  'Terminées',
                  style: const widgets.TextStyle(color: widgets.Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
