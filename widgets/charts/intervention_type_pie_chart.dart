// ...existing code from intervention_type_pie_chart.dart...
// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Widget affichant en carte un graphique en anneau ("donut") représentant la répartition
/// des interventions par type.
/// Les couleurs, polices et coins arrondis respectent le thème centralisé.
class InterventionTypePieChart extends StatelessWidget {
  final Map<String, double>
  data; // Exemple : {"Maintenance": 15, "Réparation": 9}

  const InterventionTypePieChart({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Génère une liste de couleurs à partir du schéma du thème
    final List<Color> sectionColors = [
      colorScheme.primary,
      colorScheme.secondary.withOpacity(0.7),
      colorScheme.secondary.withOpacity(0.4),
      colorScheme.surface.withOpacity(0.9),
      colorScheme.surface,
    ];

    final total = data.values.fold<double>(0, (a, b) => a + b);
    // Construction des sections du graphique
    final List<PieChartSectionData> sections = [];
    final labels = data.keys.toList();
    for (int i = 0; i < data.length; i++) {
      sections.add(
        PieChartSectionData(
          value: data[labels[i]]!,
          color: sectionColors[i % sectionColors.length],
          showTitle: false,
          radius: 44,
        ),
      );
    }

    return Card(
      // Style depuis le cardTheme du thème centralisé
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Titre de la carte
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Répartition par Type",
                style: textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 54,
                      startDegreeOffset: -90,
                      sectionsSpace: 2,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                  // Total au centre de l'anneau
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${total.toInt()}", style: textTheme.displayLarge),
                      Text("Interventions", style: textTheme.bodyLarge),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Légende customisée sous le graphique
            Wrap(
              spacing: 18,
              runSpacing: 4,
              children: [
                for (int i = 0; i < labels.length; i++)
                  _LegendIndicator(
                    color: sectionColors[i % sectionColors.length],
                    label: labels[i],
                    value: data[labels[i]]!,
                    style: textTheme.bodyLarge!,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget de légende pour chaque catégorie du camembert.
class _LegendIndicator extends StatelessWidget {
  final Color color;
  final String label;
  final double value;
  final TextStyle style;

  const _LegendIndicator({
    required this.color,
    required this.label,
    required this.value,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: style),
        const SizedBox(width: 6),
        Text(
          "(${value.toInt()})",
          style: style.copyWith(color: style.color?.withOpacity(0.65)),
        ),
      ],
    );
  }
}
