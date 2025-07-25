/// Configuration dynamique pour dev/prod
/// Utilisation : AppEnvironment.isProd, AppEnvironment.apiUrl, etc.
library;

enum Environment { dev, prod }

class AppEnvironment {
  static Environment current = _getEnv();

  static Environment _getEnv() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    return env == 'prod' ? Environment.prod : Environment.dev;
  }

  static bool get isProd => current == Environment.prod;
  static bool get isDev => current == Environment.dev;

  static String get apiUrl => current == Environment.prod
      ? 'https://api.froidsolutions.com/v1/'
      : 'https://dev-api.froidsolutions.com/v1/';

  static String get assetsPath =>
      current == Environment.prod ? 'assets/' : 'assets_dev/';

  // Ajoutez ici d'autres paramètres dynamiques
}
