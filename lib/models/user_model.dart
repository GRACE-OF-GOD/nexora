class UserModel {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String role;
  final String token;
  const UserModel({required this.id, required this.nom, required this.prenom, required this.email, required this.role, required this.token});
  factory UserModel.fromJson(Map<String, dynamic> json, String token) { return UserModel(id: json['idUtilisateur'] ?? '', nom: json['nom'] ?? '', prenom: json['prenom'] ?? '', email: json['email'] ?? '', role: json['role'] ?? '', token: token); }
  String get fullName => prenom + ' ' + nom;
}

