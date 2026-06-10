class NoteModel {
  final String id;
  final double valeur;
  final String typeEvaluation;
  final String dateEvaluation;
  final String idEleve;
  final String nomEleve;
  final String prenomEleve;
  final String idMatiere;
  final String libelleMatiere;
  const NoteModel({required this.id, required this.valeur, required this.typeEvaluation, required this.dateEvaluation, required this.idEleve, required this.nomEleve, required this.prenomEleve, required this.idMatiere, required this.libelleMatiere});
  factory NoteModel.fromJson(Map<String, dynamic> json) { return NoteModel(id: json['idNote'] ?? '', valeur: (json['valeur'] ?? 0).toDouble(), typeEvaluation: json['typeEvaluation'] ?? '', dateEvaluation: json['dateEvaluation'] ?? '', idEleve: json['idEleve'] ?? '', nomEleve: json['eleve']?['nom'] ?? '', prenomEleve: json['eleve']?['prenom'] ?? '', idMatiere: json['idMatiere'] ?? '', libelleMatiere: json['matiere']?['libelle'] ?? ''); }
}
