import 'package:flutter/material.dart';

/// Widget représentant l'icône d'un marqueur d'incident sur la carte
class IncidentMarkerIcon extends StatelessWidget {
  final String statut;
  final VoidCallback onTap;

  const IncidentMarkerIcon({
    super.key,
    required this.statut,
    required this.onTap,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.location_on,
        color: _getColorByStatut(statut),
        size: 40,
      ),
    );
  }
}
