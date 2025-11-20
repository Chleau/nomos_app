import '../entities/law.dart';
import '../repositories/law_repository.dart';

class GetLaws {
  final LawRepository repository;

  GetLaws(this.repository);

  Future<List<Law>> call() async {
    return await repository.getLaws();
  }
}
