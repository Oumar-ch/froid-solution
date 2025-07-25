// Centralisation des gradients et animations dynamiques
import 'package:flutter/material.dart';

class AppGradients {
  static LinearGradient getNeonGradient(bool isDark) {
    return LinearGradient(
      colors: isDark
          ? [Color(0xFF09FBD3), Color(0xFF00FFFF), Color(0xFF1E3A8A)]
          : [Color(0xFF38BDF8), Color(0xFF0284C7), Color(0xFFFFFFFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Ajoute ici d'autres gradients dynamiques si besoin
}
