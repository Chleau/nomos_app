import 'package:geolocator/geolocator.dart';
import '../../domain/entities/user_location.dart';
import '../../domain/repositories/location_repository.dart';

/// Implémentation du repository de géolocalisation avec Geolocator
class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<UserLocation> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la position: $e');
    }
  }

  @override
  Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
           permission == LocationPermission.always;
  }

  @override
  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.whileInUse ||
           permission == LocationPermission.always;
  }
}

