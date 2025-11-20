import '../entities/law.dart';
import '../repositories/law_repository.dart';

class GetAllLawsUseCase {
  final LawRepository repository;

  GetAllLawsUseCase(this.repository);

  Future<List<Law>> call() async {
    return await repository.getAllLaws();
  }
}
