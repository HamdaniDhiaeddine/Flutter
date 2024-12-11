class User {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String role;
  late final bool isBanned;
  final String? dateDeNaissance; // Nullable because some users may not have this info
  final String? genre;           // Nullable gender field
  final String? numeroTelephone; // Nullable phone number
  final String? adresse;         // Nullable address
  final String? institution;     // Nullable institution name
  final String? photo;           // Nullable photo URL

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    required this.isBanned,
    this.dateDeNaissance,
    this.genre,
    this.numeroTelephone,
    this.adresse,
    this.institution,
    this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user', // Default to 'user' if not specified
      isBanned: json['isBanned'] ?? false,
      dateDeNaissance: json['date_de_naissance'], // Use null if not present
      genre: json['genre'],
      numeroTelephone: json['numero_telephone'],
      adresse: json['adresse'],
      institution: json['institution'],
      photo: json['photo'],
    );
  }

  // Convert User object to JSON-like Map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'role': role,
      'isBanned': isBanned,
      'date_de_naissance': dateDeNaissance,
      'genre': genre,
      'numero_telephone': numeroTelephone,
      'adresse': adresse,
      'institution': institution,
      'photo': photo,
    };
  }
}
