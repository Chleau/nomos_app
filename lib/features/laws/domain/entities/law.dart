/// User entity (Habitant)
class Law {
  final int id;
  final String titre;
  final String contenu;
  final String thematique;
  final DateTime? dateMiseAJour;

  Law({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.thematique,
    this.dateMiseAJour,
  });
}
