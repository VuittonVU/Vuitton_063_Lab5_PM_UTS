import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import '../states/game_state.dart';
import '../widgets/logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan MediaQuery untuk dapat ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Skala dinamis untuk ukuran elemen
    final logoSize = screenHeight * 0.35;
    final inputFontSize = screenWidth * 0.045;
    final buttonFontSize = screenWidth * 0.045;
    final verticalSpacing = screenHeight * 0.03;
    final horizontalPadding = screenWidth * 0.1;

    return Scaffold(
      backgroundColor: const Color(0xFFFFB300),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo dinamis
              Logo(size: logoSize),

              SizedBox(height: verticalSpacing),

              // Kolom input nama
              TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: inputFontSize,
                ),
                decoration: InputDecoration(
                  hintText: 'Masukkan nama...',
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: inputFontSize * 0.9,
                  ),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                  ),
                ),
              ),

              SizedBox(height: verticalSpacing),

              // Tombol masuk
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    final name = _controller.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Masukkan nama terlebih dahulu!'),
                        ),
                      );
                      return;
                    }

                    context.read<GameState>().setPlayerName(name);

                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    }
                  },
                  child: Text(
                    'Masukkan',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
