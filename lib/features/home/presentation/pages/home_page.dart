import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/home_providers.dart';
import '../widgets/actor_level_widget.dart';
import '../widgets/statistics_section.dart';
import '../widgets/navigation_buttons_section.dart';
import '../widgets/home_app_bar.dart';

/// Page d'accueil après authentification
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Charger les données au démarrage
    Future.microtask(() {
      final user = ref.read(authNotifierProvider).user;
      ref.read(homeNotifierProvider.notifier).loadHomeData(
            habitantId: user?.id,
            communeId: user?.communeId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final homeState = ref.watch(homeNotifierProvider);
    final user = authState.user;

    // Écouter les changements d'authentification pour rediriger après déconnexion
    ref.listen(authNotifierProvider, (previous, next) {
      // Si l'utilisateur était connecté et ne l'est plus, rediriger vers login
      if (previous?.isAuthenticated == true && !next.isAuthenticated) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });

    return Scaffold(
      appBar: const HomeAppBar(),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(homeNotifierProvider.notifier).refresh(
                    habitantId: user.id,
                    communeId: user.communeId,
                  ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Widget de niveau d'acteur
                    ActorLevelWidget(
                      userSignalements: homeState.userSignalementsCount,
                      communeSignalements: homeState.communeSignalementsCount,
                    ),
                    const SizedBox(height: 16),

                    // Section des statistiques
                    StatisticsSection(
                      userSignalementsCount: homeState.userSignalementsCount,
                      communeSignalementsCount: homeState.communeSignalementsCount,
                    ),
                    const SizedBox(height: 24),

                    // Section des boutons de navigation
                    const NavigationButtonsSection(),
                  ],
                ),
              ),
            ),
    );
  }
}
