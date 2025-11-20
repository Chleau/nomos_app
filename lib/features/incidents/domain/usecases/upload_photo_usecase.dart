import 'dart:io';
import '../repositories/signalement_repository.dart';

/// Use case pour uploader une photo de signalement
class UploadPhotoUseCase {
  final SignalementRepository repository;

  UploadPhotoUseCase(this.repository);

  Future<String> call(File photo, int signalementId) async {
    try {
      print('UploadPhotoUseCase: Début upload');
      print('   - Signalement ID: $signalementId');
      print('   - Photo path: ${photo.path}');
      print('   - Photo exists: ${await photo.exists()}');

      // Upload de la photo en base64 via le repository
      print('Upload de la photo en base64 via repository...');
      final base64Url = await repository.uploadPhotoBase64(photo);
      print('Photo convertie en base64 avec succès!');
      print('   - Taille URL: ${base64Url.length} caractères');

      // Mettre à jour le signalement avec l'URL base64 de la photo
      print('Mise à jour du signalement avec l\'URL base64...');
      await repository.updateSignalement(signalementId, {'url': base64Url});
      print('Signalement mis à jour!');

      return base64Url;
    } catch (e, stackTrace) {
      print('UploadPhotoUseCase ERROR: $e');
      print('   StackTrace: $stackTrace');
      throw Exception('Erreur lors de l\'upload de la photo: $e');
    }
  }
}

