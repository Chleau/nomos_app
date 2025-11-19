import '../entities/signalement.dart';
import '../repositories/signalement_repository.dart';

/// Use case pour créer un nouveau signalement
class CreateSignalementUseCase {
  final SignalementRepository repository;

  CreateSignalementUseCase(this.repository);

  Future<Signalement> call({
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
    return await repository.createSignalement(
      habitantId: habitantId,
      communeId: communeId,
      titre: titre,
      description: description,
      latitude: latitude,
      longitude: longitude,
      typeId: typeId,
      priorite: priorite,
      url: url,
      nom: nom,
      prenom: prenom,
      telephone: telephone,
      email: email,
    );
  }
}

