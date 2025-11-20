import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/signalement.dart';

/// Page de détails d'un signalement
class SignalementDetailPage extends ConsumerWidget {
  final Signalement signalement;

  const SignalementDetailPage({
    super.key,
    required this.signalement,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6ECEF),
      appBar: AppBar(
        title: const Text('Détails du signalement'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo si disponible
            if (signalement.url != null && signalement.url!.isNotEmpty)
              _buildPhotoSection(signalement.url!),

            // Informations principales
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statut et Type
                  Row(
                    children: [
                      _buildStatusBadge(signalement.statut ?? 'en_attente'),
                      const SizedBox(width: 12),
                      if (signalement.priorite != null)
                        _buildPriorityBadge(signalement.priorite!),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Titre
                  Text(
                    signalement.titre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Signalé le ${DateFormat('dd/MM/yyyy à HH:mm').format(signalement.dateSignalement)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  if (signalement.description != null && signalement.description!.isNotEmpty) ...[
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        signalement.description!,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Localisation
                  if (signalement.latitude != null && signalement.longitude != null) ...[
                    const Text(
                      'Localisation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFFF25F0D)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Lat: ${signalement.latitude!.toStringAsFixed(6)}, Long: ${signalement.longitude!.toStringAsFixed(6)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Ouverture Google Maps à implémenter')),
                                );
                              },
                              icon: const Icon(Icons.map),
                              label: const Text('Voir sur la carte'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF25F0D),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Informations du signaleur
                  if (signalement.nom != null || signalement.email != null) ...[
                    const Text(
                      'Signalé par',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (signalement.prenom != null && signalement.nom != null)
                            _buildInfoRow(Icons.person, '${signalement.prenom} ${signalement.nom}'),
                          if (signalement.email != null)
                            _buildInfoRow(Icons.email, signalement.email!),
                          if (signalement.telephone != null)
                            _buildInfoRow(Icons.phone, signalement.telephone.toString()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Validation
                  if (signalement.valide) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Signalement validé',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                if (signalement.dateValidation != null)
                                  Text(
                                    'Le ${DateFormat('dd/MM/yyyy').format(signalement.dateValidation!)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green.shade600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(String url) {
    // Vérifier si c'est une image base64
    if (url.startsWith('data:image')) {
      try {
        final base64String = url.split(',')[1];
        final bytes = base64.decode(base64String);

        return GestureDetector(
          onTap: () {
          },
          child: Container(
            width: double.infinity,
            height: 300,
            color: Colors.black,
            child: Image.memory(
              bytes,
              fit: BoxFit.contain,
            ),
          ),
        );
      } catch (e) {
        return const SizedBox.shrink();
      }
    }

    // Si c'est une URL classique
    return Container(
      width: double.infinity,
      height: 300,
      color: Colors.black,
      child: Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
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
      case 'rejete':
      case 'rejeté':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        label = 'Rejeté';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (priority.toLowerCase()) {
      case 'haute':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        label = 'Haute';
        break;
      case 'moyenne':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        label = 'Moyenne';
        break;
      case 'basse':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        label = 'Basse';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        label = priority;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.priority_high, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

