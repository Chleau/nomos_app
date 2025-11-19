import '../../domain/entities/dashboard_stats.dart';

/// État pour la feature home
class HomeState {
  final bool isLoading;
  final String? error;
  final DashboardStats? stats;
  final List<String> notifications;
  final int userSignalementsCount;
  final int communeSignalementsCount;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.stats,
    this.notifications = const [],
    this.userSignalementsCount = 0,
    this.communeSignalementsCount = 0,
  });

  HomeState copyWith({
    bool? isLoading,
    String? error,
    DashboardStats? stats,
    List<String>? notifications,
    int? userSignalementsCount,
    int? communeSignalementsCount,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stats: stats ?? this.stats,
      notifications: notifications ?? this.notifications,
      userSignalementsCount: userSignalementsCount ?? this.userSignalementsCount,
      communeSignalementsCount: communeSignalementsCount ?? this.communeSignalementsCount,
    );
  }
}

