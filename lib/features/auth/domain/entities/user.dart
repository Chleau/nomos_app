/// User entity (Habitant)
class User {
  final int id;
  final String authUserId;
  final String email;
  final String nom;
  final String prenom;
  final int communeId;
  final String role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.authUserId,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.communeId,
    required this.role,
    required this.createdAt,
  });

  String get fullName => '$prenom $nom';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
