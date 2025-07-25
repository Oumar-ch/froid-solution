import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: AppColors.darkBackground, // Bleu nuit uniforme
  appBarTheme: AppBarTheme(
    color: AppColors.darkSurface, // Surface uniforme
    foregroundColor: AppColors.darkText, // Texte uniforme
    elevation: 2,
    iconTheme: IconThemeData(color: AppColors.darkNeon),
    titleTextStyle: TextStyle(
      color: AppColors.darkText,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      fontFamily: 'Orbitron',
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.darkCard, // Couleur uniforme
    elevation: 4,
    shadowColor: AppColors.darkNeonGlow.withValues(alpha: 0.4), // Glow uniforme
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.darkNeon, // Bouton accent néon
    foregroundColor: Colors.black,
    elevation: 8,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1e293b),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Color(0xFF00ffff)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Color(0xFF00ffff)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Color(0xFF09fbd3)),
    ),
    hintStyle: TextStyle(color: Color(0xFF4fc3f7)),
    labelStyle: TextStyle(color: Color(0xFF00ffff)),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFF00ffff),
      shadows: [
        Shadow(
          blurRadius: 16.0,
          color: Color(0xFF00ffff),
          offset: Offset(0, 0),
        ),
      ],
      letterSpacing: 1.5,
    ),
    titleLarge: TextStyle(
      color: Color(0xFFFFFFFF), // Remplace Colors.white
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    bodyLarge: TextStyle(color: Color(0xFFFFFFFF)), // Remplace Colors.white
    bodyMedium: TextStyle(color: Color(0xFFe0e7ef)),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF00ffff), size: 28),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0f172a),
    selectedItemColor: Color(0xFF00ffff),
    unselectedItemColor: Colors.white54,
    selectedIconTheme: IconThemeData(color: Color(0xFF00ffff), size: 32),
    unselectedIconTheme: IconThemeData(color: Colors.white54, size: 28),
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);
