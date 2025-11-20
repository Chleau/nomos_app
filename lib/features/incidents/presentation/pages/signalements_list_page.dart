import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/signalements_providers.dart';
import 'create_signalement_page.dart';
import '../widgets/signalement_card.dart';
import '../widgets/signalement_filter_chip.dart';
import '../widgets/filter_option_tile.dart';

/// Page listant tous les signalements
class SignalementsListPage extends ConsumerStatefulWidget {
  const SignalementsListPage({super.key});

  @override
  ConsumerState<SignalementsListPage> createState() =>
      _SignalementsListPageState();
}

class _SignalementsListPageState extends ConsumerState<SignalementsListPage> {
  String _filterStatus = 'tous';

  @override
  void initState() {
    super.initState();
    // Charger les signalements au démarrage
    Future.microtask(() {
      final user = ref.read(authNotifierProvider).user;
      if (user != null) {
        ref
            .read(signalementsNotifierProvider.notifier)
            .loadSignalementsByCommune(user.communeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final signalementsState = ref.watch(signalementsNotifierProvider);
    final user = ref.watch(authNotifierProvider).user;

    // Filtrer les signalements selon le statut
    final filteredSignalements = _filterStatus == 'tous'
        ? signalementsState.signalements
        : signalementsState.signalements
            .where(
                (s) => s.statut?.toLowerCase() == _filterStatus.toLowerCase())
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE6ECEF),
      appBar: AppBar(
        title: const Text('Signalements'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres rapides
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                SignalementFilterChip(
                  label: 'Tous',
                  value: 'tous',
                  count: signalementsState.signalements.length,
                  selectedValue: _filterStatus,
                  onSelected: (value) => setState(() => _filterStatus = value),
                ),
                const SizedBox(width: 8),
                SignalementFilterChip(
                  label: 'En attente',
                  value: 'en_attente',
                  count: signalementsState.signalements
                      .where((s) => s.statut == 'en_attente')
                      .length,
                  selectedValue: _filterStatus,
                  onSelected: (value) => setState(() => _filterStatus = value),
                ),
                const SizedBox(width: 8),
                SignalementFilterChip(
                  label: 'En cours',
                  value: 'en_cours',
                  count: signalementsState.signalements
                      .where((s) => s.statut == 'en_cours')
                      .length,
                  selectedValue: _filterStatus,
                  onSelected: (value) => setState(() => _filterStatus = value),
                ),
                const SizedBox(width: 8),
                SignalementFilterChip(
                  label: 'Résolu',
                  value: 'resolu',
                  count: signalementsState.signalements
                      .where((s) => s.statut == 'resolu')
                      .length,
                  selectedValue: _filterStatus,
                  onSelected: (value) => setState(() => _filterStatus = value),
                ),
              ],
            ),
          ),

          // Liste des signalements
          Expanded(
            child: signalementsState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : signalementsState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              signalementsState.error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (user != null) {
                                  ref
                                      .read(
                                          signalementsNotifierProvider.notifier)
                                      .loadSignalementsByCommune(
                                          user.communeId);
                                }
                              },
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : filteredSignalements.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.inbox,
                                    size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  _filterStatus == 'tous'
                                      ? 'Aucun signalement'
                                      : 'Aucun signalement avec ce statut',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              if (user != null) {
                                await ref
                                    .read(signalementsNotifierProvider.notifier)
                                    .loadSignalementsByCommune(user.communeId);
                              }
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredSignalements.length,
                              itemBuilder: (context, index) {
                                final signalement = filteredSignalements[index];
                                return SignalementCard(
                                    signalement: signalement);
                              },
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateSignalementPage(),
            ),
          );
        },
        backgroundColor: const Color(0xFFF25F0D),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau'),
      ),
    );
  }


  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrer par statut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilterOptionTile(
              label: 'Tous',
              value: 'tous',
              selectedValue: _filterStatus,
              onSelect: (value) => setState(() => _filterStatus = value),
            ),
            FilterOptionTile(
              label: 'En attente',
              value: 'en_attente',
              selectedValue: _filterStatus,
              onSelect: (value) => setState(() => _filterStatus = value),
            ),
            FilterOptionTile(
              label: 'En cours',
              value: 'en_cours',
              selectedValue: _filterStatus,
              onSelect: (value) => setState(() => _filterStatus = value),
            ),
            FilterOptionTile(
              label: 'Résolu',
              value: 'resolu',
              selectedValue: _filterStatus,
              onSelect: (value) => setState(() => _filterStatus = value),
            ),
            FilterOptionTile(
              label: 'Rejeté',
              value: 'rejete',
              selectedValue: _filterStatus,
              onSelect: (value) => setState(() => _filterStatus = value),
            ),
          ],
        ),
      ),
    );
  }
}
