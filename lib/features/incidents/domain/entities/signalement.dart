/// Entité représentant un signalement (incident)
class Signalement {
  final int id;
  final DateTime createdAt;
  final int? habitantId;
  final int? communeId;
  final int? agentId;
  final String titre;
  final String? description;
  final double? latitude;
  final double? longitude;
  final int? typeId;
  final String? priorite;
  final String? statut;
  final DateTime dateSignalement;
  final DateTime? dateDernierSuivi;
  final bool valide;
  final int? validePar;
  final DateTime? dateValidation;
  final String? url;
  final String? nom;
  final String? prenom;
  final String? telephone;
  final String? email;

  const Signalement({
    required this.id,
    required this.createdAt,
    this.habitantId,
    this.communeId,
    this.agentId,
    required this.titre,
    this.description,
    this.latitude,
    this.longitude,
    this.typeId,
    this.priorite,
    this.statut,
    required this.dateSignalement,
    this.dateDernierSuivi,
    required this.valide,
    this.validePar,
    this.dateValidation,
    this.url,
    this.nom,
    this.prenom,
    this.telephone,
    this.email,
  });

  /// Vérifie si le signalement a une position géographique
  bool get hasLocation => latitude != null && longitude != null;

  /// Vérifie si le signalement est validé
  bool get isValidated => valide;

  /// Obtient le nom complet si disponible
  String? get fullName {
    if (nom != null && prenom != null) {
      return '$prenom $nom';
    }
    return nom ?? prenom;
  }
}

