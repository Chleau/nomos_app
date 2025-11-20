import 'package:flutter/material.dart';
import '../models/onboarding_page_model.dart';

/// Widget pour une page individuelle de l'onboarding
class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageModel page;

  const OnboardingPageWidget({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: page.backgroundColor,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: 100,
              color: page.iconColor,
            ),
          ),
          const SizedBox(height: 60),

          // Titre
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF053F5C),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

