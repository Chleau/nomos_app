/// Entité représentant une commune
class Commune {
  final int id;
  final String nom;
  final String codePostal;
  final String? departement;

  const Commune({
    required this.id,
    required this.nom,
    required this.codePostal,
    this.departement,
  });

  @override
  String toString() => '$nom ($codePostal)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Commune &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

