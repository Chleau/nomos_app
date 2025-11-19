/// Entité représentant un type de signalement
class TypeSignalement {
  final int id;
  final String libelle;
  final DateTime createdAt;

  const TypeSignalement({
    required this.id,
    required this.libelle,
    required this.createdAt,
  });
}

