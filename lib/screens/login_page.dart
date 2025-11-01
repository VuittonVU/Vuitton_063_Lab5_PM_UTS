import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import '../states/game_state.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFFFB300),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo utama
              SizedBox(
                height: 320,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // teks Triliuner
                    Image.asset(
                      'assets/images/logo1.png',
                      height: 320,
                      fit: BoxFit.contain,
                    ),
                    // babi emas di atas tulisan
                    Positioned(
                      top: 60,
                      child: Image.asset(
                        'assets/images/logo2.png',
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // kolom input nama
              TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Masukkan nama...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // tombol masuk
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                  child: const Text(
                    'Masukkan',
                    style: TextStyle(
                      fontSize: 18,
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
