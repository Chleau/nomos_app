import '../../domain/entities/dashboard_stats.dart';

/// Modèle de données pour les statistiques
class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.totalUsers,
    required super.totalCommunes,
    required super.activeUsers,
    required super.pendingRequests,
    required super.totalCommuneReports,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalUsers: json['total_users'] ?? 0,
      totalCommunes: json['total_communes'] ?? 0,
      activeUsers: json['active_users'] ?? 0,
      pendingRequests: json['pending_requests'] ?? 0,
      totalCommuneReports: json['total_commune_reports'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_users': totalUsers,
      'total_communes': totalCommunes,
      'active_users': activeUsers,
      'pending_requests': pendingRequests,
      'total_commune_reports': totalCommuneReports,
    };
  }
}

