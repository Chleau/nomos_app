import '../../domain/entities/photo_signalement.dart';

/// Modèle de données pour une photo de signalement
class PhotoSignalementModel extends PhotoSignalement {
  PhotoSignalementModel({
    required super.id,
    required super.createdAt,
    required super.signalementId,
    required super.url,
  });

  factory PhotoSignalementModel.fromJson(Map<String, dynamic> json) {
    return PhotoSignalementModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      signalementId: json['signalement_id'] as int,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'signalement_id': signalementId,
      'url': url,
    };
  }
}

