import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/law_model.dart';

abstract class LawRemoteDataSource {
  Future<List<LawModel>> getLaws();
}

class LawRemoteDataSourceImpl implements LawRemoteDataSource {
  final SupabaseClient supabaseClient;

  LawRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<LawModel>> getLaws() async {
    try {
      final response = await supabaseClient
          .from('lois_reglementations')
          .select()
          .order('date_mise_a_jour', ascending: false)
          .limit(10);

      return (response as List)
          .map((json) => LawModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des lois: $e');
    }
  }
}