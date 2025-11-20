import 'package:flutter/material.dart';
import '../../domain/entities/signalement.dart';

/// Widget affichant les détails d'un incident dans une modale
class IncidentDetailsSheet extends StatelessWidget {
  final Signalement signalement;

  const IncidentDetailsSheet({
    super.key,
    required this.signalement,
  });

  Color _getColorByStatut(String statut) {
    switch (statut.toLowerCase()) {
      case 'en_attente':
        return Colors.orange;
      case 'en_cours':
        return Colors.blue;
      case 'resolu':
        return Colors.green;
      case 'rejete':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatutLabel(String statut) {
    switch (statut.toLowerCase()) {
      case 'en_attente':
        return 'En attente';
      case 'en_cours':
        return 'En cours';
      case 'resolu':
        return 'Résolu';
      case 'rejete':
        return 'Rejeté';
      default:
        return statut;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              signalement.titre,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (signalement.description != null) ...[
              Text(
                signalement.description!,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: _getColorByStatut(signalement.statut ?? 'en_attente'),
                ),
                const SizedBox(width: 8),
                Text(
                  _getStatutLabel(signalement.statut ?? 'en_attente'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Créé le ${_formatDate(signalement.dateSignalement)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (signalement.fullName != null) ...[
              const SizedBox(height: 8),
              Text(
                'Signalé par: ${signalement.fullName}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
