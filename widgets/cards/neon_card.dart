// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// Card avec effet néon/glow personnalisable.
class NeonCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color glowColor;
  final double glowRadius;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final BoxBorder? border;

  const NeonCard({
    required this.child,
    this.borderRadius = 24,
    this.glowColor = Colors.cyanAccent,
    this.glowRadius = 18,
    this.padding = const EdgeInsets.all(24),
    this.gradient,
    this.border,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.7),
            blurRadius: glowRadius,
            spreadRadius: 2,
          ),
        ],
        color: Colors.black.withOpacity(0.85),
        gradient: gradient,
        border: border ?? Border.all(color: glowColor, width: 2.2),
      ),
      padding: padding,
      child: child,
    );
  }
}
