import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mzjljxziwalizlavnvza.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im16amxqeHppd2FsaXpsYXZudnphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc0OTY3MzcsImV4cCI6MjA3MzA3MjczN30.XrDAe-RvN_541DCOiEkHA9PtPUDIFNOHRoFzVIZ_A10',
  );

  // Initialiser l'injection de dépendances
  await InjectionContainer.init();

  runApp(const MyApp());
}