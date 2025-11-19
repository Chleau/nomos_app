import 'package:nomos_app/features/laws/domain/repositories/law_repository.dart';
import 'package:nomos_app/features/laws/data/models/law_model.dart';
import 'package:nomos_app/features/laws/domain/entities/law.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LawRepositoryImpl implements LawRepository {
  final SupabaseClient supabase;

  LawRepositoryImpl(this.supabase);

  Future<List<Law>> getRecentLaws() async {
    final response = await supabase
        .from('lois_reglementations')
        .select()
        .order('date_mise_a_jour', ascending: false);

    return (response as List)
        .map((json) => LawModel.fromJson(json))
        .toList();
  }
}
