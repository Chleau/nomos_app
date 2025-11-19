import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nomos_app/features/laws/data/repositories/law_repository_impl.dart';
import 'package:nomos_app/features/laws/domain/entities/law.dart';
import 'package:nomos_app/features/laws/domain/repositories/law_repository.dart';
import 'package:nomos_app/features/laws/domain/usecases/search_laws.dart';
import 'package:nomos_app/features/laws/domain/usecases/get_laws.dart';
import 'package:nomos_app/features/laws/data/datasources/law_remote_datasource.dart';

final lawDataSourceProvider = Provider<LawRemoteDataSource>((ref) {
  return LawRemoteDataSourceImpl(Supabase.instance.client);
});

final lawRepositoryProvider = Provider<LawRepository>((ref) {
  return LawRepositoryImpl(
    remoteDataSource: ref.watch(lawDataSourceProvider),
  );
});

final getLawsUseCaseProvider = Provider((ref) {
  return GetLaws(ref.watch(lawRepositoryProvider));
});

final searchLawsUseCaseProvider = Provider((ref) {
  return SearchLaws(ref.watch(lawRepositoryProvider));
});

final lawsProvider = FutureProvider<List<Law>>((ref) async {
  return await ref.watch(getLawsUseCaseProvider).call();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredLawsProvider = FutureProvider<List<Law>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  return await ref.watch(searchLawsUseCaseProvider).call(query);
});