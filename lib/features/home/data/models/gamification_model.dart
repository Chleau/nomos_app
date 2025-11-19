import '../../domain/entities/gamification.dart';

/// Modèle de données pour la gamification
class GamificationModel extends Gamification {
  const GamificationModel({
    required super.id,
    required super.habitantId,
    required super.points,
    required super.dateDernierUpdate,
  });

  factory GamificationModel.fromJson(Map<String, dynamic> json) {
    return GamificationModel(
      id: json['id'] as int? ?? 0,
      habitantId: json['habitant_id'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      dateDernierUpdate: json['date_dernier_update'] != null
          ? DateTime.parse(json['date_dernier_update'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitant_id': habitantId,
      'points': points,
      'date_dernier_update': dateDernierUpdate.toIso8601String(),
    };
  }
}

