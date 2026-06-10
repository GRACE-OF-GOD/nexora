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
  const BulletinModel({required this.id, required this.trimestre, required this.moyenneGenerale, required this.rang, required this.mention, required this.idEleve, required this.nomEleve, required this.prenomEleve, required this.libelleClasse, required this.notes});
  String get fullName => prenomEleve + ' ' + nomEleve;
}
