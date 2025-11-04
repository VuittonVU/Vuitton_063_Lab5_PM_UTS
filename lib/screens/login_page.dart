import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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

  // Fungsi untuk memproses login
  void _login() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nama terlebih dahulu!'),
        ),
      );
      return;
    }
    // Simpan nama ke GameState
    context.read<GameState>().setPlayerName(name);

    // Navigasi ke HomePage
    if (context.mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFB300),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Tentukan breakpoint Anda. 600 adalah standar umum.
          if (constraints.maxWidth > 600) {
            // --- TAMPILAN LEBAR (TABLET / WEB) ---
            return _buildWideLayout(constraints);
          } else {
            // --- TAMPILAN SEMPIT (HP - POTRET ATAU LANDSCAPE) ---
            return _buildNarrowLayout(constraints);
          }
        },
      ),
    );
  }

  // =================================================================
  // WIDGET HELPER UNTUK TATA LETAK SEMPIT (HP)
  // =================================================================
  Widget _buildNarrowLayout(BoxConstraints constraints) {
    // Ukuran dinamis berdasarkan layout sempit
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;
    final logoSize = screenHeight * 0.35;
    final inputFontSize = screenWidth * 0.045;
    final buttonFontSize = screenWidth * 0.045;
    final verticalSpacing = screenHeight * 0.03;
    final horizontalPadding = screenWidth * 0.1;

    return SafeArea(
      child: SingleChildScrollView( // Ini penting untuk rotasi HP
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding)
              .copyWith(top: screenHeight * 0.1), // Padding atas
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Logo(size: logoSize * 0.8), // Logo
                SizedBox(height: verticalSpacing),
                _buildLoginForm(inputFontSize, buttonFontSize, screenHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =================================================================
  // WIDGET HELPER UNTUK TATA LETAK LEBAR (TABLET)
  // =================================================================
  Widget _buildWideLayout(BoxConstraints constraints) {
    // Ukuran dinamis berdasarkan layout lebar
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;
    final logoSize = screenWidth * 0.25; // Logo lebih kecil, di samping
    final inputFontSize = screenWidth * 0.02;
    final buttonFontSize = screenWidth * 0.02;
    final horizontalPadding = screenWidth * 0.1;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- SISI KIRI: LOGO ---
            Expanded(
              flex: 1,
              child: Center(child: Logo(size: logoSize)),
            ),

            // --- SISI KANAN: FORM LOGIN ---
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLoginForm(inputFontSize, buttonFontSize, screenHeight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =================================================================
  // WIDGET HELPER UNTUK FORM (DIPAKAI KEDUA LAYOUT)
  // =================================================================
  Widget _buildLoginForm(
      double inputFontSize, double buttonFontSize, double screenHeight) {
    return Column(
      children: [
        // Input nama
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
        SizedBox(height: screenHeight * 0.03),

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
            onPressed: _login,
            child: Text(
              'Masuk',
              style: TextStyle(
                fontSize: buttonFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}