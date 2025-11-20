import 'package:flutter/material.dart';
import 'package:nomos_app/features/incidents/presentation/pages/carte_incidents_page.dart';
import '../../../laws/presentation/pages/laws_page.dart';
import '../../../incidents/presentation/pages/signalements_list_page.dart';
import 'navigation_button.dart';

/// Section des boutons de navigation de la HomePage
class NavigationButtonsSection extends StatelessWidget {
  final Function(int)? onNavigate;

  const NavigationButtonsSection({
    super.key,
    this.onNavigate,
  });

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
                  // Si callback fourni, l'utiliser (navigation via bottom bar)
                  // Sinon, utiliser Navigator.push (fallback)
                  if (onNavigate != null) {
                    onNavigate!(1); // Index 1 = Carte
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CarteIncidentsPage(),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: NavigationButton(
                icon: Icons.gavel,
                label: 'Lois en vigueur',
                onPressed: () {
                  // Si callback fourni, l'utiliser (navigation via bottom bar)
                  // Sinon, utiliser Navigator.push (fallback)
                  if (onNavigate != null) {
                    onNavigate!(2); // Index 2 = Lois
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LawsPage(),
                      ),
                    );
                  }
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
              // Navigation vers la page de signalements
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

