import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:convert';
import '../models/signalement_model.dart';
import '../models/type_signalement_model.dart';

/// Source de données distante pour les signalements
abstract class SignalementRemoteDataSource {
  Future<List<SignalementModel>> getAllSignalements();
  Future<List<SignalementModel>> getSignalementsByCommuneId(int communeId);
  Future<List<SignalementModel>> getSignalementsByHabitantId(int habitantId);
  Future<SignalementModel?> getSignalementById(int id);
  Future<SignalementModel> createSignalement(Map<String, dynamic> data);
  Future<SignalementModel> updateSignalement(int id, Map<String, dynamic> updates);
  Future<void> deleteSignalement(int id);
  Future<List<TypeSignalementModel>> getTypesSignalement();
  Future<String> uploadPhoto(File photo, String fileName);
}

class SignalementRemoteDataSourceImpl implements SignalementRemoteDataSource {
  final SupabaseClient supabaseClient;

  SignalementRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<SignalementModel>> getAllSignalements() async {
    try {
      final response = await supabaseClient
          .from('signalements')
          .select()
          .order('date_signalement', ascending: false);

      return (response as List)
          .map((json) => SignalementModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des signalements: $e');
    }
  }

  @override
  Future<List<SignalementModel>> getSignalementsByCommuneId(int communeId) async {
    try {
      final response = await supabaseClient
          .from('signalements')
          .select()
          .eq('commune_id', communeId)
          .order('date_signalement', ascending: false);

      return (response as List)
          .map((json) => SignalementModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des signalements de la commune: $e');
    }
  }

  @override
  Future<List<SignalementModel>> getSignalementsByHabitantId(int habitantId) async {
    try {
      final response = await supabaseClient
          .from('signalements')
          .select()
          .eq('habitant_id', habitantId)
          .order('date_signalement', ascending: false);

      return (response as List)
          .map((json) => SignalementModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des signalements de l\'habitant: $e');
    }
  }

  @override
  Future<SignalementModel?> getSignalementById(int id) async {
    try {
      final response = await supabaseClient
          .from('signalements')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return SignalementModel.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la récupération du signalement: $e');
    }
  }

  @override
  Future<SignalementModel> createSignalement(Map<String, dynamic> data) async {
    try {
      final response = await supabaseClient
          .from('signalements')
          .insert(data)
          .select()
          .single();

      return SignalementModel.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la création du signalement: $e');
    }
  }

  @override
  Future<SignalementModel> updateSignalement(int id, Map<String, dynamic> updates) async {
    try {
      final response = await supabaseClient
          .from('signalements')
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      return SignalementModel.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du signalement: $e');
    }
  }

  @override
  Future<void> deleteSignalement(int id) async {
    try {
      await supabaseClient
          .from('signalements')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Erreur lors de la suppression du signalement: $e');
    }
  }

  @override
  Future<List<TypeSignalementModel>> getTypesSignalement() async {
    try {
      final response = await supabaseClient
          .from('types_signalement')
          .select()
          .order('libelle', ascending: true);

      return (response as List)
          .map((json) => TypeSignalementModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des types: $e');
    }
  }

  @override
  Future<String> uploadPhoto(File photo, String fileName) async {
    try {
      print('📦 SignalementRemoteDataSource.uploadPhoto');
      print('   - Fichier: $fileName');
      print('   ⚠️ Mode simplifié: Conversion en base64 (pas de Storage)');

      // Lire les bytes de la photo
      print('📖 Lecture des bytes...');
      final bytes = await photo.readAsBytes();
      print('   - Taille: ${bytes.length} bytes');

      // Convertir en base64
      final base64String = 'data:image/jpeg;base64,${base64.encode(bytes)}';
      print('   - Base64 généré (${base64String.length} caractères)');

      return base64String;
    } catch (e, stackTrace) {
      print('💥 ERREUR uploadPhoto:');
      print('   - Type: ${e.runtimeType}');
      print('   - Message: $e');
      print('   - StackTrace: $stackTrace');
      throw Exception('Erreur lors de la conversion de la photo: $e');
    }
  }
}

