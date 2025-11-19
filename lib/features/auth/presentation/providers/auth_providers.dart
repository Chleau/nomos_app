import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../domain/entities/commune.dart';
import '../notifier/auth_notifier.dart';
import '../notifier/auth_state.dart';

/// Provider pour AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: sl<LoginUseCase>(),
    registerUseCase: sl<RegisterUseCase>(),
    logoutUseCase: sl<LogoutUseCase>(),
    getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
  );
});

/// Provider pour récupérer la liste des communes
final communesProvider = FutureProvider<List<Commune>>((ref) async {
  final datasource = sl<AuthRemoteDataSource>();
  return await datasource.getCommunes();
});

