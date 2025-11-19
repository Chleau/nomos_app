/// Entité représentant les statistiques du tableau de bord
class DashboardStats {
  final int totalUsers;
  final int totalCommunes;
  final int activeUsers;
  final int pendingRequests;

  const DashboardStats({
    required this.totalUsers,
    required this.totalCommunes,
    required this.activeUsers,
    required this.pendingRequests,
  });
}

