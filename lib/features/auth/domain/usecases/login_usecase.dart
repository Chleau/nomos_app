import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case pour la connexion
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) async {
    return await repository.login(email, password);
  }
}

