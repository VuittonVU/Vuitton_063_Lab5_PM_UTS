import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'states/game_state.dart';
import 'routes/app_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final gameState = GameState();
  await gameState.loadName();

  runApp(
    ChangeNotifierProvider.value(
      value: gameState,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Triliuner',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFB300),
        textTheme: GoogleFonts.robotoFlexTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}