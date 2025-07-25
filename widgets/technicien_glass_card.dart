// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/technicien.dart';
import '../themes/app_colors.dart';
import '../utils/responsive.dart';

class TechnicienGlassCard extends StatelessWidget {
  final Technicien technicien;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;
  final double borderRadius;
  final double blur;
  final double border;
  final LinearGradient? gradient;
  final LinearGradient? borderGradient;
  final Color? neonColor;
  final EdgeInsetsGeometry? margin;
  const TechnicienGlassCard({
    super.key,
    required this.technicien,
    required this.onDelete,
    this.onEdit,
    this.borderRadius = 18,
    this.blur = 10,
    this.border = 1.2,
    this.gradient,
    this.borderGradient,
    this.neonColor,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = neonColor ?? AppColors.getNeonColor(isDark);
    return GlassmorphicContainer(
      borderRadius: borderRadius,
      blur: blur,
      alignment: Alignment.center,
      border: border,
      linearGradient:
          gradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [neon.withOpacity(0.13), neon.withOpacity(0.07)],
          ),
      borderGradient:
          borderGradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [neon.withOpacity(0.35), neon.withOpacity(0.10)],
          ),
      height: Responsive.isMobile(context)
          ? 90
          : (Responsive.isTablet(context) ? 120 : 140),
      width: double.infinity,
      margin:
          margin ??
          EdgeInsets.symmetric(
            vertical: Responsive.isMobile(context) ? 8 : 16,
            horizontal: Responsive.isMobile(context) ? 0 : 12,
          ),
      child: ListTile(
        title: Text(
          technicien.nom,
          style: TextStyle(
            color: neon,
            fontFamily: 'Orbitron',
            fontWeight: FontWeight.bold,
            fontSize: Responsive.font(context, 18),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Téléphone: ${technicien.numero}',
              style: TextStyle(fontSize: Responsive.font(context, 13)),
            ),
            Text(
              'Adresse: ${technicien.adresse}',
              style: TextStyle(fontSize: Responsive.font(context, 13)),
            ),
            Text(
              'Habilitation: ${technicien.habilitation}',
              style: TextStyle(fontSize: Responsive.font(context, 13)),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: neon,
                  size: Responsive.isMobile(context) ? 22 : 28,
                ),
                onPressed: onEdit,
              ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: AppColors.error,
                size: Responsive.isMobile(context) ? 22 : 28,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
