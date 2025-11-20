import '../entities/user_location.dart';
import '../repositories/location_repository.dart';

/// Use case pour récupérer la position actuelle de l'utilisateur
class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<UserLocation> call() async {
    // Vérifier les permissions
    final hasPermission = await repository.hasLocationPermission();

    if (!hasPermission) {
      // Demander les permissions
      final granted = await repository.requestLocationPermission();
      if (!granted) {
        throw Exception('Permission de localisation refusée');
      }
    }

    // Récupérer la position
    return await repository.getCurrentPosition();
  }
}

