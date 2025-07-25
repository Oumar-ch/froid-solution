class ProgrammeTask {
  final String id;
  final String titre;
  final DateTime date;
  final String? client;
  final String? telephone;
  final String? adresse;
  final String? commentaire;
  final String? technicienId;
  final String? heure;
  final String? typeIntervention;
  final String? equipement;

  ProgrammeTask({
    required this.id,
    required this.titre,
    required this.date,
    this.client,
    this.telephone,
    this.adresse,
    this.commentaire,
    this.technicienId,
    this.heure,
    this.typeIntervention,
    this.equipement,
  });

  // Getters attendus par les widgets
  DateTime get date_ => date;
  String get heure_ => heure ?? '';
  String get typeIntervention_ => typeIntervention ?? '';
  String get equipement_ => equipement ?? '';
  String get telephone_ => telephone ?? '';
  String get adresse_ => adresse ?? '';
  String get commentaire_ => commentaire ?? '';

  // Pour sauvegarde/chargement si besoin :
  factory ProgrammeTask.fromMap(Map<String, dynamic> map) => ProgrammeTask(
        id: map['id'],
        titre: map['titre'],
        date: (map['date'] != null && map['date'] is String)
            ? DateTime.tryParse(map['date']) ?? DateTime.now()
            : DateTime.now(),
        client: map['client'],
        telephone: map['telephone'],
        adresse: map['adresse'],
        commentaire: map['commentaire'],
        technicienId: map['technicienId'],
        heure: map['heure'],
        typeIntervention: map['typeIntervention'],
        equipement: map['equipement'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'titre': titre,
        'date': date.toIso8601String(),
        'client': client,
        'telephone': telephone,
        'adresse': adresse,
        'commentaire': commentaire,
        'technicienId': technicienId,
        'heure': heure,
        'typeIntervention': typeIntervention,
        'equipement': equipement,
      };
}
