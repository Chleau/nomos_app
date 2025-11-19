import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomos_app/features/laws/presentation/providers/laws_provider.dart';
import 'package:intl/intl.dart';

class LawsPage extends ConsumerWidget {
  const LawsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lawsAsync = ref.watch(recentLawsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dernières lois en vigueur'),
      ),
      body: lawsAsync.when(
        data: (laws) {
          if (laws.isEmpty) {
            return const Center(
              child: Text('Aucune loi disponible'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: laws.length,
            itemBuilder: (context, index) {
              final law = laws[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    law.titre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Thématique: ${law.thematique}'),
                      if (law.dateMiseAJour != null)
                        Text(
                          'Mise à jour: ${DateFormat('dd/MM/yyyy').format(law.dateMiseAJour!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  // trailing: const Icon(Icons.arrow_forward_ios),
                  // onTap: () {
                  //   // Navigation vers les détails si besoin
                  //   showDialog(
                  //     context: context,
                  //     builder: (context) => AlertDialog(
                  //       title: Text(law.titre),
                  //       content: SingleChildScrollView(
                  //         child: Text(law.contenu),
                  //       ),
                  //       actions: [
                  //         TextButton(
                  //           onPressed: () => Navigator.pop(context),
                  //           child: const Text('Fermer'),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Erreur: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(recentLawsProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
