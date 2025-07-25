// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
// ...existing code...
import '../utils/responsive.dart';
import '../constants/app_assets.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // LOGO
        SizedBox(
          height: Responsive.isMobile(context)
              ? 50
              : (Responsive.isTablet(context) ? 80 : 110),
          child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
        ),
        SizedBox(height: Responsive.isMobile(context) ? 8 : 16),
        // TITRE
        Text(
          'Tableau de bord',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.cyanAccent.shade400,
            fontSize: Responsive.font(context, 20),
            fontWeight: FontWeight.bold,
            letterSpacing: 2.5,
            shadows: [
              Shadow(
                blurRadius: 12,
                color: Colors.blue.shade900.withOpacity(0.7),
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
