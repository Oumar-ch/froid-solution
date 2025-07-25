// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../models/client.dart';
import '../utils/responsive.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double borderRadius;
  final double blur;
  final double border;
  final LinearGradient? gradient;
  final LinearGradient? borderGradient;
  final Color? neonColor;
  final EdgeInsetsGeometry? margin;
  const ClientCard({
    required this.client,
    required this.onEdit,
    required this.onDelete,
    this.borderRadius = 18,
    this.blur = 10,
    this.border = 1.2,
    this.gradient,
    this.borderGradient,
    this.neonColor,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = neonColor ?? (isDark ? Colors.cyanAccent : Colors.blueAccent);
    return GlassmorphicContainer(
      margin:
          margin ??
          EdgeInsets.symmetric(
            vertical: Responsive.isMobile(context) ? 8 : 16,
            horizontal: Responsive.isMobile(context) ? 4 : 12,
          ),
      borderRadius: borderRadius,
      blur: blur,
      alignment: Alignment.center,
      border: border,
      linearGradient:
          gradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [neon.withOpacity(0.13), neon.withOpacity(0.07)],
          ),
      borderGradient:
          borderGradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [neon.withOpacity(0.35), Colors.transparent],
          ),
      width: double.infinity,
      height: Responsive.isMobile(context)
          ? 90
          : (Responsive.isTablet(context) ? 110 : 130),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: Responsive.isMobile(context) ? 14 : 22,
          horizontal: Responsive.isMobile(context) ? 18 : 32,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: neon.withOpacity(0.13),
            radius: Responsive.isMobile(context) ? 27 : 36,
            child: Text(
              client.name.isNotEmpty ? client.name[0].toUpperCase() : "?",
              style: TextStyle(
                color: neon,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.font(context, 28),
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: neon,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          title: Text(
            client.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
              fontSize: Responsive.font(context, 16),
            ),
          ),
          subtitle: Text(
            client.contact,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: Responsive.font(context, 13),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: neon,
                  size: Responsive.isMobile(context) ? 22 : 28,
                ),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: Responsive.isMobile(context) ? 22 : 28,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
