import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AnimatedEntry extends StatefulWidget {
  final ui.Image logoImage;
  final VoidCallback onComplete;
  const AnimatedEntry({
    required this.logoImage,
    required this.onComplete,
    super.key,
  });

  @override
  State<AnimatedEntry> createState() => _AnimatedEntryState();
}

class _AnimatedEntryState extends State<AnimatedEntry>
    with TickerProviderStateMixin {
  late AnimationController ctrl;
  late Animation<double> haloAnim, logoAnim, textAnim;

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..forward();
    haloAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: ctrl,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );
    logoAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: ctrl,
        curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
      ),
    );
    textAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: ctrl,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
    ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onComplete();
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1327),
      body: AnimatedBuilder(
        animation: ctrl,
        builder: (_, _) => CustomPaint(
          painter: EntryPainter(
            logoImage: widget.logoImage,
            halo: haloAnim.value,
            logo: logoAnim.value,
            text: textAnim.value,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class EntryPainter extends CustomPainter {
  final ui.Image logoImage;
  final double halo, logo, text;
  EntryPainter({
    required this.logoImage,
    required this.halo,
    required this.logo,
    required this.text,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dim = min(size.width, size.height);
    // Centre du cercle (halo et logo parfaitement alignés)
    final center = Offset(size.width / 2, size.height * 0.38);

    // Halo néon (cercle principal)
    final haloRadius = dim * 0.19 * (0.8 + 0.2 * halo);
    canvas.drawCircle(
      center,
      haloRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        // ignore: deprecated_member_use
        ..color = Colors.cyanAccent.withOpacity(0.85 * halo),
    );

    // Logo scale + fade (remplit le cercle sans déborder, ratio respecté)
    if (logo > 0) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      // Le logo doit être inscrit dans le cercle (diamètre = haloRadius*2*0.92)
      final maxDiameter = haloRadius * 2 * 0.92;
      final imgRatio = logoImage.width / logoImage.height;
      double width, height;
      if (imgRatio > 1) {
        width = maxDiameter;
        height = maxDiameter / imgRatio;
      } else {
        height = maxDiameter;
        width = maxDiameter * imgRatio;
      }
      // Animation d'apparition
      width *= logo;
      height *= logo;
      final dst = Rect.fromCenter(
        center: Offset(0, 0),
        width: width,
        height: height,
      );
      final src = Rect.fromLTWH(
        0,
        0,
        logoImage.width.toDouble(),
        logoImage.height.toDouble(),
      );
      canvas.drawImageRect(logoImage, src, dst, Paint());
      canvas.restore();
    }

    // Texte “BIENVENUE” (encore plus bas)
    if (text > 0) {
      final tp = TextPainter(
        text: TextSpan(
          text: 'BIENVENUE',
          style: TextStyle(
            fontSize: dim * 0.06,
            // ignore: deprecated_member_use
            // ignore: deprecated_member_use
            color: Colors.cyanAccent.withOpacity(text),
            fontWeight: FontWeight.bold,
            letterSpacing: 2.5,
            shadows: [
              Shadow(
                // ignore: deprecated_member_use
                color: Colors.cyanAccent.withOpacity(text),
                blurRadius: 12 * text,
              ),
            ],
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          (size.width - tp.width) / 2,
          center.dy + haloRadius + dim * 0.08,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant EntryPainter o) =>
      o.halo != halo || o.logo != logo || o.text != text;
}
