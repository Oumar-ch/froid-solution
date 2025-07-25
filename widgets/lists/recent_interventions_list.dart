// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import '../../models/intervention_model.dart';
import '../../constants/intervention_constants.dart';
// ...existing code...
import '../../themes/app_colors.dart';
import 'package:intl/intl.dart';

/// Widget affichant la liste des interventions récentes,
/// chaque ligne est posée en carte stylisée selon la charte graphique centrale.
class RecentInterventionsList extends StatelessWidget {
  final List<Intervention> interventions;
  final double borderRadius;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;

  const RecentInterventionsList({
    required this.interventions,
    this.borderRadius = 24,
    this.gradient,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    // ...existing code...
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Interventions récentes',
                  style: textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 12),
              if (interventions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Text(
                    'Aucune intervention récente.',
                    style: textTheme.bodyLarge,
                  ),
                )
              else
                ListView.separated(
                  itemCount: interventions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final intervention = interventions[index];
                    return _InterventionCard(intervention: intervention);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Carte stylisée pour afficher une intervention récente avec statut, type et date.
class _InterventionCard extends StatelessWidget {
  final Intervention intervention;

  const _InterventionCard({required this.intervention});

  Color _statusColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Utilise AppColors pour centraliser les couleurs
    switch (intervention.status) {
      case InterventionStatus.terminee:
        return AppColors.success;
      case InterventionStatus.enCours:
        return scheme.primary;
      case InterventionStatus.reporte:
        return AppColors.warning;
      case InterventionStatus.urgent:
        return AppColors.error;
      default:
        return scheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero, // le parent Card gère les marges globales
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface.withOpacity(0.92),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        child: Row(
          children: [
            // Indicateur de statut
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _statusColor(context),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            // Détail
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    intervention.type.label,
                    style: textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Statut : ${intervention.status.label}',
                    style: textTheme.bodyMedium,
                  ),
                  if (intervention.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        intervention.description,
                        style: textTheme.bodyLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Date
            Text(
              DateFormat.yMd(
                Localizations.localeOf(context).languageCode,
              ).format(intervention.date),
              style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
