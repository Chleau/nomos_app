import 'package:nomos_app/features/laws/domain/entities/law.dart';
import 'package:nomos_app/features/laws/domain/repositories/law_repository.dart';

class SearchLaws {
  final LawRepository repository;

  SearchLaws(this.repository);

  Future<List<Law>> call(String query) async {
    final all = await repository.getLaws();
    final q = query.toLowerCase();
    return all.where((law) {
      final titre = law.titre.toLowerCase();
      final contenu = law.contenu.toLowerCase();
      return titre.contains(q) || contenu.contains(q);
    }).toList();
  }
}