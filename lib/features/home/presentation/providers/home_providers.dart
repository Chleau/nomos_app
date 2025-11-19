import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../notifier/home_notifier.dart';
import '../notifier/home_state.dart';

/// Provider pour HomeNotifier
final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(
    getDashboardStatsUseCase: sl<GetDashboardStatsUseCase>(),
    getNotificationsUseCase: sl<GetNotificationsUseCase>(),
  );
});

