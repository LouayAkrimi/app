class Chauffeur {
  final String nom;
  final String prenom;
  final String camion;
  final String numeroPermis;
  final String telephone;
  final String email;
  final String experience;
  final String uid;

  Chauffeur({
    required this.nom,
    required this.prenom,
    required this.camion,
    required this.numeroPermis,
    required this.telephone,
    required this.email,
    required this.experience,
    required this.uid,
  });

  // Convertir en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'camion': camion,
      'numeroPermis': numeroPermis,
      'telephone': telephone,
      'email': email,
      'experience': experience,
      'uid': uid,
    };
  }

  // Convertir de Map vers l'objet Chauffeur
  factory Chauffeur.fromMap(Map<String, dynamic> map) {
    return Chauffeur(
      nom: map['nom'],
      prenom: map['prenom'],
      camion: map['camion'],
      numeroPermis: map['numeroPermis'],
      telephone: map['telephone'],
      email: map['email'],
      experience: map['experience'],
      uid: map['uid'],
    );
  }
}
