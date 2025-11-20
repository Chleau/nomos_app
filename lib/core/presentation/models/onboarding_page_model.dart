import 'package:flutter/material.dart';

/// Modèle représentant une page d'onboarding
class OnboardingPageModel {
  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const OnboardingPageModel({
    required this.title,
    required this.description,
    required this.icon,
    this.backgroundColor = const Color(0xFFE6ECEF),
    this.iconColor = const Color(0xFFF25F0D),
  });
}

