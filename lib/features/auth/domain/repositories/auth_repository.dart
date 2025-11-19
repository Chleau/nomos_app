import '../../domain/entities/user.dart';

/// Authentication repository contract
abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required int communeId,
    String role = 'habitant',
  });
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isLoggedIn();
}
