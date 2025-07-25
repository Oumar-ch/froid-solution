// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:glass_kit/glass_kit.dart';
// ...existing code...

/// Widget graphique mensuel : évolution des interventions par mois
class MonthlyInterventionChart extends StatelessWidget {
  final Map<String, int> monthlyData;
  final List<Color> lineColors;
  const MonthlyInterventionChart({
    required this.monthlyData,
    this.lineColors = const [
      Color(0xFF00E6FF), // Néon bleu
      Color(0xFFFFC800), // Néon jaune
    ],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final months = monthlyData.keys.toList();
    final values = monthlyData.values.toList();
    return GlassContainer(
      height: 320,
      width: double.infinity,
      borderRadius: BorderRadius.circular(32),
      blur: 16,
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.08),
          lineColors.first.withOpacity(0.12),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderWidth: 1.5,
      borderColor: lineColors.first.withOpacity(0.18),
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
                        if (idx >= 0 && idx < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              months[idx],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.8),
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
                    color: lineColors.first,
                    barWidth: 4,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: lineColors.first.withOpacity(0.18),
                    ),
                    shadow: const Shadow(
                      blurRadius: 12,
                      color: Color(0xFF00E6FF),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Interventions mensuelles',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              shadows: [Shadow(blurRadius: 8, color: lineColors.first)],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
