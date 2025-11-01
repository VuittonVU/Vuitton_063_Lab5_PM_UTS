import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/game_state.dart';
import 'login_page.dart';
import 'panduan_page.dart';
import 'game_page.dart';
import '../widgets/logo.dart';
import '../widgets/back_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Skala proporsional untuk semua elemen
    final logoSize = screenHeight * 0.35;
    final welcomeFontSize = screenWidth * 0.06;
    final buttonFontSize = screenWidth * 0.05;
    final verticalSpacingLarge = screenHeight * 0.06;
    final verticalSpacingSmall = screenHeight * 0.025;
    final horizontalPadding = screenWidth * 0.1;

    return Scaffold(
      backgroundColor: const Color(0xFFFFB300),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB300),
        elevation: 0,
        leading: BackButtonWidget(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo responsif
                Logo(size: logoSize),

                SizedBox(height: verticalSpacingSmall),

                // Teks selamat datang
                Text(
                  'Selamat Datang!!\n${context.watch<GameState>().playerName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: welcomeFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: verticalSpacingLarge),

                // Tombol Main
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.025,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GamePage()),
                      );
                    },
                    child: Text(
                      'Main',
                      style: TextStyle(
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: verticalSpacingSmall),

                // Tombol Panduan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.025,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PanduanPage()),
                      );
                    },
                    child: Text(
                      'Panduan',
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
      ),
    );
  }
}
