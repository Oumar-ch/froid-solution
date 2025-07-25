import 'package:flutter/material.dart';

/// Utilitaire responsive global pour toute l'application.
class Responsive {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static bool isMobile(BuildContext context) => width(context) < 600;
  static bool isTablet(BuildContext context) =>
      width(context) >= 600 && width(context) < 1200;
  static bool isDesktop(BuildContext context) => width(context) >= 1200;

  static double font(BuildContext context, double size) {
    if (isMobile(context)) return size;
    if (isTablet(context)) return size * 1.15;
    return size * 1.3;
  }

  static double padding(BuildContext context) {
    if (isMobile(context)) return 12;
    if (isTablet(context)) return 24;
    return 36;
  }

  static EdgeInsets symmetricPadding(BuildContext context) {
    double pad = padding(context);
    return EdgeInsets.symmetric(horizontal: pad, vertical: pad / 2);
  }
}
