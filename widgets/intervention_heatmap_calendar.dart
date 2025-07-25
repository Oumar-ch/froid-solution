import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
// ...existing code...
import '../models/intervention_model.dart';

// ignore: unintended_html_in_doc_comment
/// Génère le Map<DateTime, int> pour la heatmap à partir d'une liste d'interventions
Map<DateTime, int> generateInterventionData(List<Intervention> interventions) {
  final Map<DateTime, int> data = {};
  for (var i in interventions) {
    final date = DateTime(
      i.installationDate.year,
      i.installationDate.month,
      i.installationDate.day,
    );
    data[date] = (data[date] ?? 0) + 1;
  }
  return data;
}

/// Widget Heatmap calendrier des interventions
class InterventionHeatMapCalendar extends StatelessWidget {
  final Map<DateTime, int> interventionData;
  final DateTime startDate;
  final DateTime endDate;
  const InterventionHeatMapCalendar({
    required this.interventionData,
    required this.startDate,
    required this.endDate,
    super.key,
  });

  Color _getColor(int? value) {
    if (value == null || value == 0) return Colors.transparent;
    if (value < 3) return Colors.greenAccent.withAlpha((0.7 * 255).toInt());
    if (value < 6) return Colors.yellowAccent.withAlpha((0.8 * 255).toInt());
    if (value < 9) return Colors.orangeAccent.withAlpha((0.85 * 255).toInt());
    return Colors.redAccent.withAlpha((0.9 * 255).toInt());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      height: 340,
      width: double.infinity,
      borderRadius: BorderRadius.circular(32),
      blur: 16,
      gradient: LinearGradient(
        colors: [
          Colors.white.withAlpha((0.08 * 255).toInt()),
          Colors.redAccent.withAlpha((0.12 * 255).toInt()),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderWidth: 1.5,
      borderColor: Colors.redAccent.withAlpha((0.18 * 255).toInt()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: HeatMapCalendar(
              flexible: true,
              colorMode: ColorMode.color,
              datasets: interventionData,
              colorTipCount: 10,
              colorsets: {
                0: Colors.transparent,
                1: Colors.greenAccent.withAlpha((0.7 * 255).toInt()),
                3: Colors.yellowAccent.withAlpha((0.8 * 255).toInt()),
                6: Colors.orangeAccent.withAlpha((0.85 * 255).toInt()),
                9: Colors.redAccent.withAlpha((0.9 * 255).toInt()),
              },
              onClick: (date) {
                final interventions = interventionData[date] ?? 0;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Interventions du ${date.day}/${date.month}/${date.year} ($interventions)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: _getColor(interventions),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Calendrier des interventions',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withAlpha((0.85 * 255).toInt()),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              shadows: [Shadow(blurRadius: 8, color: Colors.redAccent)],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendColor(Colors.transparent, '0'),
              _legendColor(Colors.greenAccent, '1-2'),
              _legendColor(Colors.yellowAccent, '3-5'),
              _legendColor(Colors.orangeAccent, '6-8'),
              _legendColor(Colors.redAccent, '9+'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendColor(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha((0.5 * 255).toInt()),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
