import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

/// Implémentation du repository home
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardStats> getDashboardStats() async {
    try {
      return await remoteDataSource.getDashboardStats();
    } catch (e) {
      throw Exception('Erreur repository: $e');
    }
  }

  @override
  Future<List<String>> getRecentNotifications() async {
    try {
      return await remoteDataSource.getRecentNotifications();
    } catch (e) {
      throw Exception('Erreur repository: $e');
    }
  }

  @override
  Future<int> countSignalementsByHabitantId(int habitantId) async {
    try {
      return await remoteDataSource.countSignalementsByHabitantId(habitantId);
    } catch (e) {
      throw Exception('Erreur repository: $e');
    }
  }

  @override
  Future<int> countSignalementsByCommuneId(int communeId) async {
    try {
      return await remoteDataSource.countSignalementsByCommuneId(communeId);
    } catch (e) {
      throw Exception('Erreur repository: $e');
    }
  }
}

