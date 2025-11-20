import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/onboarding_page_model.dart';
import '../widgets/onboarding_page_widget.dart';
import '../../../features/auth/presentation/providers/auth_providers.dart';

/// Page d'onboarding affichée au lancement de l'app
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Liste des pages d'onboarding
  final List<OnboardingPageModel> _pages = const [
    OnboardingPageModel(
      title: 'Bienvenue sur Nomos',
      description:
          'Votre application citoyenne pour signaler les problèmes de votre ville et contribuer à son amélioration.',
      icon: Icons.waving_hand,
      iconColor: Color(0xFFF25F0D),
    ),
    OnboardingPageModel(
      title: 'Signalez facilement',
      description:
          'Prenez une photo, ajoutez une description et localisez le problème en quelques secondes. Nid-de-poule, éclairage défectueux, déchets...',
      icon: Icons.camera_alt,
      iconColor: Color(0xFF053F5C),
    ),
    OnboardingPageModel(
      title: 'Suivez vos signalements',
      description:
          'Consultez l\'état de vos signalements et ceux de votre commune en temps réel. Soyez informé des résolutions.',
      icon: Icons.timeline,
      iconColor: Color(0xFFF25F0D),
    ),
    OnboardingPageModel(
      title: 'Devenez un acteur engagé',
      description:
          'Plus vous signalez, plus votre niveau d\'acteur citoyen augmente. Participez activement à l\'amélioration de votre ville !',
      icon: Icons.stars,
      iconColor: Color(0xFF053F5C),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    if (!mounted) return;

    // Vérifier l'authentification et naviguer directement
    await ref.read(authNotifierProvider.notifier).checkAuthStatus();

    if (!mounted) return;

    final authState = ref.read(authNotifierProvider);

    // Navigation en fonction de l'état d'authentification
    if (authState.isAuthenticated && authState.user != null) {
      // Utilisateur connecté → aller à la page principale
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      // Utilisateur non connecté → aller à la page de login
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Bouton Passer (skip)
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: const Text(
                  'Passer',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF053F5C),
                  ),
                ),
              ),
            ),

            // Pages d'onboarding
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(page: _pages[index]);
                },
              ),
            ),

            // Indicateur de page
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: const WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Color(0xFFF25F0D),
                  dotColor: Colors.grey,
                ),
              ),
            ),

            // Boutons de navigation
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bouton Précédent
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text(
                        'Précédent',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF053F5C),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),

                  // Bouton Suivant / Commencer
                  ElevatedButton(
                    onPressed: isLastPage ? _finishOnboarding : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF25F0D),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      isLastPage ? 'Commencer' : 'Suivant',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

