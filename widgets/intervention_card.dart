// ignore_for_file: deprecated_member_use, prefer_adjacent_string_concatenation, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/intervention_model.dart';
import '../constants/intervention_constants.dart';
import '../utils/responsive.dart';
// ...existing code...
import 'package:intl/intl.dart';

class InterventionCard extends StatelessWidget {
  final Intervention intervention;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double borderRadius;
  final double blur;
  final double border;
  final LinearGradient? gradient;
  final LinearGradient? borderGradient;
  final EdgeInsetsGeometry? margin;
  const InterventionCard({
    super.key,
    required this.intervention,
    required this.onEdit,
    required this.onDelete,
    this.borderRadius = 18,
    this.blur = 10,
    this.border = 1.2,
    this.gradient,
    this.borderGradient,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    // ...existing code...
    return GlassmorphicContainer(
      margin: EdgeInsets.symmetric(
        vertical: Responsive.isMobile(context) ? 10 : 18,
        horizontal: Responsive.isMobile(context) ? 8 : 18,
      ),
      borderRadius: borderRadius,
      blur: blur,
      alignment: Alignment.center,
      border: border,
      linearGradient:
          gradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueAccent.withOpacity(0.13),
              Colors.blueAccent.withOpacity(0.07),
            ],
          ),
      borderGradient:
          borderGradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueAccent.withOpacity(0.35), Colors.transparent],
          ),
      constraints: BoxConstraints(
        minHeight: Responsive.isMobile(context) ? 100 : 140,
        maxHeight: double.infinity,
      ),
      height: Responsive.isMobile(context)
          ? 140
          : (Responsive.isTablet(context) ? 180 : 220),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(
          vertical: Responsive.isMobile(context) ? 16 : 24,
          horizontal: Responsive.isMobile(context) ? 18 : 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              intervention.clientName,
              style: TextStyle(
                color: Colors.cyanAccent.shade400,
                fontSize: Responsive.font(context, 18),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.cyanAccent.shade400,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 4 : 10),
            Text(
              "Type : ${intervention.type.label}",
              style: TextStyle(
                color: Colors.cyanAccent.shade400.withOpacity(0.8),
                fontSize: Responsive.font(context, 15),
              ),
            ),
            Text(
              "Statut : ${intervention.status.label}",
              style: TextStyle(
                color: Colors.cyanAccent.shade400.withOpacity(0.8),
                fontSize: Responsive.font(context, 15),
              ),
            ),
            if (intervention.description.isNotEmpty)
              Text(
                "Description : ${intervention.description}",
                style: TextStyle(
                  color: Colors.cyanAccent.shade400.withOpacity(0.7),
                  fontSize: Responsive.font(context, 14),
                ),
              ),
            SizedBox(height: Responsive.isMobile(context) ? 6 : 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: Responsive.isMobile(context) ? 17 : 22,
                  color: Colors.cyanAccent.shade400,
                ),
                SizedBox(width: Responsive.isMobile(context) ? 6 : 12),
                Text(
                  "Installation : ${DateFormat.yMd('fr').format(intervention.installationDate)}",
                  style: TextStyle(fontSize: Responsive.font(context, 13)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyanAccent.shade400,
                    size: Responsive.isMobile(context) ? 22 : 28,
                  ),
                  tooltip: 'Modifier',
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.redAccent.shade200,
                    size: Responsive.isMobile(context) ? 22 : 28,
                  ),
                  tooltip: 'Supprimer',
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
