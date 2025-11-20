import 'dart:io';
import '../../domain/entities/signalement.dart';
import '../../domain/entities/type_signalement.dart';
import '../../domain/repositories/signalement_repository.dart';
import '../datasources/signalement_remote_datasource.dart';

/// Implémentation du repository pour les signalements
class SignalementRepositoryImpl implements SignalementRepository {
  final SignalementRemoteDataSource remoteDataSource;

  SignalementRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TypeSignalement>> getTypesSignalement() async {
    try {
      return await remoteDataSource.getTypesSignalement();
    } catch (e) {
      throw Exception('Erreur repository: $e');
    }
  }

  @override
  Future<List<Signalement>> getAllSignalements() async {
    try {
      return await remoteDataSource.getAllSignalements();
    } catch (e) {
      throw Exception('Erreur repository: $e');
    }
  }

  @override
  Future<List<Signalement>> getSignalementsByCommuneId(int communeId) async {
    try {
      return await remoteDataSource.getSignalementsByCommuneId(communeId);
    } catch (e) {
      throw Exception('Erreur repository: $e');
    }
  }

  @override
  Future<List<Signalement>> getSignalementsByHabitantId(int habitantId) async {
    try {
      return await remoteDataSource.getSignalementsByHabitantId(habitantId);
    } catch (e) {
      throw Exception('Erreur repository: $e');
    }
  }

  @override
  Future<Signalement?> getSignalementById(int id) async {
    try {
      return await remoteDataSource.getSignalementById(id);
    } catch (e) {
      throw Exception('Erreur repository: $e');
    }
  }

  @override
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
  }) async {
    try {
      final data = {
        'habitant_id': habitantId,
        'commune_id': communeId,
        'titre': titre,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'type_id': typeId,
        'priorite': priorite,
        'statut': 'en_attente',
        'valide': false,
        'url': url,
        'nom': nom,
        'prenom': prenom,
        'telephone': telephone,
        'email': email,
      };

      return await remoteDataSource.createSignalement(data);
    } catch (e) {
      throw Exception('Erreur repository: $e');
    }
  }

  @override
  Future<Signalement> updateSignalement(int id, Map<String, dynamic> updates) async {
    try {
      return await remoteDataSource.updateSignalement(id, updates);
    } catch (e) {
      throw Exception('Erreur repository: $e');
    }
  }

  @override
  Future<void> deleteSignalement(int id) async {
    try {
      return await remoteDataSource.deleteSignalement(id);
    } catch (e) {
      throw Exception('Erreur repository: $e');
    }
  }

  @override
  Future<String> uploadPhotoBase64(File photo) async {
    try {
      // Générer un nom de fichier unique
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload de la photo et retour de l'URL base64
      return await remoteDataSource.uploadPhoto(photo, fileName);
    } catch (e) {
      throw Exception('Erreur lors de l\'upload de la photo: $e');
    }
  }
}

