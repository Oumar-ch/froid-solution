// ...existing code from monthly_intervention_chart.dart...
// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Widget d'affichage d'un graphique en barres pour le nombre d'interventions par mois.
/// Les couleurs, styles, coins arrondis et gradients respectent le thème.
class MonthlyInterventionChart extends StatelessWidget {
  final Map<String, int> monthlyData; // Exemple : {"Jan": 8, "Fév": 12, ...}

  const MonthlyInterventionChart({required this.monthlyData, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final gradientColors = [
      colorScheme.primary,
      colorScheme.primary.withOpacity(0.65),
    ];

    // Génération des barres
    final spots = monthlyData.entries.mapIndexed((i, e) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: e.value.toDouble(),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ],
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Activité Mensuelle",
                style: textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 210,
              child: BarChart(
                BarChartData(
                  barGroups: spots,
                  alignment: BarChartAlignment.spaceAround,
                  maxY:
                      ((monthlyData.values.reduce((a, b) => a > b ? a : b) *
                              1.25))
                          .toDouble(),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (v) => FlLine(
                      color: colorScheme.onSurface.withOpacity(0.055),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (v, meta) => Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: Text(
                            v > 0 ? v.toInt().toString() : "",
                            style: textTheme.bodyLarge!.copyWith(fontSize: 13),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        interval: 5,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (index, meta) {
                          if (index < 0 || index >= monthlyData.length) {
                            return const SizedBox();
                          }
                          return Text(
                            monthlyData.keys.elementAt(index.toInt()),
                            style: textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final key = monthlyData.keys.elementAt(group.x.toInt());
                        return BarTooltipItem(
                          "$key\n${rod.toY.toInt()} interventions",
                          textTheme.bodyLarge!,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension MapIndexed pour forEach avec index dans la génération des spots
extension _MapIndexed<K, V> on Iterable<MapEntry<K, V>> {
  Iterable<T> mapIndexed<T>(T Function(int, MapEntry<K, V>) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}
