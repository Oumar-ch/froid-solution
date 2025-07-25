class Client {
  final String id;
  final String name;
  final String contact;
  final String address;
  final String contratType;

  Client({
    required this.id,
    required this.name,
    required this.contact,
    required this.address,
    required this.contratType,
  });

  String get nom => name;
  String get telephone => contact;
  String get adresse => address;

  factory Client.fromMap(Map<String, dynamic> map) {
    try {
      return Client(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        contact: map['contact'] as String? ?? '',
        address: map['address'] as String? ?? '',
        contratType: map['contratType'] as String? ?? '',
      );
    } catch (e) {
      throw Exception('Erreur lors de la conversion des données client: $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'address': address,
      'contratType': contratType,
    };
  }

  // Méthode de validation
  List<String> validate() {
    final errors = <String>[];

    if (name.trim().isEmpty) {
      errors.add('Le nom du client est requis');
    }
    if (contact.trim().isEmpty) {
      errors.add('Le contact est requis');
    }
    if (address.trim().isEmpty) {
      errors.add('L\'adresse est requise');
    }
    if (contratType.trim().isEmpty) {
      errors.add('Le type de contrat est requis');
    }

    return errors;
  }

  // Méthode pour vérifier si le client est valide
  bool get isValid => validate().isEmpty;

  Client copyWith({
    String? id,
    String? name,
    String? contact,
    String? address,
    String? contratType,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      contratType: contratType ?? this.contratType,
    );
  }
}
