import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dashboard_stats_model.dart';

/// Source de données distante pour la feature home
abstract class HomeRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
  Future<List<String>> getRecentNotifications();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient supabaseClient;

  HomeRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    // Pour l'instant, on retourne des données statiques
    // TODO: Implémenter la récupération réelle depuis Supabase quand nécessaire
    await Future.delayed(const Duration(milliseconds: 500)); // Simule un appel réseau

    return const DashboardStatsModel(
      totalUsers: 0,
      totalCommunes: 0,
      activeUsers: 0,
      pendingRequests: 0,
    );
  }

  @override
  Future<List<String>> getRecentNotifications() async {
    // Pour l'instant, on retourne des notifications statiques
    // TODO: Implémenter la récupération réelle depuis Supabase quand nécessaire
    await Future.delayed(const Duration(milliseconds: 300)); // Simule un appel réseau

    return [
      'Bienvenue sur Nomos !',
      'Votre profil a été créé avec succès',
      'Découvrez les fonctionnalités de l\'application',
    ];
  }
}

