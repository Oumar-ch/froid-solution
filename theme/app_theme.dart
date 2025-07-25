import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Classe de thémification centralisée pour l'application.
///
/// Contient les définitions pour le thème clair et le thème sombre,
/// en s'assurant que l'interface utilisateur est cohérente avec la charte graphique.
class AppTheme {
  AppTheme._(); // Constructeur privé pour empêcher l'instanciation

  // ===========================================================================
  // == Palette de Couleurs
  // ==========================================================================='

  // --- Couleurs du Mode Sombre ---
  static const Color _darkPrimaryBackground = Color(0xFF0D1333);
  static const Color _darkSecondaryBackground = Color(0xFF232949);
  static const Color _darkPrimaryText = Color(0xFFFFFFFF);
  static const Color _darkSecondaryText = Color(0xFFA7A9BE);
  static const Color _darkAccent = Color(0xFF4A80F0);

  // --- Couleurs du Mode Clair ---
  static const Color _lightPrimaryBackground = Color(0xFFF7F8FC);
  static const Color _lightSecondaryBackground = Color(0xFFFFFFFF);
  static const Color _lightPrimaryText = Color(0xFF0D1333);
  static const Color _lightSecondaryText = Color(0xFF6B6D81);
  static const Color _lightAccent = Color(0xFF4A80F0); // Inchangé

  // ===========================================================================
  // == Thème Sombre (Dark Mode)
  // ==========================================================================='

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.poppins().fontFamily,
    scaffoldBackgroundColor: _darkPrimaryBackground,
    primaryColor: _darkAccent,

    // --- Schéma de couleurs ---
    colorScheme: const ColorScheme.dark(
      primary: _darkAccent,
      secondary: _darkAccent,
      surface: _darkPrimaryBackground,
      onPrimary: _darkPrimaryText, // Texte sur la couleur primaire (boutons)
      onSecondary: _darkPrimaryText,
      onSurface: _darkPrimaryText, // Texte sur la couleur de surface
      error: Colors.redAccent,
      onError: _darkPrimaryText,
    ),

    // --- Thème du texte ---
    // Correspondance avec la hiérarchie typographique de la charte
    textTheme: TextTheme(
      // H1: Titre de Page
      headlineLarge: GoogleFonts.poppins(
          fontSize: 26, fontWeight: FontWeight.bold, color: _darkPrimaryText),
      // H2: Titre de Carte
      headlineMedium: GoogleFonts.poppins(
          fontSize: 18, fontWeight: FontWeight.w600, color: _darkPrimaryText),
      // Donnée Principale
      displayLarge: GoogleFonts.poppins(
          fontSize: 24, fontWeight: FontWeight.bold, color: _darkPrimaryText),
      // Corps de Texte / Label
      bodyLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: _darkSecondaryText),
      // Texte de Bouton
      labelLarge: GoogleFonts.poppins(
          fontSize: 15, fontWeight: FontWeight.w500, color: _darkPrimaryText),
    ),

    // --- Thèmes des composants ---
    cardTheme: CardThemeData(
      color: _darkSecondaryBackground,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkAccent,
        foregroundColor: _darkPrimaryText,
        shape: const StadiumBorder(), // Forme "pilule"
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _darkAccent,
      foregroundColor: _darkPrimaryText,
      elevation: 4.0,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _darkSecondaryBackground,
      selectedItemColor: _darkAccent,
      unselectedItemColor: _darkSecondaryText,
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: _darkPrimaryBackground,
      elevation: 0,
      centerTitle: true,
    ),
  );

  // ===========================================================================
  // == Thème Clair (Light Mode)
  // ==========================================================================='

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: GoogleFonts.poppins().fontFamily,
    scaffoldBackgroundColor: _lightPrimaryBackground,
    primaryColor: _lightAccent,

    // --- Schéma de couleurs ---
    colorScheme: const ColorScheme.light(
      primary: _lightAccent,
      secondary: _lightAccent,
      surface: _lightPrimaryBackground,
      onPrimary: _darkPrimaryText, // Texte blanc sur boutons bleus
      onSecondary: _darkPrimaryText,
      onSurface: _lightPrimaryText,
      error: Colors.red,
      onError: _darkPrimaryText,
    ),

    // --- Thème du texte ---
    textTheme: TextTheme(
      // H1: Titre de Page
      headlineLarge: GoogleFonts.poppins(
          fontSize: 26, fontWeight: FontWeight.bold, color: _lightPrimaryText),
      // H2: Titre de Carte
      headlineMedium: GoogleFonts.poppins(
          fontSize: 18, fontWeight: FontWeight.w600, color: _lightPrimaryText),
      // Donnée Principale
      displayLarge: GoogleFonts.poppins(
          fontSize: 24, fontWeight: FontWeight.bold, color: _lightPrimaryText),
      // Corps de Texte / Label
      bodyLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: _lightSecondaryText),
      // Texte de Bouton
      labelLarge: GoogleFonts.poppins(
          fontSize: 15, fontWeight: FontWeight.w500, color: _darkPrimaryText),
    ),

    // --- Thèmes des composants ---
    cardTheme: CardThemeData(
      color: _lightSecondaryBackground,
      elevation: 2.0, // Une ombre subtile pour le mode clair
      shadowColor: _lightPrimaryText.withValues(alpha: 0.05),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightAccent,
        foregroundColor: _darkPrimaryText, // Texte blanc
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 2.0,
        shadowColor: _lightAccent.withValues(alpha: 0.4),
        textStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _lightAccent,
      foregroundColor: _darkPrimaryText,
      elevation: 4.0,
      splashColor: _lightSecondaryBackground.withValues(alpha: 0.5),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _lightSecondaryBackground,
      selectedItemColor: _lightAccent,
      unselectedItemColor: _lightSecondaryText,
      elevation: 4.0, // Ombre pour la barre flottante
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: _lightPrimaryBackground,
      foregroundColor: _lightPrimaryText, // Couleur des icônes et du titre
      elevation: 0,
      centerTitle: true,
    ),
  );
}
