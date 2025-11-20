import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/presentation/splash_screen.dart';
import 'core/presentation/pages/onboarding_screen.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/home/presentation/pages/profile_page.dart';
import 'features/laws/presentation/pages/laws_page.dart';
import 'shared/widgets/Navbar.dart';
import 'package:nomos_app/features/incidents/presentation/pages/carte_incidents_page.dart';


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
            surface: const Color(0xFFE6ECEF),
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
        // Définir le splash screen comme route initiale
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginPage(),
          '/main': (context) => const MainPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  void _onNavigate(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Créer les pages dynamiquement pour passer le callback
    final List<Widget> pages = [
      HomePage(onNavigate: _onNavigate),
      const CarteIncidentsPage(),
      const LawsPage(),
      const ProfilePage(),

    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavigate,
      ),
    );
  }
}