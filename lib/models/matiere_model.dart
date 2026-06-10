class MatiereModel {
  final String id;
  final String libelle;
  final int coefficient;
  const MatiereModel({required this.id, required this.libelle, required this.coefficient});
  factory MatiereModel.fromJson(Map<String, dynamic> json) { return MatiereModel(id: json['idMatiere'] ?? '', libelle: json['libelle'] ?? '', coefficient: json['coefficient'] ?? 1); }
}
