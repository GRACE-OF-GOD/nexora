class EnseignantModel {
  final String id;
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String specialite;
  const EnseignantModel({required this.id, required this.nom, required this.prenom, required this.telephone, required this.email, required this.specialite});
  factory EnseignantModel.fromJson(Map<String, dynamic> json) { return EnseignantModel(id: json['idEnseignant'] ?? '', nom: json['nom'] ?? '', prenom: json['prenom'] ?? '', telephone: json['telephone'] ?? '', email: json['email'] ?? '', specialite: json['specialite'] ?? ''); }
  String get fullName => prenom + ' ' + nom;
}
