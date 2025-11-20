import 'package:flutter/material.dart';

/// Widget de champ nom/prénom réutilisable
class NameField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;

  const NameField({
    super.key,
    required this.controller,
    required this.labelText,
    this.icon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer votre $labelText';
        }
        return null;
      },
    );
  }
}

