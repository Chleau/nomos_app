import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case pour l'inscription
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> call({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required int communeId,
    String role = 'habitant',
  }) async {
    return await repository.register(
      email: email,
      password: password,
      nom: nom,
      prenom: prenom,
      communeId: communeId,
      role: role,
    );
  }
}

