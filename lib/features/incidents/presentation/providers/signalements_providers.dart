import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';

// Domain imports
import '../../domain/usecases/get_all_signalements_usecase.dart';
import '../../domain/usecases/get_signalements_by_commune_usecase.dart';
import '../../domain/usecases/create_signalement_usecase.dart';
import '../../domain/usecases/upload_photo_usecase.dart';
import '../../domain/usecases/get_current_location_usecase.dart';
import '../../domain/repositories/location_repository.dart';

// Data imports
import '../../data/datasources/signalement_remote_datasource.dart';
import '../../data/repositories/location_repository_impl.dart';

// Presentation imports
import '../notifier/signalements_notifier.dart';
import '../notifier/signalements_state.dart';

/// Provider pour le repository de géolocalisation
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl();
});

/// Provider pour le use case de géolocalisation
final getCurrentLocationUseCaseProvider = Provider<GetCurrentLocationUseCase>((ref) {
  return GetCurrentLocationUseCase(ref.watch(locationRepositoryProvider));
});

/// Provider pour SignalementsNotifier
final signalementsNotifierProvider = StateNotifierProvider<SignalementsNotifier, SignalementsState>((ref) {
  return SignalementsNotifier(
    getAllSignalementsUseCase: sl<GetAllSignalementsUseCase>(),
    getSignalementsByCommuneUseCase: sl<GetSignalementsByCommuneUseCase>(),
    createSignalementUseCase: sl<CreateSignalementUseCase>(),
    remoteDataSource: sl<SignalementRemoteDataSource>(),
    uploadPhotoUseCase: sl<UploadPhotoUseCase>(),
  );
});

