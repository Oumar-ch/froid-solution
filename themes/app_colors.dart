// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// Constantes de couleurs pour une uniformisation complète
class AppColors {
  // COULEURS CRITIQUES POUR ALERTES
  static const Color criticalRed = Color(0xFFEF4444); // Rouge vif pour alertes
  static const Color criticalRedAccent =
      Color(0xFFFF1744); // Accent rouge pour bordures/effets
  AppColors._();

  // COULEURS DARK MODE
  static const Color darkBackground = Color(0xFF0A1329);
  static const Color darkSurface = Color(0xFF132F55);
  static const Color darkCard = Color(0xFF1E3A8A);
  static const Color darkNeon = Color(0xFF00FFFF);
  static const Color darkNeonGlow = Color(0xFF09FBD3);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0BEC5);

  // COULEURS LIGHT MODE (adoucies pour les yeux)
  static const Color lightBackground = Color(0xFFF8FAFC); // Bleu très pâle
  static const Color lightSurface = Color(0xFFE2E8F0); // Gris-bleu doux
  static const Color lightCard = Color(0xFFFFFFFF); // Blanc pur
  static const Color lightAccent = Color(0xFF0284C7); // Bleu doux et apaisant
  static const Color lightAccentGlow = Color(0xFF38BDF8); // Bleu clair lumineux
  static const Color lightText = Color(0xFF1E293B); // Gris foncé doux
  static const Color lightTextSecondary = Color(0xFF64748B); // Gris moyen

  // COULEURS PARTAGÉES
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // MÉTHODES D'AIDE
  static Color getNeonColor(bool isDark) {
    return isDark ? darkNeon : lightAccent;
  }

  static Color getBackgroundColor(bool isDark) {
    return isDark ? darkBackground : lightBackground;
  }

  static Color getSurfaceColor(bool isDark) {
    return isDark ? darkSurface : lightSurface;
  }

  static Color getCardColor(bool isDark) {
    return isDark ? darkCard : lightCard;
  }

  static Color getTextColor(bool isDark) {
    return isDark ? darkText : lightText;
  }

  static Color getTextSecondaryColor(bool isDark) {
    return isDark ? darkTextSecondary : lightTextSecondary;
  }
}

/// Styles de texte uniformes
class AppTextStyles {
  static TextStyle criticalTitle({bool isMobile = false}) {
    return TextStyle(
      fontFamily: 'Orbitron',
      fontSize: isMobile ? 18 : 22,
      fontWeight: FontWeight.bold,
      color: AppColors.criticalRedAccent,
      letterSpacing: 1.2,
    );
  }

  AppTextStyles._();

  static TextStyle title(bool isDark) {
    return TextStyle(
      fontFamily: 'Orbitron',
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.getNeonColor(isDark),
      letterSpacing: 2.5,
      shadows: [
        Shadow(
          blurRadius: 15,
          color: AppColors.getNeonColor(isDark).withOpacity(0.8),
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static TextStyle subtitle(bool isDark) {
    return TextStyle(
      fontFamily: 'Orbitron',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.getNeonColor(isDark),
    );
  }

  static TextStyle label(bool isDark) {
    return TextStyle(
      fontFamily: 'Orbitron',
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppColors.getNeonColor(isDark),
    );
  }

  static TextStyle body(bool isDark) {
    return TextStyle(
      fontSize: 14,
      color: AppColors.getTextColor(isDark),
    );
  }

  static TextStyle bodySecondary(bool isDark) {
    return TextStyle(
      fontSize: 14,
      color: AppColors.getTextSecondaryColor(isDark),
    );
  }
}

/// Décoration d'input uniforme
class AppInputDecorations {
  AppInputDecorations._();

  static InputDecoration neonField(String label, bool isDark) {
    final neonColor = AppColors.getNeonColor(isDark);

    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.label(isDark),
      filled: true,
      fillColor: isDark ? Colors.white10 : AppColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: neonColor, width: 1.3),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: neonColor, width: 1.3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: neonColor, width: 2.2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }

  static InputDecoration dropdown(String label, bool isDark) {
    return neonField(label, isDark);
  }
}
