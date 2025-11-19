import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nomos_app/features/laws/data/repositories/law_repository_impl.dart';
import 'package:nomos_app/features/laws/domain/entities/law.dart';
import 'package:nomos_app/features/laws/domain/repositories/law_repository.dart';
import 'package:nomos_app/features/laws/domain/usecases/search_laws_usecase.dart';

final lawRepositoryProvider = Provider<LawRepository>((ref) {
  return LawRepositoryImpl(Supabase.instance.client);
});

final recentLawsProvider = FutureProvider<List<Law>>((ref) async {
  final repository = ref.watch(lawRepositoryProvider);
  return repository.getRecentLaws();
});

final searchLawsUseCaseProvider = Provider<SearchLaws>((ref) {
  return SearchLaws(ref.watch(lawRepositoryProvider));
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredLawsProvider = FutureProvider<List<Law>>((ref) async {
  final searchUseCase = ref.watch(searchLawsUseCaseProvider);
  final query = ref.watch(searchQueryProvider);
  return searchUseCase(query);
});