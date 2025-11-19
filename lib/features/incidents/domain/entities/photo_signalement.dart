/// Entité représentant une photo de signalement
class PhotoSignalement {
  final int id;
  final DateTime createdAt;
  final int signalementId;
  final String url;

  PhotoSignalement({
    required this.id,
    required this.createdAt,
    required this.signalementId,
    required this.url,
  });
}

