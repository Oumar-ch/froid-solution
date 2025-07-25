import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: AppColors.lightBackground, // Fond très doux
  appBarTheme: AppBarTheme(
    color: AppColors.lightSurface, // Surface douce
    foregroundColor: AppColors.lightText, // Texte doux
    elevation: 2,
    iconTheme: IconThemeData(color: AppColors.lightAccent),
    titleTextStyle: TextStyle(
      color: AppColors.lightText,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      fontFamily: 'Orbitron',
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.lightCard,
    elevation: 4,
    shadowColor: AppColors.lightAccentGlow.withValues(
      alpha: 0.3,
    ), // Ombre douce
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.lightAccent, // Accent doux
    foregroundColor: Colors.white,
    elevation: 8,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFE3F2FD),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Color(0xFF00B8D4)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Color(0xFF00B8D4)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Color(0xFF0097A7)),
    ),
    hintStyle: TextStyle(color: Color(0xFF4fc3f7)),
    labelStyle: TextStyle(color: Color(0xFF00B8D4)),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFF00B8D4),
      shadows: [
        Shadow(
          blurRadius: 12.0,
          color: Color(0xFF00B8D4),
          offset: Offset(0, 0),
        ),
      ],
      letterSpacing: 1.5,
      fontFamily: 'Orbitron',
    ),
    titleLarge: TextStyle(
      color: Color(0xFF0C1833),
      fontWeight: FontWeight.bold,
      fontSize: 18,
      fontFamily: 'Orbitron',
    ),
    bodyLarge: TextStyle(color: Color(0xFF0C1833)),
    bodyMedium: TextStyle(color: Color(0xFF607D8B)),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF00B8D4), size: 28),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFF6FAFF),
    selectedItemColor: Color(0xFF00B8D4),
    unselectedItemColor: Colors.black54,
    selectedIconTheme: IconThemeData(color: Color(0xFF00B8D4), size: 32),
    unselectedIconTheme: IconThemeData(color: Colors.black54, size: 28),
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);
