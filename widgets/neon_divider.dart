import 'package:flutter/material.dart';

class NeonDivider extends StatelessWidget {
  final double thickness;
  final Color color;
  final double glow;
  final EdgeInsetsGeometry margin;

  const NeonDivider({
    super.key,
    this.thickness = 3.5,
    this.color = Colors.cyanAccent,
    this.glow = 18,
    this.margin = const EdgeInsets.symmetric(vertical: 22),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: thickness,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.65),
            blurRadius: glow,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
