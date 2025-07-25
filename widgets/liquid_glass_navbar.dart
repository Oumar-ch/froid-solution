// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';

// Nouvelle barre de navigation avec effet glass glossy
class GlossyNavBar extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double opacity;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double height;
  final double width;

  const GlossyNavBar({
    super.key,
    required this.child,
    this.borderRadius = 22,
    this.opacity = 0.18,
    this.margin,
    this.padding,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GlossyContainer(
      borderRadius: BorderRadius.circular(borderRadius),
      opacity: opacity,
      margin: margin,
      padding: padding,
      height: height,
      width: width,
      child: child,
    );
  }
}
