import '../entities/user_location.dart';

/// Repository abstrait pour la géolocalisation
abstract class LocationRepository {
  /// Récupère la position actuelle de l'utilisateur
  Future<UserLocation> getCurrentPosition();

  /// Vérifie si les permissions de localisation sont accordées
  Future<bool> hasLocationPermission();

  /// Demande les permissions de localisation
  Future<bool> requestLocationPermission();
}

