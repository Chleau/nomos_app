import 'package:flutter/material.dart';

/// Widget de champ mot de passe réutilisable pour l'authentification
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? helperText;
  final int minLength;

  const PasswordField({
    super.key,
    required this.controller,
    this.labelText = 'Mot de passe',
    this.helperText,
    this.minLength = 6,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock),
        helperText: widget.helperText,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer un mot de passe';
        }
        if (value.length < widget.minLength) {
          return 'Le mot de passe doit contenir au moins ${widget.minLength} caractères';
        }
        return null;
      },
    );
  }
}

