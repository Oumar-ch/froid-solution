// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class StatIconCardNeon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final double borderRadius;
  final LinearGradient? gradient;

  const StatIconCardNeon({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.borderRadius = 18,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: null,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient:
              gradient ??
              LinearGradient(
                colors: [color.withOpacity(0.08), color.withOpacity(0.02)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Responsive.isMobile(context) ? 14 : 22,
            horizontal: Responsive.isMobile(context) ? 8 : 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: Responsive.isMobile(context) ? 28 : 38,
                shadows: [
                  Shadow(color: color.withOpacity(0.6), blurRadius: 10),
                ],
              ),
              SizedBox(height: Responsive.isMobile(context) ? 8 : 14),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.font(context, 20),
                  shadows: [
                    Shadow(blurRadius: 8, color: color.withOpacity(0.7)),
                  ],
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 4 : 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: Responsive.font(context, 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
