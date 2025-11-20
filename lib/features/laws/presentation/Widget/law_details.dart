// lib/features/laws/presentation/widgets/law_details_dialog.dart
import 'package:flutter/material.dart';
import '../../domain/entities/law.dart';

class LawDetailsDialog extends StatelessWidget {
  final Law law;

  const LawDetailsDialog({
    super.key,
    required this.law,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(law.titre),
      content: SingleChildScrollView(
        child: Text(law.contenu),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}
