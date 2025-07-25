import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

/// Thème moderne basé sur FlexColorScheme
class FlexAppTheme {
  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.mandyRed,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 9,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: true,
      navigationBarLabelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    fontFamily: 'Raleway',
  );

  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.mandyRed,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 15,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      blendOnColors: true,
      navigationBarLabelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    fontFamily: 'Raleway',
  );
}
