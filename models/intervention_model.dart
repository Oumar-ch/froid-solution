/// Modèle de données représentant une intervention.
///
/// Cette classe est immuable, ce qui signifie que ses propriétés ne peuvent pas être
/// modifiées après sa création. Cela garantit la cohérence des données à
/// travers l'application.
// ignore_for_file: unnecessary_library_name

library intervention_model;

import '../constants/intervention_constants.dart';

class Intervention {
  factory Intervention.fromMap(Map<String, dynamic> map) {
    String safeString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      return value.toString();
    }

    DateTime safeDate(dynamic value, {DateTime? fallback}) {
      if (value == null) return fallback ?? DateTime.now();
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) {
        try {
          return DateTime.parse(value);
        } catch (_) {
          return fallback ?? DateTime.now();
        }
      }
      return fallback ?? DateTime.now();
    }

    // Conversion type et status depuis String vers enum
    InterventionType typeEnum = InterventionType.values.firstWhere(
      (e) => e.label == safeString(map['type']),
      orElse: () => InterventionType.autre,
    );
    InterventionStatus statusEnum = InterventionStatus.values.firstWhere(
      (e) => e.label == safeString(map['status']),
      orElse: () => InterventionStatus.aFaire,
    );

    return Intervention(
      id: safeString(map['id']),
      date: safeDate(map['date']),
      type: typeEnum,
      description: safeString(map['description']),
      status: statusEnum,
      clientName: safeString(map['clientName']),
      installationDate:
          safeDate(map['installationDate'], fallback: safeDate(map['date'])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type.label,
      'description': description,
      'status': status.label,
      'clientName': clientName,
      'installationDate': installationDate.toIso8601String(),
    };
  }

  /// Identifiant unique de l'intervention.
  final String id;

  /// Date à laquelle l'intervention a eu lieu.
  final DateTime date;

  /// Type d'intervention (enum).
  final InterventionType type;

  /// Description détaillée de l'intervention.
  final String description;

  /// Statut actuel de l'intervention (enum).
  final InterventionStatus status;

  /// Nom du client associé à l'intervention.
  final String clientName;

  /// Date d'installation prévue ou réelle de l'intervention.
  final DateTime installationDate;

  /// Crée une instance d'intervention.
  ///
  /// Le constructeur est `const` pour permettre des optimisations de performance
  /// par le compilateur lorsque les instances sont connues à la compilation.
  const Intervention({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.status,
    required this.clientName,
    required this.installationDate,
  });
}
