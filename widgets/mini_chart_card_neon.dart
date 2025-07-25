// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../utils/responsive.dart';

class MiniChartCardNeon extends StatelessWidget {
  final String label;
  final String value;
  final Color lineColor;
  final double? height; // Ajout du paramètre height

  const MiniChartCardNeon({
    super.key,
    required this.label,
    required this.value,
    required this.lineColor,
    this.height, // Ajout du paramètre height
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveHeight = height ??
        (Responsive.isMobile(context)
            ? 110 // Augmenté pour mobile
            : (Responsive.isTablet(context)
                ? 140
                : 160)); // Augmenté pour desktop/tablette
    return GlassmorphicContainer(
      margin: EdgeInsets.zero,
      borderRadius: 18,
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
      height: effectiveHeight, // Utilisation du paramètre height
      width: double.infinity,
      child: Card(
        color: Colors.white10,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Responsive.isMobile(context) ? 12 : 18,
              horizontal: Responsive.isMobile(context) ? 10 : 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize:
                  MainAxisSize.min, // On garde min pour éviter overflow
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.font(context, 13),
                  ),
                ),
                SizedBox(height: Responsive.isMobile(context) ? 6 : 10),
                // Petite ligne courbe décorative (fake chart)
                SizedBox(
                  height: Responsive.isMobile(context) ? 18 : 28,
                  child: CustomPaint(
                    painter: _FakeChartPainter(lineColor),
                    child: Container(),
                  ),
                ),
                SizedBox(height: Responsive.isMobile(context) ? 6 : 10),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.font(context, 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget interne pour le tracé de la "courbe" décorative
class _FakeChartPainter extends CustomPainter {
  final Color color;
  _FakeChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.25, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.7),
      Offset(size.width * 0.75, size.height * 0.4),
      Offset(size.width, size.height * 0.65),
    ];

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FakeChartPainter oldDelegate) => false;
}
