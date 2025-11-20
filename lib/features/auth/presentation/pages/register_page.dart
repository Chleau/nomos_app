import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../notifier/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/name_field.dart';
import '../widgets/commune_search_field.dart';
import '../../domain/entities/commune.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  Commune? _selectedCommune;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Écouter les changements d'état
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (next.isAuthenticated && next.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bienvenue ${next.user!.fullName}!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigation vers la page principale après inscription réussie
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const AuthHeader(
                title: 'Créer un compte',
                subtitle: 'Rejoignez votre commune',
              ),
              const SizedBox(height: 32),
              NameField(
                controller: _prenomController,
                labelText: 'Prénom',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              NameField(
                controller: _nomController,
                labelText: 'Nom',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              EmailField(controller: _emailController),
              const SizedBox(height: 16),
              PasswordField(controller: _passwordController),
              const SizedBox(height: 16),
              CommuneSearchField(
                onCommuneSelected: (commune) {
                  setState(() {
                    _selectedCommune = commune;
                  });
                },
              ),
              const SizedBox(height: 24),
              AuthButton(
                onPressed: _performRegister,
                text: 'S\'inscrire',
                isLoading: authState.isLoading,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Déjà un compte ? Se connecter',
                  style: TextStyle(fontSize: 16, color: Color(0xFF053F5C)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performRegister() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCommune == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner une commune'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final nom = _nomController.text.trim();
      final prenom = _prenomController.text.trim();
      final communeId = _selectedCommune!.id;

      ref.read(authNotifierProvider.notifier).register(
            email: email,
            password: password,
            nom: nom,
            prenom: prenom,
            communeId: communeId,
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    super.dispose();
  }
}
