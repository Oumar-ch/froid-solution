// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../utils/responsive.dart';

class GlassReminderCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final double borderRadius;
  final double blur;
  final double border;
  final double opacity;
  final LinearGradient? gradient;
  final LinearGradient? borderGradient;

  const GlassReminderCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.borderRadius = 18,
    this.blur = 12,
    this.border = 1.2,
    this.opacity = 0.10,
    this.gradient,
    this.borderGradient,
  });

  @override
  Widget build(BuildContext context) {
    // Sécurisation stricte : toujours un double non-null
    final double safeHeight = (height == null || height!.isNaN)
        ? (Responsive.isMobile(context)
              ? 120.0
              : (Responsive.isTablet(context) ? 140.0 : 160.0))
        : height!;
    final double safeWidth = (width == null || width!.isNaN)
        ? double.infinity
        : width!;
    return GlassmorphicContainer(
      margin:
          margin ??
          EdgeInsets.symmetric(
            vertical: Responsive.isMobile(context) ? 8 : 16,
            horizontal: Responsive.isMobile(context) ? 12 : 24,
          ),
      borderRadius: borderRadius,
      blur: blur,
      border: border,
      width: safeWidth,
      height: safeHeight, // Jamais NaN ni null
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.18),
          Colors.white.withOpacity(0.09),
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
      child: Container(
        padding:
            padding ??
            EdgeInsets.symmetric(
              vertical: Responsive.isMobile(context) ? 10 : 18,
              horizontal: Responsive.isMobile(context) ? 12 : 24,
            ),
        child: child,
      ),
    );
  }
}
