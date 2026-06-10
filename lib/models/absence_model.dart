class AbsenceModel {
  final String id;
  final String dateAbsence;
  final String motif;
  final bool justifiee;
  final String idEleve;
  final String nomEleve;
  final String prenomEleve;
  const AbsenceModel({required this.id, required this.dateAbsence, required this.motif, required this.justifiee, required this.idEleve, required this.nomEleve, required this.prenomEleve});
  factory AbsenceModel.fromJson(Map<String, dynamic> json) { return AbsenceModel(id: json['idAbsence'] ?? '', dateAbsence: json['dateAbsence'] ?? '', motif: json['motif'] ?? '', justifiee: json['justifiee'] ?? false, idEleve: json['idEleve'] ?? '', nomEleve: json['eleve']?['nom'] ?? '', prenomEleve: json['eleve']?['prenom'] ?? ''); }
  String get fullName => prenomEleve + ' ' + nomEleve;
}
