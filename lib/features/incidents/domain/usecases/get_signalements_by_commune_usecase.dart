import '../entities/signalement.dart';
import '../repositories/signalement_repository.dart';

/// Use case pour récupérer les signalements d'une commune
class GetSignalementsByCommuneUseCase {
  final SignalementRepository repository;

  GetSignalementsByCommuneUseCase(this.repository);

  Future<List<Signalement>> call(int communeId) async {
    return await repository.getSignalementsByCommuneId(communeId);
  }
}

