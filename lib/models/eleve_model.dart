class EleveModel {
  final String id;
  final String matricule;
  final String nom;
  final String prenom;
  final String sexe;
  final String dateNaissance;
  final String telephone;
  final String adresse;
  final String idClasse;
  final String libelleClasse;
  const EleveModel({required this.id, required this.matricule, required this.nom, required this.prenom, required this.sexe, required this.dateNaissance, required this.telephone, required this.adresse, required this.idClasse, required this.libelleClasse});
  factory EleveModel.fromJson(Map<String, dynamic> json) { return EleveModel(id: json['idEleve'] ?? '', matricule: json['matricule'] ?? '', nom: json['nom'] ?? '', prenom: json['prenom'] ?? '', sexe: json['sexe'] ?? '', dateNaissance: json['dateNaissance'] ?? '', telephone: json['telephone'] ?? '', adresse: json['adresse'] ?? '', idClasse: json['idClasse'] ?? '', libelleClasse: json['classe']?['libelle'] ?? ''); }
  String get fullName => prenom + ' ' + nom;
}
