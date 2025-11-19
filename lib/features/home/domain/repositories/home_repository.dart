import '../entities/dashboard_stats.dart';

/// Repository abstrait pour la feature home
abstract class HomeRepository {
  /// Récupère les statistiques du tableau de bord
  Future<DashboardStats> getDashboardStats();

  /// Récupère les notifications récentes
  Future<List<String>> getRecentNotifications();

  /// Compte le nombre de signalements d'un habitant
  Future<int> countSignalementsByHabitantId(int habitantId);

  /// Compte le nombre total de signalements d'une commune
  Future<int> countSignalementsByCommuneId(int communeId);
}

