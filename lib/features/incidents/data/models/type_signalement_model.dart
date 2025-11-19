import '../../domain/entities/type_signalement.dart';

/// Modèle pour les types de signalement
class TypeSignalementModel extends TypeSignalement {
  const TypeSignalementModel({
    required super.id,
    required super.libelle,
    required super.createdAt,
  });

  factory TypeSignalementModel.fromJson(Map<String, dynamic> json) {
    return TypeSignalementModel(
      id: json['id'] as int,
      libelle: json['libelle'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

