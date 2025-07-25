import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Classe utilitaire statique pour la journalisation (logging).
///
/// Fournit des méthodes pour enregistrer des messages qui ne sont visibles
/// qu'en mode débogage (`kDebugMode`), évitant ainsi d'exposer des informations
/// sensibles ou de dégrader les performances en production.
class AppLogger {
  // Le constructeur privé empêche l'instanciation de cette classe utilitaire.
  AppLogger._();

  /// Enregistre un message d'information standard.
  ///
  /// Utilise `developer.log` pour un affichage amélioré dans la console de débogage.
  static void info(String message, {String name = 'App'}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: name,
        level: 700, // Niveau correspondant à INFO
      );
    }
  }

  /// Enregistre un message d'avertissement.
  static void warning(String message, {String name = 'App'}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: name,
        level: 900, // Niveau correspondant à WARNING
      );
    }
  }

  /// Enregistre une erreur, avec l'objet d'exception et la trace de la pile.
  static void error(
    String message, {
    String name = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(
        message,
        name: name,
        error: error,
        stackTrace: stackTrace,
        level: 1000, // Niveau correspondant à SEVERE/ERROR
      );
    }
  }
}
