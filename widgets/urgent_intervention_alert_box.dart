// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:froid_solution_service_technique/routes/app_routes.dart';
import '../constants/intervention_constants.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../models/intervention_model.dart';

import '../constants/app_dimensions.dart';
import '../themes/app_colors.dart';
import '../constants/app_icons.dart';

class UrgentInterventionAlertBox extends StatelessWidget {
  final List<Intervention> urgentList;
  final double borderRadius;
  final double blur;
  final double border;
  final LinearGradient? gradient;
  final LinearGradient? borderGradient;
  final Color? alertColor;
  final EdgeInsetsGeometry? padding;
  const UrgentInterventionAlertBox({
    super.key,
    required this.urgentList,
    this.borderRadius = AppDimensions.borderRadiusLarge,
    this.blur = 18,
    this.border = 1.8,
    this.gradient,
    this.borderGradient,
    this.alertColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final maxHeight =
        MediaQuery.of(context).size.height * (isMobile ? 0.45 : 0.38);
    final color = alertColor ?? AppColors.criticalRed;
    return GlassmorphicContainer(
      width: double.infinity,
      height: maxHeight,
      borderRadius: borderRadius,
      blur: blur,
      border: border,
      linearGradient:
          gradient ??
          LinearGradient(
            colors: [color.withAlpha(40), color.withAlpha(20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
      borderGradient:
          borderGradient ??
          LinearGradient(
            colors: [
              AppColors.criticalRedAccent.withAlpha(80),
              Colors.transparent,
            ],
          ),
      padding: padding ?? EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚠️ INTERVENTIONS CRITIQUES',
            style: AppTextStyles.criticalTitle(isMobile: isMobile),
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Expanded(
            child: urgentList.isEmpty
                ? Center(
                    child: Text(
                      'Aucune intervention critique',
                      style: TextStyle(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: urgentList.length,
                    itemBuilder: (context, idx) =>
                        _GlowCard(intervention: urgentList[idx]),
                  ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.interventions);
              },
              child: const Text(
                'Voir tout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCard extends StatelessWidget {
  final Intervention intervention;
  const _GlowCard({required this.intervention});

  bool get isLate {
    final now = DateTime.now();
    return intervention.installationDate.isBefore(now) &&
        intervention.status == InterventionStatus.terminee;
  }

  bool get isUrgent {
    // On considère "urgent" si le statut est urgent ou si le type est dépannage ou autre
    return intervention.status == InterventionStatus.urgent ||
        intervention.type == InterventionType.depannage ||
        intervention.type == InterventionType.autre;
  }

  @override
  Widget build(BuildContext context) {
    final color = isUrgent
        ? AppColors.warning
        : (isLate ? AppColors.error : AppColors.warning);
    final icon = isUrgent
        ? AppIcons.warning
        : (isLate ? AppIcons.clock : AppIcons.info);

    return GlassmorphicContainer(
          width: double.infinity,
          height: AppDimensions.alertCardHeight,
          borderRadius: AppDimensions.borderRadiusMedium,
          blur: 10,
          border: 1.2,
          linearGradient: LinearGradient(
            colors: [color.withAlpha(40), color.withAlpha(20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderGradient: LinearGradient(
            colors: [color.withAlpha(120), Colors.transparent],
          ),
          margin: EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: Row(
            children: [
              Icon(icon, color: color, size: AppDimensions.iconSizeLarge),
              SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intervention.clientName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: AppDimensions.fontSizeLarge,
                        ),
                      ),
                      Text(
                        intervention.type.label,
                        style: TextStyle(
                          color: color.withAlpha(180),
                          fontWeight: FontWeight.w500,
                          fontSize: AppDimensions.fontSizeMedium,
                        ),
                      ),
                      Text(
                        'Prévue : ${DateFormat('dd/MM/yyyy').format(intervention.installationDate)}',
                        style: TextStyle(
                          color: AppColors.darkTextSecondary,
                          fontSize: AppDimensions.fontSizeSmall,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        'Statut : ${intervention.status.label}',
                        style: TextStyle(
                          color: AppColors.darkTextSecondary,
                          fontSize: AppDimensions.fontSizeSmall,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .shimmer(
          color: color,
          duration: const Duration(milliseconds: 1200),
          angle: 0.2,
        );
  }
}
