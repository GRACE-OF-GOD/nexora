 class BulletinModel {
  final String id;
  final int trimestre;
  final double moyenneGenerale;
  final int rang;
  final String mention;
  final String idEleve;
  final String nomEleve;
  final String prenomEleve;
  final String libelleClasse;
  final List<Map<String, dynamic>> notes;

  const BulletinModel({
    required this.id,
    required this.trimestre,
    required this.moyenneGenerale,
    required this.rang,
    required this.mention,
    required this.idEleve,
    required this.nomEleve,
    required this.prenomEleve,
    required this.libelleClasse,
    required this.notes,
  });

  String get fullName => '$prenomEleve $nomEleve';

  factory BulletinModel.fromJson(Map<String, dynamic> json) {
    return BulletinModel(
      id: json['idBulletin'] ?? '',
      trimestre: json['trimestre'] ?? 0,
      moyenneGenerale: double.tryParse(json['moyenneGenerale']?.toString() ?? '0') ?? 0.0,
      rang: json['rang'] ?? 0,
      mention: json['mention'] ?? '',
      idEleve: json['idEleve'] ?? '',
      nomEleve: json['eleve']?['nom'] ?? '',
      prenomEleve: json['eleve']?['prenom'] ?? '',
      libelleClasse: json['eleve']?['classe']?['libelle'] ?? '',
      notes: List<Map<String, dynamic>>.from(json['notes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idBulletin': id,
      'trimestre': trimestre,
      'moyenneGenerale': moyenneGenerale.toString(),
      'rang': rang,
      'mention': mention,
      'idEleve': idEleve,
    };
  }
}