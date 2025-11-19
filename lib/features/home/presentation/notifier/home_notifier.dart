import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import 'home_state.dart';

/// Notifier pour gérer l'état de la page d'accueil
class HomeNotifier extends StateNotifier<HomeState> {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;
  final GetNotificationsUseCase getNotificationsUseCase;

  HomeNotifier({
    required this.getDashboardStatsUseCase,
    required this.getNotificationsUseCase,
  }) : super(const HomeState());

  /// Charge les données de la page d'accueil
  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Charger les statistiques et notifications en parallèle
      final stats = await getDashboardStatsUseCase();
      final notifications = await getNotificationsUseCase();

      state = state.copyWith(
        isLoading: false,
        stats: stats,
        notifications: notifications,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement: ${e.toString()}',
      );
    }
  }

  /// Rafraîchit les données
  Future<void> refresh() async {
    await loadHomeData();
  }
}

