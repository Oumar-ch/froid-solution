// Configuration globale de l'application
import 'app_environment.dart';
// Peut être enrichie pour gérer différents environnements (dev, prod, etc.)

class AppConfig {
  static bool get isProduction => AppEnvironment.isProd;
  static String get apiBaseUrl => AppEnvironment.apiUrl;

  // Ajoute ici d'autres paramètres dynamiques ou secrets
}
