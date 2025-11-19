import '../../domain/entities/dashboard_stats.dart';

/// État pour la feature home
class HomeState {
  final bool isLoading;
  final String? error;
  final DashboardStats? stats;
  final List<String> notifications;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.stats,
    this.notifications = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    String? error,
    DashboardStats? stats,
    List<String>? notifications,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stats: stats ?? this.stats,
      notifications: notifications ?? this.notifications,
    );
  }
}

