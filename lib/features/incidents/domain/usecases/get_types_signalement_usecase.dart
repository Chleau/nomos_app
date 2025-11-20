import '../entities/type_signalement.dart';
import '../repositories/signalement_repository.dart';

/// Use case pour récupérer les types de signalements
class GetTypesSignalementUseCase {
  final SignalementRepository repository;

  GetTypesSignalementUseCase(this.repository);

  Future<List<TypeSignalement>> call() async {
    return await repository.getTypesSignalement();
  }
}

