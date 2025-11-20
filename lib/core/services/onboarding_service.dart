import 'package:shared_preferences/shared_preferences.dart';

/// Service pour gérer le stockage local de l'état de l'onboarding
class OnboardingService {
  static const String _onboardingKey = 'has_seen_onboarding';

  /// Vérifie si l'utilisateur a déjà vu l'onboarding
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  /// Marque l'onboarding comme vu
  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  /// Réinitialise l'onboarding (pour le développement/tests)
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingKey);
  }
}

