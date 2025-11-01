import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'states/game_state.dart';
import 'routes/app_router.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => GameState(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Triliuner',
      theme: ThemeData(fontFamily: 'Poppins', scaffoldBackgroundColor: const Color(0xFFFFB300)),
      routerConfig: appRouter,
    );
  }
}
