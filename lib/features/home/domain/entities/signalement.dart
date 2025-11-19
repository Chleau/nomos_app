/// Entité représentant un signalement
class Signalement {
  final int id;
  final int? habitantId;
  final int? communeId;
  final String titre;
  final String? description;
  final DateTime dateSignalement;
  final String? statut;
  final bool valide;

  const Signalement({
    required this.id,
    this.habitantId,
    this.communeId,
    required this.titre,
    this.description,
    required this.dateSignalement,
    this.statut,
    required this.valide,
  });
}

