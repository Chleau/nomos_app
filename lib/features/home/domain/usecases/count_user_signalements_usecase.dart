import '../repositories/home_repository.dart';

/// Use case pour compter les signalements d'un habitant
class CountUserSignalementsUseCase {
  final HomeRepository repository;

  CountUserSignalementsUseCase(this.repository);

  Future<int> call(int habitantId) async {
    return await repository.countSignalementsByHabitantId(habitantId);
  }
}

