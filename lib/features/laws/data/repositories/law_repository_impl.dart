// lib/features/laws/data/repositories/law_repository_impl.dart
import '../../domain/entities/law.dart';
import '../../domain/repositories/law_repository.dart';
import '../datasources/law_remote_datasource.dart';

class LawRepositoryImpl implements LawRepository {
  final LawRemoteDataSource remoteDataSource;

  LawRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Law>> getAllLaws() async {
    try {
      final lawModels = await remoteDataSource.getAllLaws();
      return lawModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des lois: $e');
    }
  }

  @override
  Future<Law?> getLawById(String id) async {
    final laws = await getAllLaws();
    try {
      return laws.firstWhere((law) => law.id == id);
    } catch (e) {
      return null;
    }
  }
}
