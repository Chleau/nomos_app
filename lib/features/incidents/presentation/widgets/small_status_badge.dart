// dart
import 'package:flutter/material.dart';

class SmallStatusBadge extends StatelessWidget {
  final String status;

  const SmallStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'en_attente':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        label = 'En attente';
        break;
      case 'en_cours':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        label = 'En cours';
        break;
      case 'resolu':
      case 'résolu':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        label = 'Résolu';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }
}