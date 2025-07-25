// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:glass_kit/glass_kit.dart';
// ...existing code...

/// Widget graphique en courbes : évolution des interventions par semaine
import '../models/intervention_journalier.dart';

class InterventionEvolutionChart extends StatelessWidget {
  final List<InterventionDuJour> interventions;
  final Color neonColor;
  const InterventionEvolutionChart({
    required this.interventions,
    this.neonColor = const Color(0xFF00E6FF),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Filtrer les interventions du mois courant
    final now = DateTime.now();
    final currentMonthInterventions = interventions
        .where(
          (i) =>
              DateTime.tryParse(i.heure)?.month == now.month &&
              DateTime.tryParse(i.heure)?.year == now.year,
        )
        .toList();

    // Regrouper par jour du mois
    final Map<int, int> interventionsByDay = {};
    for (var i in currentMonthInterventions) {
      final date = DateTime.tryParse(i.heure);
      if (date != null) {
        interventionsByDay[date.day] = (interventionsByDay[date.day] ?? 0) + 1;
      }
    }
    final days = List<int>.generate(
      DateTime(now.year, now.month + 1, 0).day,
      (i) => i + 1,
    );
    final values = days.map((d) => interventionsByDay[d] ?? 0).toList();

    return GlassContainer(
      height: 320,
      width: double.infinity,
      borderRadius: BorderRadius.circular(32),
      blur: 16,
      gradient: LinearGradient(
        colors: [
          Colors.white.withAlpha((0.08 * 255).toInt()),
          neonColor.withAlpha((0.12 * 255).toInt()),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderWidth: 1.5,
      borderColor: neonColor.withAlpha((0.18 * 255).toInt()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx >= 0 && idx < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              days[idx].toString(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withAlpha(
                                  (0.8 * 255).toInt(),
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      interval: 1,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      values.length,
                      (i) => FlSpot(i.toDouble(), values[i].toDouble()),
                    ),
                    isCurved: true,
                    color: neonColor,
                    barWidth: 4,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: neonColor.withAlpha((0.18 * 255).toInt()),
                    ),
                    shadow: Shadow(blurRadius: 12, color: neonColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Évolution des interventions',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withAlpha((0.85 * 255).toInt()),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              shadows: [Shadow(blurRadius: 8, color: neonColor)],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
