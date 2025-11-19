import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/count_user_signalements_usecase.dart';
import '../../domain/usecases/count_commune_signalements_usecase.dart';
import 'home_state.dart';

/// Notifier pour gérer l'état de la page d'accueil
class HomeNotifier extends StateNotifier<HomeState> {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;
  final GetNotificationsUseCase getNotificationsUseCase;
  final CountUserSignalementsUseCase countUserSignalementsUseCase;
  final CountCommuneSignalementsUseCase countCommuneSignalementsUseCase;

  HomeNotifier({
    required this.getDashboardStatsUseCase,
    required this.getNotificationsUseCase,
    required this.countUserSignalementsUseCase,
    required this.countCommuneSignalementsUseCase,
  }) : super(const HomeState());

  /// Charge les données de la page d'accueil
  Future<void> loadHomeData({int? habitantId, int? communeId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Charger les statistiques et notifications
      final stats = await getDashboardStatsUseCase();
      final notifications = await getNotificationsUseCase();

      // Compter les signalements de l'utilisateur
      final userCount = habitantId != null
          ? await countUserSignalementsUseCase(habitantId)
          : 0;

      // Compter les signalements de la commune
      final communeCount = communeId != null
          ? await countCommuneSignalementsUseCase(communeId)
          : 0;

      state = state.copyWith(
        isLoading: false,
        stats: stats,
        notifications: notifications,
        userSignalementsCount: userCount,
        communeSignalementsCount: communeCount,
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
  Future<void> refresh({int? habitantId, int? communeId}) async {
    await loadHomeData(habitantId: habitantId, communeId: communeId);
  }
}

