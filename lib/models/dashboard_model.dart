class DashboardStats {
  final int totalEleves;
  final int totalEnseignants;
  final int totalClasses;
  final int totalAbsences;
  final double totalRevenus;
  final double tauxReussite;
  const DashboardStats({required this.totalEleves, required this.totalEnseignants, required this.totalClasses, required this.totalAbsences, required this.totalRevenus, required this.tauxReussite});
  factory DashboardStats.fromJson(Map<String, dynamic> json) { return DashboardStats(totalEleves: json['total_eleves'] ?? 0, totalEnseignants: json['total_enseignants'] ?? 0, totalClasses: json['total_classes'] ?? 0, totalAbsences: json['total_absences'] ?? 0, totalRevenus: (json['total_revenus'] ?? 0).toDouble(), tauxReussite: (json['taux_reussite'] ?? 0).toDouble()); }
}
