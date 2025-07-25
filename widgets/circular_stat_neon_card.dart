// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../utils/responsive.dart';

class CircularStatNeonCard extends StatelessWidget {
  final String label;
  final int value; // de 0 à 100 (pourcent)
  final Color color;

  const CircularStatNeonCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      margin: EdgeInsets.zero,
      borderRadius: 22,
      blur: 10,
      alignment: Alignment.center,
      border: 1.2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.13),
          Colors.white.withOpacity(0.07),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.35),
          Colors.white.withOpacity(0.10),
        ],
      ),
      height: Responsive.isMobile(context)
          ? 110
          : (Responsive.isTablet(context) ? 160 : 200),
      width: double.infinity,
      child: Card(
        color: Colors.white10,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Responsive.isMobile(context) ? 18 : 28,
              horizontal: Responsive.isMobile(context) ? 12 : 24),
          child: Column(
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 60 : 94,
                width: Responsive.isMobile(context) ? 60 : 94,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: value / 100,
                      backgroundColor: Colors.blueGrey.shade800,
                      color: color,
                      strokeWidth: Responsive.isMobile(context) ? 7 : 10,
                    ),
                    Center(
                      child: Text(
                        "$value%",
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.font(context, 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 6 : 14),
              Text(
                label,
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
