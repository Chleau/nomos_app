import '../entities/dashboard_stats.dart';

/// Repository abstrait pour la feature home
abstract class HomeRepository {
  /// Récupère les statistiques du tableau de bord
  Future<DashboardStats> getDashboardStats();

  /// Récupère les notifications récentes
  Future<List<String>> getRecentNotifications();
}

