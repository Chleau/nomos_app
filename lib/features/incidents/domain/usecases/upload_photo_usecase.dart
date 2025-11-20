import 'dart:io';
import '../repositories/signalement_repository.dart';

/// Use case pour uploader une photo de signalement
class UploadPhotoUseCase {
  final SignalementRepository repository;

  UploadPhotoUseCase(this.repository);

  Future<String> call(File photo, int signalementId) async {
    try {
      print('📤 UploadPhotoUseCase: Début upload');
      print('   - Signalement ID: $signalementId');
      print('   - Photo path: ${photo.path}');
      print('   - Photo exists: ${await photo.exists()}');

      // Upload de la photo via le repository
      print('🔄 Upload de la photo via repository...');
      final photoSignalement = await repository.uploadPhotoAndCreate(photo, signalementId);
      print('✅ Photo uploadée avec succès!');
      print('   - Photo ID: ${photoSignalement.id}');
      print('   - URL stockée');

      // Mettre à jour le signalement avec l'URL de la photo
      print('💾 Mise à jour du signalement avec l\'URL photo...');
      await repository.updateSignalement(signalementId, {'url': photoSignalement.url});
      print('✅ Signalement mis à jour!');

      return photoSignalement.url;
    } catch (e, stackTrace) {
      print('❌ UploadPhotoUseCase ERROR: $e');
      print('   StackTrace: $stackTrace');
      throw Exception('Erreur lors de l\'upload de la photo: $e');
    }
  }
}

