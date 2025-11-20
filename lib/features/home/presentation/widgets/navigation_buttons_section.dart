import 'package:flutter/material.dart';
import '../pages/interactive_map_page.dart';
import '../../../laws/presentation/pages/laws_page.dart';
import '../../../incidents/presentation/pages/signalements_list_page.dart';
import 'navigation_button.dart';

/// Section des boutons de navigation de la HomePage
class NavigationButtonsSection extends StatelessWidget {
  const NavigationButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Première ligne : Carte interactive + Lois en vigueur
        Row(
          children: [
            Expanded(
              child: NavigationButton(
                icon: Icons.map,
                label: 'Carte interactive',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InteractiveMapPage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: NavigationButton(
                icon: Icons.gavel,
                label: 'Lois en vigueur',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LawsPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Deuxième ligne : Signalements (pleine largeur)
        SizedBox(
          width: double.infinity,
          child: NavigationButton(
            icon: Icons.list_alt,
            label: 'Signalements sur ma commune',
            backgroundColor: const Color(0xFF053F5C),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignalementsListPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

