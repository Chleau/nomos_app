import 'package:flutter/material.dart';

/// Widget affichant le niveau d'engagement de l'utilisateur
class ActorLevelWidget extends StatelessWidget {
  final int userSignalements;
  final int communeSignalements;

  const ActorLevelWidget({
    super.key,
    required this.userSignalements,
    required this.communeSignalements,
  });

  /// Calcule le pourcentage de contribution
  double get contributionPercentage {
    if (communeSignalements == 0) return 0.0;
    return (userSignalements / communeSignalements * 100).clamp(0.0, 100.0);
  }

  /// Détermine le niveau en fonction du pourcentage
  String get niveau {
    if (contributionPercentage >= 20) return 'Expert';
    if (contributionPercentage >= 10) return 'Acteur confirmé';
    if (contributionPercentage >= 5) return 'Acteur engagé';
    if (contributionPercentage >= 1) return 'Citoyen actif';
    return 'Débutant';
  }

  /// Emoji correspondant au niveau
  String get emoji {
    if (contributionPercentage >= 20) return '🏆';
    if (contributionPercentage >= 10) return '⭐';
    if (contributionPercentage >= 5) return '🌟';
    if (contributionPercentage >= 1) return '👤';
    return '🌱';
  }

  /// Couleur du badge selon le niveau
  Color get badgeColor {
    if (contributionPercentage >= 20) return Colors.amber;
    if (contributionPercentage >= 10) return Colors.orange;
    if (contributionPercentage >= 5) return Colors.blue;
    if (contributionPercentage >= 1) return Colors.green;
    return Colors.grey;
  }

  /// Message d'encouragement
  String get message {
    if (contributionPercentage >= 20) {
      return 'Vous êtes un pilier de votre commune !';
    } else if (contributionPercentage >= 10) {
      return 'Votre engagement fait la différence !';
    } else if (contributionPercentage >= 5) {
      return 'Vous contribuez activement à votre commune.';
    } else if (contributionPercentage >= 1) {
      return 'Continuez à participer !';
    } else {
      return 'Faites vos premiers signalements pour progresser.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              badgeColor.withOpacity(0.7),
              badgeColor.withOpacity(0.4),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Titre
            const Text(
              'Vous êtes un acteur engagé',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'pour votre commune',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Badge et niveau
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      niveau,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${contributionPercentage.toStringAsFixed(1)}% des signalements',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Barre de progression
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: contributionPercentage / 100,
                minHeight: 8,
                backgroundColor: Colors.white30,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}

