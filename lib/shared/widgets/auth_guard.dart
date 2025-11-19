import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/pages/login_page.dart';

/// Widget de garde qui vérifie l'état d'authentification au démarrage
class AuthGuard extends ConsumerStatefulWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  ConsumerState<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends ConsumerState<AuthGuard> {
  @override
  void initState() {
    super.initState();
    // Vérifier l'état d'authentification au démarrage
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Afficher un écran de chargement pendant la vérification
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Si l'utilisateur est authentifié, afficher l'app
    if (authState.isAuthenticated && authState.user != null) {
      return widget.child;
    }

    // Sinon, afficher la page de connexion
    return const LoginPage();
  }
}
