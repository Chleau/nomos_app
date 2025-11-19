import '../../domain/entities/commune.dart';

/// Modèle de données pour une commune
class CommuneModel extends Commune {
  const CommuneModel({
    required super.id,
    required super.nom,
    required super.codePostal,
    super.departement,
  });

  factory CommuneModel.fromJson(Map<String, dynamic> json) {
    return CommuneModel(
      id: json['id'] as int,
      nom: json['nom'] as String,
      codePostal: json['code_postal'] as String,
      departement: json['departement'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'code_postal': codePostal,
      'departement': departement,
    };
  }
}

