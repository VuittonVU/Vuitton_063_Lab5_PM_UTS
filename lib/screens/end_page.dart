import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../states/game_state.dart';
import '../widgets/logo.dart';
import '../widgets/back_button.dart';

class EndPage extends StatelessWidget {
  final String playerName;
  final int totalMoney;

  const EndPage({
    super.key,
    required this.playerName,
    required this.totalMoney,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###", "id_ID");

    // ukuran dinamis
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final logoSize = screenHeight * 0.25;
    final titleFont = screenWidth * 0.065;
    final textFont = screenWidth * 0.05;
    final buttonFont = screenWidth * 0.05;
    final paddingHorizontal = screenWidth * 0.1;
    final spacingSmall = screenHeight * 0.02;
    final spacingLarge = screenHeight * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xFFFFB300),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB300),
        elevation: 0,
        leading: BackButtonWidget(
          onPressed: () {
            context.read<GameState>().resetGame();
            context.go('/login');
          },
        ),
        centerTitle: true,
        title: Text(
          'Permainan Selesai',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: titleFont,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(size: logoSize),
              SizedBox(height: spacingSmall),

              Text(
                'Selamat, ${Uri.decodeComponent(playerName)}!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textFont,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: spacingSmall),

              // Total uang
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.015,
                  horizontal: screenWidth * 0.05,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Text(
                  'Total Uang: Rp ${formatter.format(totalMoney)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: textFont * 0.9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: spacingLarge),

              // Tombol Main Lagi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<GameState>().resetGame();
                    context.go('/game');
                  },
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
                  child: Text(
                    'Main Lagi',
                    style: TextStyle(
                      fontSize: buttonFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: spacingSmall),

              // Tombol Keluar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    context.read<GameState>().resetGame();
                    await Future.delayed(const Duration(milliseconds: 150));
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.025,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  child: Text(
                    'Keluar',
                    style: TextStyle(
                      fontSize: buttonFont,
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
