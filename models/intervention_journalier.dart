import '../constants/intervention_constants.dart';

class InterventionDuJour {
  final String id;
  final String programmeId; // Lien avec ProgrammeTask
  final String heure;
  final InterventionType type;
  final String equipement;
  final String client;
  final InterventionStatus statut;

  InterventionDuJour({
    required this.id,
    required this.programmeId,
    required this.heure,
    required this.type,
    required this.equipement,
    required this.client,
    required this.statut,
  });

  factory InterventionDuJour.fromMap(Map<String, dynamic> map) {
    InterventionType typeEnum = InterventionType.values.firstWhere(
      (e) => e.label == map['type'],
      orElse: () => InterventionType.autre,
    );
    InterventionStatus statutEnum = InterventionStatus.values.firstWhere(
      (e) => e.label == map['statut'],
      orElse: () => InterventionStatus.aFaire,
    );
    return InterventionDuJour(
      id: map['id'],
      programmeId: map['programmeId'],
      heure: map['heure'],
      type: typeEnum,
      equipement: map['equipement'],
      client: map['client'],
      statut: statutEnum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'programmeId': programmeId,
      'heure': heure,
      'type': type.label,
      'equipement': equipement,
      'client': client,
      'statut': statut.label,
    };
  }
}
