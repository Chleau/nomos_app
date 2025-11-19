import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/presentation/widgets/auth_guard.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/laws/presentation/pages/laws_page.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Nomos',
        theme: ThemeData(
          primaryColor: const Color(0xFFF25F0D),
          scaffoldBackgroundColor: const Color(0xFFE6ECEF),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF25F0D),
            primary: const Color(0xFFF25F0D),
            background: const Color(0xFFE6ECEF),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF25F0D),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF25F0D),
              foregroundColor: Colors.white,
            ),
          ),
          useMaterial3: true,
        ),
        home: const AuthGuard(
          child: LawsPage(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
