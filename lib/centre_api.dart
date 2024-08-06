class Etablissement {
  final int id;
  final String nom;
  final String localite;
  final String telephone;
  final String email;
  final String? image;

  Etablissement({
    required this.id,
    required this.nom,
    required this.localite,
    required this.telephone,
    required this.email,
    this.image,
  });

  factory Etablissement.fromJson(Map<String, dynamic> json) {
    return Etablissement(
      id: json['id'],
      nom: json['nom'],
      localite: json['localite'],
      telephone: json['telephone'],
      email: json['email'],
      image: json['image'],
    );
  }
}
