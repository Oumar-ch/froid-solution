// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:ui';

/// Card avec effet glassmorphism personnalisable.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final BoxBorder? border;

  const GlassCard({
    required this.child,
    this.borderRadius = 24,
    this.blur = 12,
    this.backgroundColor = const Color(0x55FFFFFF),
    this.padding = const EdgeInsets.all(24),
    this.gradient,
    this.border,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius),
            border:
                border ??
                Border.all(color: Colors.white.withOpacity(0.18), width: 1.5),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
