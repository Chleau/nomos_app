import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_all_signalements_usecase.dart';
import '../../domain/usecases/get_signalements_by_commune_usecase.dart';
import '../../domain/usecases/create_signalement_usecase.dart';
import '../../domain/usecases/upload_photo_usecase.dart';
import '../../domain/usecases/get_types_signalement_usecase.dart';
import 'signalements_state.dart';

/// Notifier pour gérer l'état des signalements
class SignalementsNotifier extends StateNotifier<SignalementsState> {
  final GetAllSignalementsUseCase getAllSignalementsUseCase;
  final GetSignalementsByCommuneUseCase getSignalementsByCommuneUseCase;
  final CreateSignalementUseCase createSignalementUseCase;
  final UploadPhotoUseCase uploadPhotoUseCase;
  final GetTypesSignalementUseCase getTypesSignalementUseCase;

  SignalementsNotifier({
    required this.getAllSignalementsUseCase,
    required this.getSignalementsByCommuneUseCase,
    required this.createSignalementUseCase,
    required this.uploadPhotoUseCase,
    required this.getTypesSignalementUseCase,
  }) : super(const SignalementsState());

  /// Charge les types de signalement
  Future<void> loadTypesSignalement() async {
    try {
      final types = await getTypesSignalementUseCase();
      state = state.copyWith(typesSignalement: types);
    } catch (e) {
      // On ne bloque pas si les types ne chargent pas
      print('Erreur lors du chargement des types: $e');
    }
  }

  // ...existing code...

  /// Charge tous les signalements
  Future<void> loadAllSignalements() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final signalements = await getAllSignalementsUseCase();

      state = state.copyWith(
        isLoading: false,
        signalements: signalements,
        filteredSignalements: signalements,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement: ${e.toString()}',
      );
    }
  }

  /// Charge les signalements d'une commune
  Future<void> loadSignalementsByCommune(int communeId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final signalements = await getSignalementsByCommuneUseCase(communeId);

      state = state.copyWith(
        isLoading: false,
        signalements: signalements,
        filteredSignalements: signalements,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement: ${e.toString()}',
      );
    }
  }

  /// Crée un nouveau signalement
  Future<bool> createSignalement({
    required int habitantId,
    required int communeId,
    required String titre,
    String? description,
    double? latitude,
    double? longitude,
    int? typeId,
    String? priorite,
    String? nom,
    String? prenom,
    String? email,
    String? telephone,
    File? photo,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final signalement = await createSignalementUseCase(
        habitantId: habitantId,
        communeId: communeId,
        titre: titre,
        description: description,
        latitude: latitude,
        longitude: longitude,
        typeId: typeId,
        priorite: priorite,
        nom: nom,
        prenom: prenom,
        email: email,
        telephone: telephone,
      );

      // Si une photo est fournie, tenter de l'uploader (non bloquant)
      print('🔍 Vérification photo: photo = ${photo != null ? "présente (${photo.path})" : "null"}');
      if (photo != null) {
        print('Début upload photo pour signalement ID: ${signalement.id}');
        try {
          final photoUrl = await uploadPhotoUseCase(photo, signalement.id);
          print('Photo uploadée avec succès! URL stockée dans signalement.url');
          print('   - URL (${photoUrl.length} caractères)');
        } catch (photoError) {
          // Log l'erreur mais ne bloque pas la création du signalement
          print('Erreur lors de l\'upload de la photo (non-bloquant): $photoError');
          // Note: La photo n'a pas été uploadée mais le signalement est créé
        }
      } else {
        print('ℹ️ Aucune photo à uploader');
      }

      // Recharger la liste après création
      await loadSignalementsByCommune(communeId);

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la création: ${e.toString()}',
      );
      return false;
    }
  }

  /// Rafraîchit les données
  Future<void> refresh({int? communeId}) async {
    if (communeId != null) {
      await loadSignalementsByCommune(communeId);
    } else {
      await loadAllSignalements();
    }
  }
}

