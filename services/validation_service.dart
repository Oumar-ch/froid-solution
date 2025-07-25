import '../config/app_config.dart';

class ValidationService {
  static List<String> get validTypes => AppConfig.isProduction
      ? ['maintenance', 'installation', 'dépannage']
      : ['maintenance', 'installation', 'dépannage', 'test', 'demo'];
  // Validation des données clients
  static String? validateClientName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Le nom du client est requis';
    }
    if (name.trim().length < 2) {
      return 'Le nom du client doit contenir au moins 2 caractères';
    }
    return null;
  }

  static String? validateClientContact(String? contact) {
    if (contact == null || contact.trim().isEmpty) {
      return 'Le contact est requis';
    }
    // Validation basique pour numéro de téléphone français
    final phoneRegex = RegExp(r'^(?:\+33|0)[1-9](?:[0-9]{8})$');
    if (!phoneRegex.hasMatch(contact.replaceAll(' ', ''))) {
      return 'Format de téléphone invalide';
    }
    return null;
  }

  static String? validateClientAddress(String? address) {
    if (address == null || address.trim().isEmpty) {
      return 'L\'adresse est requise';
    }
    if (address.trim().length < 10) {
      return 'L\'adresse doit contenir au moins 10 caractères';
    }
    return null;
  }

  static String? validateContractType(String? contractType) {
    if (contractType == null || contractType.trim().isEmpty) {
      return 'Le type de contrat est requis';
    }
    final validTypes = [
      'maintenance',
      'installation',
      'réparation',
      'contrat_annuel',
    ];
    if (!validTypes.contains(contractType.toLowerCase())) {
      return 'Type de contrat invalide';
    }
    return null;
  }

  // Validation des données d'intervention
  static String? validateInterventionType(String? type) {
    if (type == null || type.trim().isEmpty) {
      return 'Le type d\'intervention est requis';
    }
    if (type.trim().length < 3) {
      return 'Le type d\'intervention doit contenir au moins 3 caractères';
    }
    return null;
  }

  static String? validateInterventionDescription(String? description) {
    if (description == null || description.trim().isEmpty) {
      return 'La description est requise';
    }
    if (description.trim().length < 10) {
      return 'La description doit contenir au moins 10 caractères';
    }
    return null;
  }

  static String? validateDate(DateTime? date) {
    if (date == null) {
      return 'La date est requise';
    }
    final now = DateTime.now();
    if (date.isAfter(now.add(const Duration(days: 365)))) {
      return 'La date ne peut pas être supérieure à un an';
    }
    return null;
  }

  // Validation des données de tâche
  static String? validateTaskTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return 'Le titre de la tâche est requis';
    }
    if (title.trim().length < 5) {
      return 'Le titre doit contenir au moins 5 caractères';
    }
    return null;
  }

  // Validation des données technicien
  static String? validateTechnicianName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Le nom du technicien est requis';
    }
    if (name.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    // Vérifier que le nom ne contient que des lettres et espaces
    final nameRegex = RegExp(
      r'^[a-zA-ZàâäéèêëïîôöùûüÿñçÀÂÄÉÈÊËÏÎÔÖÙÛÜŸÑÇ\s-]+$',
    );
    if (!nameRegex.hasMatch(name)) {
      return 'Le nom ne peut contenir que des lettres, espaces et tirets';
    }
    return null;
  }

  // Validation des données d'intervention journalière
  static String? validateInterventionTime(String? time) {
    if (time == null || time.trim().isEmpty) {
      return 'L\'heure est requise';
    }
    // Validation format HH:mm
    final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(time)) {
      return 'Format d\'heure invalide (HH:mm)';
    }
    return null;
  }

  static String? validateEquipment(String? equipment) {
    if (equipment == null || equipment.trim().isEmpty) {
      return 'L\'équipement est requis';
    }
    if (equipment.trim().length < 3) {
      return 'Le nom de l\'équipement doit contenir au moins 3 caractères';
    }
    return null;
  }

  // Validation email (optionnel)
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return null; // Email optionnel
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Format d\'email invalide';
    }
    return null;
  }

  // Validation ID unique
  static String? validateId(String? id) {
    if (id == null || id.trim().isEmpty) {
      return 'L\'ID est requis';
    }
    if (id.trim().length < 3) {
      return 'L\'ID doit contenir au moins 3 caractères';
    }
    return null;
  }

  // Validation du statut
  static String? validateStatus(String? status) {
    if (status == null || status.trim().isEmpty) {
      return 'Le statut est requis';
    }
    final validStatuses = [
      'à faire',
      'en cours',
      'terminé',
      'annulé',
      'validé',
      'non validé',
    ];
    if (!validStatuses.contains(status.toLowerCase())) {
      return 'Statut invalide';
    }
    return null;
  }

  // Méthode pour valider tous les champs d'un client
  static Map<String, String?> validateClient({
    required String? name,
    required String? contact,
    required String? address,
    required String? contractType,
    String? email,
  }) {
    return {
      'name': validateClientName(name),
      'contact': validateClientContact(contact),
      'address': validateClientAddress(address),
      'contractType': validateContractType(contractType),
      'email': validateEmail(email),
    };
  }

  // Méthode pour valider tous les champs d'une intervention
  static Map<String, String?> validateIntervention({
    required String? clientName,
    required String? type,
    required String? description,
    required DateTime? installationDate,
    required String? status,
  }) {
    return {
      'clientName': validateClientName(clientName),
      'type': validateInterventionType(type),
      'description': validateInterventionDescription(description),
      'installationDate': validateDate(installationDate),
      'status': validateStatus(status),
    };
  }

  // Méthode utilitaire pour vérifier s'il y a des erreurs
  static bool hasErrors(Map<String, String?> validationResults) {
    return validationResults.values.any((error) => error != null);
  }

  // Méthode pour obtenir la première erreur
  static String? getFirstError(Map<String, String?> validationResults) {
    return validationResults.values.firstWhere(
      (error) => error != null,
      orElse: () => null,
    );
  }
}
