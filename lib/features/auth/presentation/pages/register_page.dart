import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../notifier/auth_state.dart';
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
        Navigator.of(context).pop(); // Retour à la page précédente
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
              const Text(
                'Créer un compte',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
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
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Champ de recherche de commune avec autocomplete
              Consumer(
                builder: (context, ref, child) {
                  final communesAsync = ref.watch(communesProvider);

                  return communesAsync.when(
                    data: (communes) => Autocomplete<Commune>(
                      displayStringForOption: (commune) => commune.toString(),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<Commune>.empty();
                        }
                        return communes.where((commune) {
                          final searchLower = textEditingValue.text.toLowerCase();
                          return commune.nom.toLowerCase().contains(searchLower) ||
                                 commune.codePostal.contains(textEditingValue.text);
                        });
                      },
                      onSelected: (Commune commune) {
                        setState(() {
                          _selectedCommune = commune;
                        });
                      },
                      fieldViewBuilder: (
                        BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        return TextFormField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Commune',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.location_city),
                            helperText: 'Recherchez votre commune par nom ou code postal',
                            suffixIcon: _selectedCommune != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      fieldTextEditingController.clear();
                                      setState(() {
                                        _selectedCommune = null;
                                      });
                                    },
                                  )
                                : null,
                          ),
                          validator: (value) {
                            if (_selectedCommune == null) {
                              return 'Veuillez sélectionner une commune';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    loading: () => TextFormField(
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Commune',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                        helperText: 'Chargement des communes...',
                        suffixIcon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                    ),
                    error: (error, stack) => TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Commune',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.error, color: Colors.red),
                        helperText: 'Erreur de chargement des communes',
                        errorText: error.toString(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _performRegister,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('S\'inscrire'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Déjà un compte ? Se connecter'),
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

