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
import '../../features/home/domain/usecases/count_user_signalements_usecase.dart';
import '../../features/home/domain/usecases/count_commune_signalements_usecase.dart';

// Incidents feature imports
import '../../features/incidents/data/datasources/signalement_remote_datasource.dart';
import '../../features/incidents/data/repositories/signalement_repository_impl.dart';
import '../../features/incidents/domain/repositories/signalement_repository.dart';
import '../../features/incidents/domain/usecases/get_all_signalements_usecase.dart';
import '../../features/incidents/domain/usecases/get_signalements_by_commune_usecase.dart';
import '../../features/incidents/domain/usecases/create_signalement_usecase.dart';
import '../../features/incidents/domain/usecases/upload_photo_usecase.dart';
import '../../features/incidents/domain/usecases/get_types_signalement_usecase.dart';

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
    sl.registerLazySingleton<SignalementRemoteDataSource>(
      () => SignalementRemoteDataSourceImpl(supabaseClient: sl()),
    );

    // Repositories
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<SignalementRepository>(
      () => SignalementRepositoryImpl(remoteDataSource: sl()),
    );

    // Use cases - Auth
    sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
    sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
    sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
    sl.registerLazySingleton<GetCurrentUserUseCase>(() => GetCurrentUserUseCase(sl()));

    // Use cases - Home
    sl.registerLazySingleton<GetDashboardStatsUseCase>(() => GetDashboardStatsUseCase(sl()));
    sl.registerLazySingleton<GetNotificationsUseCase>(() => GetNotificationsUseCase(sl()));
    sl.registerLazySingleton<CountUserSignalementsUseCase>(() => CountUserSignalementsUseCase(sl()));
    sl.registerLazySingleton<CountCommuneSignalementsUseCase>(() => CountCommuneSignalementsUseCase(sl()));

    // Use cases - Incidents
    sl.registerLazySingleton<GetAllSignalementsUseCase>(() => GetAllSignalementsUseCase(sl()));
    sl.registerLazySingleton<GetSignalementsByCommuneUseCase>(() => GetSignalementsByCommuneUseCase(sl()));
    sl.registerLazySingleton<CreateSignalementUseCase>(() => CreateSignalementUseCase(sl()));
    sl.registerLazySingleton<UploadPhotoUseCase>(() => UploadPhotoUseCase(sl<SignalementRepository>()));
    sl.registerLazySingleton<GetTypesSignalementUseCase>(() => GetTypesSignalementUseCase(sl()));
  }
}
