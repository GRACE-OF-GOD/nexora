class PaiementModel {
  final String id;
  final double montant;
  final String datePaiement;
  final String typeFrais;
  final String idEleve;
  final String nomEleve;
  final String prenomEleve;
  final String libelleClasse;
  const PaiementModel({required this.id, required this.montant, required this.datePaiement, required this.typeFrais, required this.idEleve, required this.nomEleve, required this.prenomEleve, required this.libelleClasse});
  factory PaiementModel.fromJson(Map<String, dynamic> json) { return PaiementModel(id: json['idPaiement'] ?? '', montant: (json['montant'] ?? 0).toDouble(), datePaiement: json['datePaiement'] ?? '', typeFrais: json['typeFrais'] ?? '', idEleve: json['idEleve'] ?? '', nomEleve: json['eleve']?['nom'] ?? '', prenomEleve: json['eleve']?['prenom'] ?? '', libelleClasse: json['eleve']?['classe']?['libelle'] ?? ''); }
  String get fullName => prenomEleve + ' ' + nomEleve;
}
