import 'package:flutter/material.dart';

/// Widget de champ email réutilisable pour l'authentification
class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final bool autofocus;

  const EmailField({
    super.key,
    required this.controller,
    this.labelText = 'Email',
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer votre email';
        }
        if (!value.contains('@')) {
          return 'Veuillez entrer un email valide';
        }
        return null;
      },
    );
  }
}

