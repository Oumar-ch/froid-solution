// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:glass_kit/glass_kit.dart';
// ...existing code...

/// Widget graphique camembert : répartition des types d'interventions
class InterventionTypePieChart extends StatelessWidget {
  final Map<String, double> data;
  final List<Color> colors;
  const InterventionTypePieChart({
    required this.data,
    this.colors = const [
      Color(0xFF00E6FF), // Néon bleu
      Color(0xFF00FFB2), // Néon vert
      Color(0xFFFFC800), // Néon jaune
      Color(0xFFFF3C6E), // Néon rose
    ],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<PieChartSectionData> sections = [];
    int i = 0;
    data.forEach((type, value) {
      sections.add(
        PieChartSectionData(
          value: value,
          color: colors[i % colors.length].withOpacity(0.85),
          title: '${value.toInt()}%',
          radius: 60,
          titleStyle: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(blurRadius: 8, color: colors[i % colors.length])],
          ),
          badgeWidget: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: colors[i % colors.length],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colors[i % colors.length].withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          badgePositionPercentageOffset: .98,
        ),
      );
      i++;
    });
    return GlassContainer(
      height: 320,
      width: double.infinity,
      borderRadius: BorderRadius.circular(32),
      blur: 16,
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.08),
          colors.first.withOpacity(0.12),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderWidth: 1.5,
      borderColor: colors.first.withOpacity(0.18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 38,
                sectionsSpace: 4,
                pieTouchData: PieTouchData(enabled: true),
                startDegreeOffset: -90,
              ),
              swapAnimationDuration: const Duration(milliseconds: 900),
              swapAnimationCurve: Curves.easeInOutCubic,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Répartition des types',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              shadows: [Shadow(blurRadius: 8, color: colors.first)],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            children: List.generate(data.length, (i) {
              final type = data.keys.elementAt(i);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colors[i % colors.length].withOpacity(0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    type,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
