import 'package:nomos_app/features/laws/domain/entities/law.dart';

abstract class LawRepository {
  Future<List<Law>> getRecentLaws();
}