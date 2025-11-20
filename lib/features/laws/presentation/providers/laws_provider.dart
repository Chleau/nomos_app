import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nomos_app/features/laws/data/repositories/law_repository_impl.dart';
import 'package:nomos_app/features/laws/domain/entities/law.dart';
import 'package:nomos_app/features/laws/domain/repositories/law_repository.dart';
import 'package:nomos_app/features/laws/domain/usecases/search_laws.dart';
import 'package:nomos_app/features/laws/domain/usecases/get_laws.dart';
import 'package:nomos_app/features/laws/data/datasources/law_remote_datasource.dart';
import 'package:nomos_app/features/laws/domain/usecases/get_laws.dart';

// Provider Supabase
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Provider DataSource
final lawsRemoteDataSourceProvider = Provider<LawRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return LawRemoteDataSourceImpl(supabaseClient);
});

// Provider Repository
final lawsRepositoryProvider = Provider((ref) {
  final remoteDataSource = ref.watch(lawsRemoteDataSourceProvider);
  return LawRepositoryImpl(remoteDataSource);
});

// Provider Use Case
final getAllLawsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(lawsRepositoryProvider);
  return GetAllLawsUseCase(repository);
});

// Provider pour la requête de recherche
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider pour les lois (avec gestion d'état AsyncValue)
final lawsProvider = FutureProvider<List<Law>>((ref) async {
  final getAllLaws = ref.watch(getAllLawsUseCaseProvider);
  return await getAllLaws();
});

// Provider pour les lois filtrées
final filteredLawsProvider = Provider<AsyncValue<List<Law>>>((ref) {
  final lawsAsync = ref.watch(lawsProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return lawsAsync.when(
    data: (laws) {
      if (searchQuery.isEmpty) {
        return AsyncValue.data(laws);
      }
      final filtered = laws.where((law) {
        return law.titre.toLowerCase().contains(searchQuery) ||
            law.thematique.toLowerCase().contains(searchQuery) ||
            law.contenu.toLowerCase().contains(searchQuery);
      }).toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});