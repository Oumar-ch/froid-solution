// Centralisation des chemins d'assets (images, icônes, polices)
import '../config/app_environment.dart';

class AppAssets {
  // Images
  static String get logo => '${AppEnvironment.assetsPath}logo.png';
  static String get flocon => '${AppEnvironment.assetsPath}flocon.png';

  // Fonts
  static String get ralewayRegular =>
      '${AppEnvironment.assetsPath}fonts/raleway/Raleway-Regular.ttf';
  static String get ralewayBold =>
      '${AppEnvironment.assetsPath}fonts/raleway/Raleway-Bold.ttf';

  // Ajoute ici d'autres assets si besoin
}
