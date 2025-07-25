// ignore_for_file: unnecessary_import, deprecated_member_use

import 'package:flutter/material.dart';
import '../models/intervention_model.dart';
import '../constants/intervention_constants.dart';
import '../services/database_service.dart';
import '../themes/app_colors.dart';
import '../utils/app_logger.dart';
import '../utils/responsive.dart';
import '../widgets/glass_reminder_card.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<_ReminderEntry> _reminders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() => _loading = true);
    final interventions = await DataService.getInterventions();
    final now = DateTime.now();

    const daysBeforeReminder = 7;
    final List<_ReminderEntry> reminders = [];
    for (final inter in interventions) {
      // La date de maintenance prévue est 3 mois après la date de l'intervention
      final maintenanceDate = addMonths(inter.date, 3);
      final daysBefore = maintenanceDate.difference(now).inDays;

      // On ne peut pas vérifier completedDates, donc on affiche toujours si la date est à venir
      if (daysBefore <= daysBeforeReminder) {
        reminders.add(_ReminderEntry(
          client: '', // Pas de champ clientName
          type: inter.type.label,
          dueDate: maintenanceDate,
          daysLeft: daysBefore,
          intervention: inter,
        ));
      }
    }
    setState(() {
      _reminders = reminders;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = AppColors.getNeonColor(isDark);
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _reminders.length,
            itemBuilder: (context, index) {
              final entry = _reminders[index];
              final urgent = entry.daysLeft <= 2 ? AppColors.error : neon;
              return GlassReminderCard(
                margin: Responsive.symmetricPadding(context),
                height: Responsive.isMobile(context)
                    ? 110
                    : (Responsive.isTablet(context) ? 130 : 150),
                child: SizedBox(
                  height: Responsive.isMobile(context)
                      ? 110
                      : (Responsive.isTablet(context) ? 130 : 150),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.notifications_active_rounded,
                                color: urgent,
                                size: Responsive.isMobile(context) ? 28 : 36),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(entry.client,
                                      style: AppTextStyles.label(isDark)
                                          .copyWith(
                                              fontSize:
                                                  Responsive.font(context, 15),
                                              fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 1),
                                  Text(
                                    'À faire pour le ${entry.dueDate.day.toString().padLeft(2, '0')}/${entry.dueDate.month.toString().padLeft(2, '0')}/${entry.dueDate.year}',
                                    style: AppTextStyles.body(isDark).copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Responsive.font(context, 12)),
                                  ),
                                  const SizedBox(height: 1),
                                  Text('Type:  {entry.type}',
                                      style: AppTextStyles.body(isDark)
                                          .copyWith(
                                              fontSize: Responsive.font(
                                                  context, 12))),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      Responsive.isMobile(context) ? 8 : 14,
                                  vertical:
                                      Responsive.isMobile(context) ? 4 : 8),
                              decoration: BoxDecoration(
                                color: urgent.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                entry.daysLeft > 0
                                    ? 'J-${entry.daysLeft}'
                                    : (entry.daysLeft == 0
                                        ? 'Aujourd\'hui'
                                        : 'En retard'),
                                style: AppTextStyles.body(isDark).copyWith(
                                    color: urgent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.font(context, 12)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.check,
                                    size:
                                        Responsive.isMobile(context) ? 16 : 22),
                                label: Text('Valider',
                                    style: TextStyle(
                                        fontSize:
                                            Responsive.font(context, 12))),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(
                                      Responsive.isMobile(context) ? 70 : 100,
                                      Responsive.isMobile(context) ? 28 : 36),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                ),
                                onPressed: () async {
                                  await DataService.setStatus(
                                      int.tryParse(entry.intervention.id) ?? 0,
                                      'validée');
                                  await DataService.addInterventionEvent(
                                    interventionId:
                                        int.tryParse(entry.intervention.id) ??
                                            0,
                                    eventType: 'validation',
                                    status: 'validée',
                                    eventDate: DateTime.now(),
                                  );
                                  AppLogger.log(
                                      'Intervention \\${entry.intervention.id} validée par utilisateur.');
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Intervention validée.')),
                                  );
                                  await _loadReminders();
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.close,
                                    size:
                                        Responsive.isMobile(context) ? 16 : 22),
                                label: Text('Non validée',
                                    style: TextStyle(
                                        fontSize:
                                            Responsive.font(context, 12))),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(
                                      Responsive.isMobile(context) ? 80 : 110,
                                      Responsive.isMobile(context) ? 28 : 36),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                ),
                                onPressed: () async {
                                  await DataService.setStatus(
                                      int.tryParse(entry.intervention.id) ?? 0,
                                      'non validée');
                                  await DataService.addInterventionEvent(
                                    interventionId:
                                        int.tryParse(entry.intervention.id) ??
                                            0,
                                    eventType: 'refus',
                                    status: 'non validée',
                                    eventDate: DateTime.now(),
                                  );
                                  AppLogger.log(
                                      'Intervention \\${entry.intervention.id} refusée par utilisateur.');
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Intervention non validée.')),
                                  );
                                  await _loadReminders();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }, // itemBuilder
          ); // ListView.builder
  }
}

class _ReminderEntry {
  final String client;
  final String type;
  final DateTime dueDate;
  final int daysLeft;
  final Intervention intervention;
  _ReminderEntry({
    required this.client,
    required this.type,
    required this.dueDate,
    required this.daysLeft,
    required this.intervention,
  });
}

/// Ajoute [months] mois à une date, en gérant correctement les dépassements de mois/année.
DateTime addMonths(DateTime date, int months) {
  int year = date.year + ((date.month - 1 + months) ~/ 12);
  int month = ((date.month - 1 + months) % 12) + 1;
  int day = date.day;
  // Gérer les jours qui n'existent pas dans le nouveau mois
  int lastDayOfMonth = DateTime(year, month + 1, 0).day;
  if (day > lastDayOfMonth) day = lastDayOfMonth;
  return DateTime(year, month, day);
}
