import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required int communeId,
    String role = 'habitant',
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<bool> isLoggedIn();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // 1. Se connecter avec Supabase Auth
      final AuthResponse response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Échec de la connexion');
      }

      // 2. Récupérer les informations de l'habitant
      final data = await supabaseClient
          .from('habitants')
          .select()
          .eq('auth_user_id', response.user!.id)
          .single();

      return UserModel.fromJson(data);
    } catch (e) {
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required int communeId,
    String role = 'habitant',
  }) async {
    try {
      // 1. Créer l'utilisateur dans auth.users
      final AuthResponse response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Échec de l\'inscription');
      }

      // 2. Créer l'entrée dans la table habitants
      final data = await supabaseClient.from('habitants').insert({
        'auth_user_id': response.user!.id,
        'email': email,
        'nom': nom,
        'prenom': prenom,
        'commune_id': communeId,
        'role': role,
      }).select().single();

      return UserModel.fromJson(data);
    } catch (e) {
      throw Exception('Erreur d\'inscription: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Erreur de déconnexion: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return null;

      final data = await supabaseClient
          .from('habitants')
          .select()
          .eq('auth_user_id', user.id)
          .maybeSingle();

      if (data == null) return null;

      return UserModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return supabaseClient.auth.currentUser != null;
  }
}

