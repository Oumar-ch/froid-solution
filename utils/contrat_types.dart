/// Constantes partagées pour les types de contrat
class ContratTypes {
  ContratTypes._();

  static const List<String> types = [
    'Maintenance préventive',
    'Maintenance corrective', 
    'Dépannage urgent',
    'Installation',
    'Contrôle technique',
    'Nettoyage/Entretien'
  ];

  /// Vérifie si un type de contrat est valide
  static bool isValid(String? type) {
    return type != null && types.contains(type);
  }

  /// Retourne le type par défaut si le type fourni n'est pas valide
  static String getValidType(String? type) {
    return isValid(type) ? type! : types.first;
  }
}
