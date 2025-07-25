import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_gradients.dart';
import '../../models/intervention_model.dart';
import '../../constants/intervention_constants.dart';

Color withAlpha(Color color, double opacity) {
  return color.withAlpha((opacity * 255).round());
}

/// Widget graphique radar pour visualiser la performance des techniciens (nombre d'interventions réalisées).
class TechnicianPerformanceChart extends StatelessWidget {
  final List<Intervention> interventions;
  final LinearGradient? gradient;
  final double glowRadius;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const TechnicianPerformanceChart({
    required this.interventions,
    this.gradient,
    this.glowRadius = 18,
    this.borderRadius = 24,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    // final colorScheme = theme.colorScheme; // supprimé car inutilisé
    final isDark = theme.brightness == Brightness.dark;
    // Calculer le nombre d'interventions réalisées par technicien
    final Map<String, int> doneByTechnician = {};
    for (var i in interventions) {
      if (i.status.label.toLowerCase().contains('termin')) {
        doneByTechnician[i.clientName] =
            (doneByTechnician[i.clientName] ?? 0) + 1;
      }
    }
    final labels = doneByTechnician.keys.toList();
    final values = doneByTechnician.values.map((v) => v.toDouble()).toList();
    final LinearGradient usedGradient =
        gradient ?? AppGradients.getNeonGradient(isDark);
    return Container(
      decoration: BoxDecoration(
        gradient: usedGradient,
        boxShadow: [
          BoxShadow(
            color: withAlpha(AppColors.getNeonColor(isDark), 0.5),
            blurRadius: glowRadius,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Performance des techniciens',
                style: textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      dataEntries: [for (var v in values) RadarEntry(value: v)],
                      borderColor: AppColors.getNeonColor(isDark),
                      fillColor: withAlpha(AppColors.getNeonColor(isDark), 0.3),
                    ),
                  ],
                  radarBackgroundColor: Colors.transparent,
                  titleTextStyle: textTheme.bodySmall,
                  getTitle: (idx, angle) => RadarChartTitle(text: labels[idx]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
