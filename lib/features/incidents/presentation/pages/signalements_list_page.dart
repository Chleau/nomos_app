import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/signalement.dart';
import '../providers/signalements_providers.dart';
import 'signalement_detail_page.dart';
import 'create_signalement_page.dart';

/// Page listant tous les signalements
class SignalementsListPage extends ConsumerStatefulWidget {
  const SignalementsListPage({super.key});

  @override
  ConsumerState<SignalementsListPage> createState() => _SignalementsListPageState();
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
        ref.read(signalementsNotifierProvider.notifier).loadSignalementsByCommune(user.communeId);
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
            .where((s) => s.statut?.toLowerCase() == _filterStatus.toLowerCase())
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
                _buildFilterChip('Tous', 'tous', filteredSignalements.length),
                const SizedBox(width: 8),
                _buildFilterChip('En attente', 'en_attente',
                  signalementsState.signalements.where((s) => s.statut == 'en_attente').length),
                const SizedBox(width: 8),
                _buildFilterChip('En cours', 'en_cours',
                  signalementsState.signalements.where((s) => s.statut == 'en_cours').length),
                const SizedBox(width: 8),
                _buildFilterChip('Résolu', 'resolu',
                  signalementsState.signalements.where((s) => s.statut == 'resolu').length),
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
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
                                  ref.read(signalementsNotifierProvider.notifier)
                                      .loadSignalementsByCommune(user.communeId);
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
                                const Icon(Icons.inbox, size: 64, color: Colors.grey),
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
                                await ref.read(signalementsNotifierProvider.notifier)
                                    .loadSignalementsByCommune(user.communeId);
                              }
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredSignalements.length,
                              itemBuilder: (context, index) {
                                final signalement = filteredSignalements[index];
                                return _buildSignalementCard(signalement);
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

  Widget _buildFilterChip(String label, String value, int count) {
    final isSelected = _filterStatus == value;

    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
        });
      },
      selectedColor: const Color(0xFFF25F0D),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildSignalementCard(Signalement signalement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignalementDetailPage(signalement: signalement),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Miniature photo
              _buildThumbnail(signalement.url),
              const SizedBox(width: 12),

              // Contenu
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      signalement.titre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Description (aperçu)
                    if (signalement.description != null && signalement.description!.isNotEmpty)
                      Text(
                        signalement.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),

                    // Date et statut
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd/MM/yyyy').format(signalement.dateSignalement),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        _buildSmallStatusBadge(signalement.statut ?? 'en_attente'),
                      ],
                    ),
                  ],
                ),
              ),

              // Flèche
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.image_not_supported, color: Colors.grey.shade400),
      );
    }

    // Si c'est une image base64
    if (url.startsWith('data:image')) {
      try {
        final base64String = url.split(',')[1];
        final bytes = base64.decode(base64String);

        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: MemoryImage(bytes),
              fit: BoxFit.cover,
            ),
          ),
        );
      } catch (e) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.broken_image, color: Colors.grey.shade400),
        );
      }
    }

    // URL classique
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSmallStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'en_attente':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        label = 'En attente';
        break;
      case 'en_cours':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        label = 'En cours';
        break;
      case 'resolu':
      case 'résolu':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        label = 'Résolu';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
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
            _buildFilterOption('Tous', 'tous'),
            _buildFilterOption('En attente', 'en_attente'),
            _buildFilterOption('En cours', 'en_cours'),
            _buildFilterOption('Résolu', 'resolu'),
            _buildFilterOption('Rejeté', 'rejete'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, String value) {
    final isSelected = _filterStatus == value;

    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFFF25F0D) : Colors.black87,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: Color(0xFFF25F0D)) : null,
      onTap: () {
        setState(() {
          _filterStatus = value;
        });
        Navigator.pop(context);
      },
    );
  }
}

