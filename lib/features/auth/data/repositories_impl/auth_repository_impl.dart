import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required int communeId,
    String role = 'habitant',
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        email: email,
        password: password,
        nom: nom,
        prenom: prenom,
        communeId: communeId,
        role: role,
      );
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return userModel?.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await remoteDataSource.isLoggedIn();
    } catch (e) {
      return false;
    }
  }
}
