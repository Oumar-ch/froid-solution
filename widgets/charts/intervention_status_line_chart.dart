import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Widget graphique courbe pour visualiser l'évolution des statuts d'intervention.
class InterventionStatusLineChart extends StatelessWidget {
  final Map<String, List<int>> statusData; // {'Terminee': [5,8,6], ...}
  final List<String> months; // ['Jan', 'Fév', ...]
  final List<Color>? lineColors;
  final double lineWidth;
  final Gradient? backgroundGradient;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const InterventionStatusLineChart({
    required this.statusData,
    required this.months,
    this.lineColors,
    this.lineWidth = 3,
    this.backgroundGradient,
    this.borderRadius = 24,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final List<Color> usedLineColors =
        lineColors ??
        [
          colorScheme.primary,
          colorScheme.secondary,
          Colors.greenAccent,
          Colors.redAccent,
          Colors.orangeAccent,
        ];
    final List<LineChartBarData> lines = [];
    int colorIdx = 0;
    statusData.forEach((status, values) {
      lines.add(
        LineChartBarData(
          spots: [
            for (int i = 0; i < values.length; i++)
              FlSpot(i.toDouble(), values[i].toDouble()),
          ],
          isCurved: true,
          color: usedLineColors[colorIdx % usedLineColors.length],
          barWidth: lineWidth,
          dotData: FlDotData(show: false),
        ),
      );
      colorIdx++;
    });
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Évolution des statuts',
                  style: textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    lineBarsData: lines,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int idx = value.toInt();
                            if (idx < 0 || idx >= months.length) {
                              return const SizedBox();
                            }
                            return Text(
                              months[idx],
                              style: textTheme.bodySmall,
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
