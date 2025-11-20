import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../services/onboarding_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Configuration de l'animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Lancer l'animation
    _animationController.forward();

    // Vérifier l'authentification et naviguer
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Attendre minimum 2.5 secondes pour que l'utilisateur voie le splash
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // 🔥 MODIFICATION : Afficher l'onboarding à chaque lancement
    // Pour désactiver et afficher l'onboarding une seule fois, décommentez les lignes ci-dessous
    // et commentez la ligne "Navigator.of(context).pushReplacementNamed('/onboarding');"

    // final hasSeenOnboarding = await OnboardingService.hasSeenOnboarding();
    // if (!mounted) return;
    // if (!hasSeenOnboarding) {
    //   Navigator.of(context).pushReplacementNamed('/onboarding');
    //   return;
    // }

    // Toujours afficher l'onboarding
    Navigator.of(context).pushReplacementNamed('/onboarding');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6ECEF), // Fond gris clair de votre charte
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animé (SVG)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: SvgPicture.asset(
                      'assets/images/logo.svg',
                      colorFilter: const ColorFilter.mode(Color(0xFF053F5C), BlendMode.srcIn),
                      width: 250,
                      height: 250,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Nom de l'application
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                'Nomos',
                style: TextStyle(
                  color: Color(0xFF053F5C),
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Slogan
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                'Votre ville, vos signalements',
                style: TextStyle(
                  color: Color(0xFFF25F0D), // Bleu foncé
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Indicateur de chargement
            FadeTransition(
              opacity: _fadeAnimation,
              child: const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF25F0D)), // Orange
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}