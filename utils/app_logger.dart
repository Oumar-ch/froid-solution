import 'dart:developer' as developer;

class AppLogger {
  static final List<String> _logs = [];

  static void log(String message, {String? tag}) {
    final timestamp = DateTime.now().toIso8601String();
    final prefix = tag != null ? '[$tag] ' : '';
    final entry = '[$timestamp] $prefix$message';
    _logs.add(entry);
    developer.log(entry, name: 'AppLogger');
  }

  static void error(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    final timestamp = DateTime.now().toIso8601String();
    final prefix = tag != null ? '[$tag] ' : '';
    final entry = '[$timestamp] ❌ $prefix$message';
    _logs.add(entry);
    developer.log(entry,
        name: 'AppLogger', error: error, stackTrace: stackTrace);
  }

  static List<String> getLogs() => List.unmodifiable(_logs);

  static void clear() => _logs.clear();
}
