/// Entité représentant les données de gamification d'un habitant
class Gamification {
  final int id;
  final int habitantId;
  final int points;
  final DateTime dateDernierUpdate;

  const Gamification({
    required this.id,
    required this.habitantId,
    required this.points,
    required this.dateDernierUpdate,
  });

  /// Niveau basé sur les points (1 niveau = 10 points)
  int get niveau => (points / 10).floor() + 1;

  /// Points nécessaires pour le prochain niveau
  int get pointsPourProchainNiveau => (niveau * 10) - points;

  /// Progression vers le prochain niveau (0-100%)
  double get progressionNiveau {
    final pointsNiveauActuel = (niveau - 1) * 10;
    final pointsNiveauSuivant = niveau * 10;
    final progression = (points - pointsNiveauActuel) / (pointsNiveauSuivant - pointsNiveauActuel);
    return progression.clamp(0.0, 1.0);
  }

  /// Badge basé sur le niveau
  String get badge {
    if (niveau >= 10) return '🏆 Expert';
    if (niveau >= 7) return '⭐ Avancé';
    if (niveau >= 4) return '🌟 Intermédiaire';
    return '🌱 Débutant';
  }
}

