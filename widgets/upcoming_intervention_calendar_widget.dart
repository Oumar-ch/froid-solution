// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:froid_solution_service_technique/routes/app_routes.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/intervention_model.dart';
// ...existing code...
import '../constants/intervention_constants.dart';
import '../constants/app_dimensions.dart';
import '../themes/app_colors.dart';

class UpcomingInterventionCalendarWidget extends StatefulWidget {
  final List<Intervention> upcomingList;
  final LinearGradient? backgroundGradient;
  final LinearGradient? borderGradient;
  final Color? neonColor;
  final double borderRadius;
  final double blur;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  const UpcomingInterventionCalendarWidget({
    super.key,
    required this.upcomingList,
    this.backgroundGradient,
    this.borderGradient,
    this.neonColor,
    this.borderRadius = AppDimensions.borderRadiusLarge,
    this.blur = 18,
    this.borderWidth = 1.5,
    this.padding,
  });

  @override
  State<UpcomingInterventionCalendarWidget> createState() =>
      _UpcomingInterventionCalendarWidgetState();
}

class _UpcomingInterventionCalendarWidgetState
    extends State<UpcomingInterventionCalendarWidget> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final interventionsByDay = <DateTime, List<Intervention>>{};
    for (final i in widget.upcomingList) {
      final day = DateTime(
        i.installationDate.year,
        i.installationDate.month,
        i.installationDate.day,
      );
      interventionsByDay.putIfAbsent(day, () => []).add(i);
    }
    final neon = widget.neonColor ?? AppColors.darkNeon;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    return GlassmorphicContainer(
      width: double.infinity,
      height: AppDimensions.calendarHeight,
      borderRadius: widget.borderRadius,
      blur: widget.blur,
      border: widget.borderWidth,
      linearGradient:
          widget.backgroundGradient ??
          LinearGradient(
            colors: [surfaceColor.withAlpha(18), surfaceColor.withAlpha(7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
      borderGradient:
          widget.borderGradient ??
          LinearGradient(colors: [neon.withAlpha(80), Colors.transparent]),
      padding: widget.padding ?? EdgeInsets.all(AppDimensions.paddingLarge),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar<Intervention>(
              firstDay: DateTime.now().subtract(const Duration(days: 1)),
              lastDay: DateTime.now().add(const Duration(days: 60)),
              focusedDay: _selectedDate,
              calendarFormat: CalendarFormat.twoWeeks,
              eventLoader: (day) =>
                  interventionsByDay[DateTime(day.year, day.month, day.day)] ??
                  [],
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: neon.withOpacity(0.3),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: neon.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                selectedDecoration: BoxDecoration(
                  color: neon,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: neon.withOpacity(0.7),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                markerDecoration: BoxDecoration(
                  color: neon,
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() => _selectedDate = selectedDay);
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              DateFormat(
                'EEEE d MMMM yyyy',
                'fr_FR',
              ).format(_selectedDate).toUpperCase(),
              style: TextStyle(
                color: neon,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.1,
                shadows: [Shadow(color: neon.withOpacity(0.4), blurRadius: 8)],
              ),
            ),
            const SizedBox(height: 8),
            ...[
              for (final i
                  in interventionsByDay[DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                      )] ??
                      [])
                _InterventionGlassCard(intervention: i),
            ],
            if ((interventionsByDay[DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                    )] ??
                    [])
                .isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Aucune intervention prévue ce jour.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.programme),
                child: Text(
                  'Voir le planning complet',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InterventionGlassCard extends StatelessWidget {
  final Intervention intervention;
  const _InterventionGlassCard({required this.intervention});

  @override
  Widget build(BuildContext context) {
    final neon = Colors.cyanAccent;
    return GlassmorphicContainer(
      width: double.infinity,
      height: 90,
      borderRadius: 16,
      blur: 10,
      border: 1.2,
      linearGradient: LinearGradient(
        colors: [neon.withAlpha(18), neon.withAlpha(7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [neon.withAlpha(80), Colors.transparent],
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.event, color: neon, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  intervention.clientName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: neon,
                    fontSize: 15,
                  ),
                ),
                Text(
                  DateFormat('HH:mm').format(intervention.installationDate),
                  style: TextStyle(
                    color: neon.withAlpha(180),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  intervention.type.label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
