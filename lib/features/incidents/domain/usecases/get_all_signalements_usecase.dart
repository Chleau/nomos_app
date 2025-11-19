import '../entities/signalement.dart';
import '../repositories/signalement_repository.dart';

/// Use case pour récupérer tous les signalements
class GetAllSignalementsUseCase {
  final SignalementRepository repository;

  GetAllSignalementsUseCase(this.repository);

  Future<List<Signalement>> call() async {
    return await repository.getAllSignalements();
  }
}

