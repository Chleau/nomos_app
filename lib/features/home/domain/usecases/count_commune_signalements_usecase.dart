import '../repositories/home_repository.dart';

/// Use case pour compter les signalements d'une commune
class CountCommuneSignalementsUseCase {
  final HomeRepository repository;

  CountCommuneSignalementsUseCase(this.repository);

  Future<int> call(int communeId) async {
    return await repository.countSignalementsByCommuneId(communeId);
  }
}

