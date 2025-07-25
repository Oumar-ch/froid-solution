import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../config/app_config.dart';

class LogService {
  static bool get enableDebugLogs => !AppConfig.isProduction;
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;
  LogService._internal();

  static const String _logFileName = 'app_logs.txt';

  // Enregistrer un log
  static Future<void> log(String message, {String level = 'INFO'}) async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      final logEntry = '[$timestamp] [$level] $message\n';

      final documentsDir = await getApplicationDocumentsDirectory();
      final logFile = File('${documentsDir.path}/$_logFileName');

      await logFile.writeAsString(logEntry, mode: FileMode.append);
    } catch (e) {
      // En cas d'erreur de log, ne pas faire planter l'application
    }
  }

  // Log d'erreur
  static Future<void> error(String message, [dynamic error]) async {
    final fullMessage = error != null ? '$message: $error' : message;
    await log(fullMessage, level: 'ERROR');
  }

  // Log d'avertissement
  static Future<void> warning(String message) async {
    await log(message, level: 'WARNING');
  }

  // Log d'information
  static Future<void> info(String message) async {
    await log(message, level: 'INFO');
  }

  // Log de débogage
  static Future<void> debug(String message) async {
    await log(message, level: 'DEBUG');
  }

  // Lire les logs
  static Future<String> getLogs() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final logFile = File('${documentsDir.path}/$_logFileName');

      if (await logFile.exists()) {
        return await logFile.readAsString();
      }
      return 'Aucun log disponible';
    } catch (e) {
      return 'Erreur lors de la lecture des logs: $e';
    }
  }

  // Effacer les logs
  static Future<void> clearLogs() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final logFile = File('${documentsDir.path}/$_logFileName');

      if (await logFile.exists()) {
        await logFile.delete();
      }
    } catch (e) {
      // Ignorer les erreurs de suppression
    }
  }

  // Limiter la taille du fichier de log
  static Future<void> rotateLogs() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final logFile = File('${documentsDir.path}/$_logFileName');

      if (await logFile.exists()) {
        final fileSize = await logFile.length();
        const maxSize = 1024 * 1024; // 1MB

        if (fileSize > maxSize) {
          final content = await logFile.readAsString();
          final lines = content.split('\n');

          // Garder seulement les 1000 dernières lignes
          final recentLines = lines.length > 1000
              ? lines.sublist(lines.length - 1000)
              : lines;

          await logFile.writeAsString(recentLines.join('\n'));
        }
      }
    } catch (e) {
      // Ignorer les erreurs de rotation
    }
  }
}
