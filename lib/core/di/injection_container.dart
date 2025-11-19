import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_dashboard_stats_usecase.dart';
import '../../features/home/domain/usecases/get_notifications_usecase.dart';

final sl = GetIt.instance;

/// Dependency injection setup
class InjectionContainer {
  /// Initialize dependencies
  static Future<void> init() async {
    // External
    final supabaseClient = Supabase.instance.client;
    sl.registerLazySingleton<SupabaseClient>(() => supabaseClient);

    // Data sources
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
    );
    sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(supabaseClient: sl()) as HomeRemoteDataSource,
    );

    // Repositories
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(remoteDataSource: sl()),
    );

    // Use cases - Auth
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => RegisterUseCase(sl()));
    sl.registerLazySingleton(() => LogoutUseCase(sl()));
    sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

    // Use cases - Home
    sl.registerLazySingleton(() => GetDashboardStatsUseCase(sl()));
    sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  }
}
