// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class InfoStatNeon extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const InfoStatNeon({
    super.key,
    required this.label,
    required this.value,
    this.color = Colors.cyanAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: Responsive.font(context, 22),
            shadows: [
              Shadow(
                blurRadius: 9,
                color: color.withOpacity(0.7),
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        SizedBox(height: Responsive.isMobile(context) ? 2 : 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: Responsive.font(context, 14),
          ),
        ),
      ],
    );
  }
}
