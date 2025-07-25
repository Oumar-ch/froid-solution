class Technicien {
  final String id;
  final String nom;
  final String numero;
  final String adresse;
  final String habilitation;

  Technicien({
    required this.id,
    required this.nom,
    required this.numero,
    required this.adresse,
    required this.habilitation,
  });

  String get nom_ => nom;
  String get numero_ => numero;
  String get adresse_ => adresse;
  String get habilitation_ => habilitation;

  factory Technicien.fromMap(Map<String, dynamic> map) {
    String safeString(dynamic value, {String fallback = ''}) {
      if (value == null) return fallback;
      if (value is String) return value;
      return value.toString();
    }

    return Technicien(
      id: safeString(map['id']),
      nom: safeString(map['nom']),
      numero: safeString(map['numero']),
      adresse: safeString(map['adresse']),
      habilitation: safeString(map['habilitation'], fallback: 'novice'),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nom': nom,
        'numero': numero, // numéro de téléphone
        'adresse': adresse,
        'habilitation': habilitation,
      };
}
