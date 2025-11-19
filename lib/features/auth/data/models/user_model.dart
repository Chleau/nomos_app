import '../../domain/entities/user.dart';

/// User data model (Habitant Model)
class UserModel extends User {
  UserModel({
    required int id,
    required String authUserId,
    required String email,
    required String nom,
    required String prenom,
    required int communeId,
    required String role,
    required DateTime createdAt,
  }) : super(
          id: id,
          authUserId: authUserId,
          email: email,
          nom: nom,
          prenom: prenom,
          communeId: communeId,
          role: role,
          createdAt: createdAt,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      authUserId: json['auth_user_id'] as String,
      email: json['email'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      communeId: json['commune_id'] as int,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth_user_id': authUserId,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'commune_id': communeId,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  User toEntity() {
    return User(
      id: id,
      authUserId: authUserId,
      email: email,
      nom: nom,
      prenom: prenom,
      communeId: communeId,
      role: role,
      createdAt: createdAt,
    );
  }
}
