import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return UserModel(
      id: '1',
      email: email,
      name: 'Test User',
    );
  }

  @override
  Future<User> register(String email, String password, String name) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<User> getCurrentUser() async {
    // Implement getting current user
    return UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    // Implement login check
    return false;
  }
}
