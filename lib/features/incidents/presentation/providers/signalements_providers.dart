import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/usecases/get_all_signalements_usecase.dart';
import '../../domain/usecases/get_signalements_by_commune_usecase.dart';
import '../../domain/usecases/create_signalement_usecase.dart';
import '../../domain/usecases/upload_photo_usecase.dart';
import '../../data/datasources/signalement_remote_datasource.dart';
import '../notifier/signalements_notifier.dart';
import '../notifier/signalements_state.dart';

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

