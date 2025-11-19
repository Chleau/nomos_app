import '../entities/dashboard_stats.dart';
import '../repositories/home_repository.dart';

/// Use case pour récupérer les statistiques du tableau de bord
class GetDashboardStatsUseCase {
  final HomeRepository repository;

  GetDashboardStatsUseCase(this.repository);

  Future<DashboardStats> call() async {
    return await repository.getDashboardStats();
  }
}

