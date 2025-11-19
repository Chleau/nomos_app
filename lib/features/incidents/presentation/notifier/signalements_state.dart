import '../../domain/entities/signalement.dart';
import '../../domain/entities/type_signalement.dart';

/// État pour la liste des signalements
class SignalementsState {
  final bool isLoading;
  final String? error;
  final List<Signalement> signalements;
  final List<Signalement> filteredSignalements;
  final String? filterCommune;
  final List<TypeSignalement> typesSignalement;

  const SignalementsState({
    this.isLoading = false,
    this.error,
    this.signalements = const [],
    this.filteredSignalements = const [],
    this.filterCommune,
    this.typesSignalement = const [],
  });

  SignalementsState copyWith({
    bool? isLoading,
    String? error,
    List<Signalement>? signalements,
    List<Signalement>? filteredSignalements,
    String? filterCommune,
    List<TypeSignalement>? typesSignalement,
  }) {
    return SignalementsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      signalements: signalements ?? this.signalements,
      filteredSignalements: filteredSignalements ?? this.filteredSignalements,
      filterCommune: filterCommune ?? this.filterCommune,
      typesSignalement: typesSignalement ?? this.typesSignalement,
    );
  }

  /// Récupère les signalements avec localisation pour la carte
  List<Signalement> get signalementsWithLocation {
    return filteredSignalements.where((s) => s.hasLocation).toList();
  }
}

