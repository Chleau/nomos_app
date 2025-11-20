import 'dart:io';
import '../entities/signalement.dart';
import '../entities/type_signalement.dart';

/// Repository abstrait pour la gestion des signalements
abstract class SignalementRepository {
  /// Récupère tous les types de signalements disponibles
  Future<List<TypeSignalement>> getTypesSignalement();

  /// Récupère tous les signalements
  Future<List<Signalement>> getAllSignalements();

  /// Récupère les signalements d'une commune spécifique
  Future<List<Signalement>> getSignalementsByCommuneId(int communeId);

  /// Récupère les signalements d'un habitant spécifique
  Future<List<Signalement>> getSignalementsByHabitantId(int habitantId);

  /// Récupère un signalement par son ID
  Future<Signalement?> getSignalementById(int id);

  /// Crée un nouveau signalement
  Future<Signalement> createSignalement({
    required int habitantId,
    required int communeId,
    required String titre,
    String? description,
    double? latitude,
    double? longitude,
    int? typeId,
    String? priorite,
    String? url,
    String? nom,
    String? prenom,
    String? telephone,
    String? email,
  });

  /// Met à jour un signalement
  Future<Signalement> updateSignalement(int id, Map<String, dynamic> updates);

  /// Supprime un signalement
  Future<void> deleteSignalement(int id);

  /// Upload une photo en base64 et retourne l'URL base64
  Future<String> uploadPhotoBase64(File photo);
}

