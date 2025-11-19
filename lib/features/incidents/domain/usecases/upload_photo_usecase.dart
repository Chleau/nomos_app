import 'dart:io';
import '../../data/datasources/signalement_remote_datasource.dart';

/// Use case pour uploader une photo de signalement
class UploadPhotoUseCase {
  final SignalementRemoteDataSource remoteDataSource;

  UploadPhotoUseCase(this.remoteDataSource);

  Future<String> call(File photo, int signalementId) async {
    try {
      print('📤 UploadPhotoUseCase: Début upload');
      print('   - Signalement ID: $signalementId');
      print('   - Photo path: ${photo.path}');
      print('   - Photo exists: ${await photo.exists()}');

      // Générer un nom de fichier unique
      final fileName = '${signalementId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      print('   - Nom fichier généré: $fileName');

      // Convertir la photo en base64
      print('🔄 Conversion de la photo en base64...');
      final base64Url = await remoteDataSource.uploadPhoto(photo, fileName);
      print('✅ Conversion terminée!');

      // Mettre à jour le signalement avec l'URL de la photo
      print('💾 Mise à jour du signalement avec l\'URL photo...');
      await remoteDataSource.updateSignalement(signalementId, {'url': base64Url});
      print('✅ Signalement mis à jour!');

      return base64Url;
    } catch (e, stackTrace) {
      print('❌ UploadPhotoUseCase ERROR: $e');
      print('   StackTrace: $stackTrace');
      throw Exception('Erreur lors de l\'upload de la photo: $e');
    }
  }
}

