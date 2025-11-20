// lib/features/laws/domain/usecases/search_laws.dart
import '../entities/law.dart';
import '../repositories/law_repository.dart';

class SearchLaws {
  final LawRepository repository;

  SearchLaws(this.repository);

  Future<List<Law>> call(String query) async {
    final laws = await repository.getAllLaws();

    if (query.isEmpty) {
      return laws;
    }

    return laws.where((law) {
      final searchLower = query.toLowerCase();
      return law.titre.toLowerCase().contains(searchLower) ||
          law.contenu.toLowerCase().contains(searchLower) ||
          law.thematique.toLowerCase().contains(searchLower);
    }).toList();
  }
}
