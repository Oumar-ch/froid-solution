// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
// ...existing code...
import '../models/intervention_model.dart';
import '../constants/intervention_constants.dart';

/// Widget : suivi des interventions en cours avec barre de progression
class CurrentInterventionsProgressWidget extends StatelessWidget {
  final List<Intervention> currentList;
  const CurrentInterventionsProgressWidget({
    required this.currentList,
    super.key,
  });

  Color _getProgressColor(double percent) {
    if (percent < 0.5) return Colors.redAccent;
    if (percent < 0.8) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  double _getPercent(Intervention i) {
    // À adapter selon la logique métier :
    // Par exemple, si status == terminee => 1.0, enCours => 0.5, autre => 0.0
    if (i.status == InterventionStatus.terminee) return 1.0;
    if (i.status == InterventionStatus.enCours) return 0.5;
    return 0.0;
  }

  String _getStartTime(Intervention i) {
    // Utilise la date ou installationDate comme heure de début
    return i.date.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("🔧 Interventions en cours", style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        ...currentList.map(
          (i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: GlassContainer(
              height: 80,
              width: double.infinity,
              borderRadius: BorderRadius.circular(24),
              blur: 12,
              borderWidth: 1.2,
              borderColor: _getProgressColor(_getPercent(i)).withOpacity(0.3),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.13),
                  Colors.white.withOpacity(0.07),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${i.clientName} - ${i.type.label}",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Début : ${_getStartTime(i)}",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  CircularProgressIndicator(
                    value: _getPercent(i),
                    strokeWidth: 6,
                    color: _getProgressColor(_getPercent(i)),
                    backgroundColor: Colors.white.withOpacity(0.12),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "${(_getPercent(i) * 100).toInt()}%",
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
