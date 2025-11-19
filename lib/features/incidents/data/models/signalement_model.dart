import '../../domain/entities/signalement.dart';

/// Modèle de données pour un signalement
class SignalementModel extends Signalement {
  const SignalementModel({
    required super.id,
    required super.createdAt,
    super.habitantId,
    super.communeId,
    super.agentId,
    required super.titre,
    super.description,
    super.latitude,
    super.longitude,
    super.typeId,
    super.priorite,
    super.statut,
    required super.dateSignalement,
    super.dateDernierSuivi,
    required super.valide,
    super.validePar,
    super.dateValidation,
    super.url,
    super.nom,
    super.prenom,
    super.telephone,
    super.email,
  });

  factory SignalementModel.fromJson(Map<String, dynamic> json) {
    return SignalementModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      habitantId: json['habitant_id'] as int?,
      communeId: json['commune_id'] as int?,
      agentId: json['agent_id'] as int?,
      titre: json['titre'] as String,
      description: json['description'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      typeId: json['type_id'] as int?,
      priorite: json['priorite'] as String?,
      statut: json['statut'] as String?,
      dateSignalement: json['date_signalement'] != null
          ? DateTime.parse(json['date_signalement'] as String)
          : DateTime.now(),
      dateDernierSuivi: json['date_dernier_suivi'] != null
          ? DateTime.parse(json['date_dernier_suivi'] as String)
          : null,
      valide: json['valide'] as bool? ?? false,
      validePar: json['valide_par'] as int?,
      dateValidation: json['date_validation'] != null
          ? DateTime.parse(json['date_validation'] as String)
          : null,
      url: json['url'] as String?,
      nom: json['nom'] as String?,
      prenom: json['prenom'] as String?,
      telephone: json['telephone']?.toString(),
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'habitant_id': habitantId,
      'commune_id': communeId,
      'agent_id': agentId,
      'titre': titre,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'type_id': typeId,
      'priorite': priorite,
      'statut': statut,
      'date_signalement': dateSignalement.toIso8601String(),
      'date_dernier_suivi': dateDernierSuivi?.toIso8601String(),
      'valide': valide,
      'valide_par': validePar,
      'date_validation': dateValidation?.toIso8601String(),
      'url': url,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
    };
  }
}

