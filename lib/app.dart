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
          primarySwatch: Colors.blue,
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
