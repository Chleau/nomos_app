import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthNotifier({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
        );
      }
    } catch (e) {
      state = const AuthState();
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await loginUseCase(email, password);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Échec de la connexion: ${e.toString()}',
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required int communeId,
    String role = 'habitant',
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await registerUseCase(
        email: email,
        password: password,
        nom: nom,
        prenom: prenom,
        communeId: communeId,
        role: role,
      );
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Échec de l\'inscription: ${e.toString()}',
      );
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        error: 'Échec de la déconnexion: ${e.toString()}',
      );
    }
  }
}
