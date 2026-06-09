class ClasseModel {
  final String id;
  final String libelle;
  final String niveau;
  final String anneeScolaire;
  const ClasseModel({required this.id, required this.libelle, required this.niveau, required this.anneeScolaire});
  factory ClasseModel.fromJson(Map<String, dynamic> json) { return ClasseModel(id: json['idClasse'] ?? '', libelle: json['libelle'] ?? '', niveau: json['niveau'] ?? '', anneeScolaire: json['anneeScolaire'] ?? ''); }
}
