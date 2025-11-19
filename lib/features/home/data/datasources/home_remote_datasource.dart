import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dashboard_stats_model.dart';

/// Source de données distante pour la feature home
abstract class HomeRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
  Future<List<String>> getRecentNotifications();
  Future<int> countSignalementsByHabitantId(int habitantId);
  Future<int> countSignalementsByCommuneId(int communeId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient supabaseClient;

  HomeRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    // Pour l'instant, on retourne des données statiques
    // TODO: Implémenter la récupération réelle depuis Supabase quand nécessaire
    await Future.delayed(const Duration(milliseconds: 500));

    return const DashboardStatsModel(
      totalUsers: 0,
      totalCommunes: 0,
      activeUsers: 0,
      pendingRequests: 0,
      totalCommuneReports: 0,
    );
  }

  @override
  Future<List<String>> getRecentNotifications() async {
    // Pour l'instant, on retourne des notifications statiques
    // TODO: Implémenter la récupération réelle depuis Supabase quand nécessaire
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      'Bienvenue sur Nomos !',
      'Votre profil a été créé avec succès',
      'Découvrez les fonctionnalités de l\'application',
    ];
  }

  @override
  Future<int> countSignalementsByHabitantId(int habitantId) async {
    try {
      final response = await supabaseClient
          .from('signalements')
          .select('id')
          .eq('habitant_id', habitantId)
          .count();

      return response.count;
    } catch (e) {
      throw Exception('Erreur lors du comptage des signalements: $e');
    }
  }

  @override
  Future<int> countSignalementsByCommuneId(int communeId) async {
    try {
      final response = await supabaseClient
          .from('signalements')
          .select('id')
          .eq('commune_id', communeId)
          .count();

      return response.count;
    } catch (e) {
      throw Exception('Erreur lors du comptage des signalements de la commune: $e');
    }
  }
}
