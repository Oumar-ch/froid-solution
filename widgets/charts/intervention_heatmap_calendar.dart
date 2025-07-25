// ...existing code from intervention_heatmap_calendar.dart...
// ignore_for_file: unintended_html_in_doc_comment, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// Affiche un calendrier heatmap des interventions, intégrant les couleurs du thème centralisé.
/// `interventionData` : Map<DateTime, int> où la valeur correspond au nombre d'interventions sur le jour.
class InterventionHeatMapCalendar extends StatelessWidget {
  final Map<DateTime, int> interventionData;
  final DateTime startDate;
  final DateTime endDate;
  final double borderRadius;
  final Gradient? gradient;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;

  const InterventionHeatMapCalendar({
    super.key,
    required this.interventionData,
    required this.startDate,
    required this.endDate,
    this.borderRadius = 24,
    this.gradient,
    this.border,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, int> interventionsByDay = {};
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient:
            gradient ??
            LinearGradient(
              colors: [
                Colors.white.withOpacity(0.18),
                Colors.white.withOpacity(0.07),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        border:
            border ??
            Border.all(color: Colors.blueAccent.withOpacity(0.7), width: 1.8),
      ),
      child: Padding(
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TableCalendar(
                firstDay: startDate,
                lastDay: endDate,
                focusedDay: startDate,
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final interventionsCount =
                        interventionsByDay[DateTime(
                          day.year,
                          day.month,
                          day.day,
                        )] ??
                        0;
                    return GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Interventions le ${day.day}/${day.month}/${day.year} : $interventionsCount',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: _getColor(interventionsCount),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blueAccent.withValues(alpha: 0.3),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: interventionsCount == 0
                                ? Colors.blueGrey
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  isTodayHighlighted: true,
                  todayDecoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 18 : 22,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.blueAccent,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _HeatmapLegend(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor(int count) {
    if (count == 0) return Colors.transparent;
    if (count <= 2) return Colors.greenAccent.shade200;
    if (count <= 5) return Colors.yellowAccent.shade400;
    if (count <= 7) return Colors.deepOrangeAccent.shade200;
    return Colors.redAccent.shade700;
  }
}

class _HeatmapLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendBox(color: Colors.transparent, label: '0'),
        _LegendBox(color: Colors.greenAccent, label: '1-2'),
        _LegendBox(color: Colors.yellowAccent, label: '3-5'),
        _LegendBox(color: Colors.deepOrangeAccent, label: '6-7'),
        _LegendBox(color: Colors.redAccent, label: '8+'),
        const SizedBox(width: 8),
        const Text(
          '= Nombre d’interventions',
          style: TextStyle(
            fontSize: 13,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _LegendBox extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendBox({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.4)),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.blueAccent),
        ),
      ],
    );
  }
}
