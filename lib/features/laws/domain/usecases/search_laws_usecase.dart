import 'package:nomos_app/features/laws/domain/entities/law.dart';
import 'package:nomos_app/features/laws/domain/repositories/law_repository.dart';

class SearchLaws {
  final LawRepository repository;

  SearchLaws(this.repository);

  Future<List<Law>> call(String query) async {
    final laws = await repository.getRecentLaws();

    if (query.isEmpty) return laws;

    return laws.where((law) {
      return law.titre.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}