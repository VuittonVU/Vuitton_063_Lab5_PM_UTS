import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/questions_data.dart';
import '../states/game_state.dart';
import '../widgets/logo.dart';
import '../widgets/back_button.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // ... (SEMUA VARIABEL STATE ANDA TETAP SAMA) ...
  List<Map<String, dynamic>> remainingQuestions = [];
  Map<String, dynamic>? currentQuestion;
  List<String> currentOptions = [];
  bool usedFifty = false;
  bool usedRefresh = false;
  int timeLeft = 20;
  Timer? timer;
  List<int> removedOptions = [];
  bool isAnswered = false;
  final formatter = NumberFormat("#,###", "id_ID");
  final List<int> moneyLevels = [
    1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, 10000000000, 100000000000, 1000000000000,
  ];

  // ... (SEMUA FUNGSI ANDA initState, getDifficultyPool, dll TETAP SAMA) ...
  @override
  void initState() {
    super.initState();
    _loadQuestions(easyQuestions);
    startTimer();
  }

  List<Map<String, dynamic>> getDifficultyPool(int money) {
    if (money < 10000000) return easyQuestions;
    if (money < 1000000000) return mediumQuestions;
    return hardQuestions;
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 20;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        t.cancel();
        endGame();
      }
    });
  }

  void _loadQuestions(List<Map<String, dynamic>> pool) {
    remainingQuestions = List.from(pool);
    _nextQuestion();
  }

  void _nextQuestion() {
    final money = context.read<GameState>().money;
    final difficultyPool = getDifficultyPool(money);
    if (remainingQuestions.isEmpty || !difficultyPool.contains(remainingQuestions.first)) {
      remainingQuestions = List.from(difficultyPool);
    }
    if (remainingQuestions.isEmpty) {
      endGame(); return;
    }
    final random = Random();
    final nextQ = remainingQuestions[random.nextInt(remainingQuestions.length)];
    remainingQuestions.remove(nextQ);
    currentQuestion = nextQ;
    currentOptions = List<String>.from(nextQ['options']);
    currentOptions.shuffle(Random());
    removedOptions.clear();
    setState(() {});
  }

  void useFifty() {
    if (usedFifty || currentQuestion == null) return;
    usedFifty = true;
    final correct = currentQuestion!['answer'];
    final wrongOptions = currentOptions.where((o) => o != correct).toList();
    wrongOptions.shuffle();
    removedOptions = [];
    for (int i = 0; i < currentOptions.length; i++) {
      if (wrongOptions.take(2).contains(currentOptions[i])) {
        removedOptions.add(i);
      }
    }
    setState(() {});
  }

  void useRefresh() {
    if (usedRefresh) return;
    usedRefresh = true;
    _nextQuestion();
    timeLeft = 20;
    setState(() {});
  }

  void checkAnswer(String selectedOption) {
    if (isAnswered || currentQuestion == null) return;
    isAnswered = true;
    final correctAnswer = currentQuestion!['answer'];
    final gameState = context.read<GameState>();
    if (selectedOption == correctAnswer) {
      int currentIndex = moneyLevels.indexOf(gameState.money);
      if (currentIndex < moneyLevels.length - 1) {
        gameState.money = moneyLevels[currentIndex + 1];
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Benar! Uang sekarang: Rp ${formatter.format(gameState.money)}'),
          duration: const Duration(seconds: 1),
        ),
      );
      if (gameState.money >= 1000000000000) {
        Future.delayed(const Duration(seconds: 1), endGame);
        return;
      }
      Future.delayed(const Duration(seconds: 1), () {
        isAnswered = false;
        timeLeft = 20;
        _nextQuestion();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Salah! Permainan Berakhir'),
          duration: Duration(seconds: 1),
        ),
      );
      Future.delayed(const Duration(seconds: 1), endGame);
    }
  }

  void endGame() {
    timer?.cancel();
    final gameState = context.read<GameState>();
    final playerName = gameState.playerName.isNotEmpty ? gameState.playerName : 'Guest';
    final totalMoney = gameState.money;
    final bool isWin = totalMoney >= 1000000000000;
    context.go(
      '/end/${Uri.encodeComponent(playerName)}/$totalMoney',
      extra: {'isWin': isWin},
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // =================================================================
  // BUILD METHOD UTAMA
  // =================================================================
  @override
  Widget build(BuildContext context) {
    if (currentQuestion == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFB300),
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    final screenSize = MediaQuery.of(context).size;
    // Gunakan dimensi TERKECIL (lebar atau tinggi) untuk timer
    final smallestDimension = min(screenSize.width, screenSize.height);
    // Kita sesuaikan multiplier-nya (misal 0.12) agar pas
    final timerSize = smallestDimension * 0.10;

    return Scaffold(
      backgroundColor: const Color(0xFFFFB300),
      appBar: AppBar(
        // ... (Kode AppBar Anda tetap sama) ...
        backgroundColor: const Color(0xFFFFB300),
        elevation: 0,
        leading: BackButtonWidget(
          onPressed: () {
            final gameState = context.read<GameState>();
            gameState.money = 1000;
            context.go('/home');
          },
        ),
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.all(timerSize * 0.3),
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Text(
            '$timeLeft',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: timerSize * 0.6,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 650) { // Breakpoint 650
            return _buildWideLayout(context, constraints);
          } else {
            return _buildNarrowLayout(context, constraints);
          }
        },
      ),
    );
  }

  // =================================================================
  // WIDGET HELPER UNTUK TATA LETAK SEMPIT (HP)
  // =================================================================
  Widget _buildNarrowLayout(BuildContext context, BoxConstraints constraints) {
    final money = context.watch<GameState>().money;
    final q = currentQuestion!;

    // Ukuran dinamis
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;
    final logoSize = screenHeight * 0.22;
    final fontSize = screenWidth * 0.04;
    final buttonFont = screenWidth * 0.042;
    final spacingSmall = screenHeight * 0.02;
    final spacingMedium = screenHeight * 0.03;

    return SingleChildScrollView( // Penting untuk rotasi HP
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: logoSize, child: Logo(size: logoSize)),
            SizedBox(height: spacingSmall),
            // bantuan
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _helpButton('50:50', usedFifty, useFifty, fontSize, screenWidth),
                _helpButtonIcon(Icons.refresh, usedRefresh, useRefresh, screenWidth),
              ],
            ),
            SizedBox(height: spacingMedium),
            _moneyBox(money, fontSize, screenHeight, screenWidth),
            SizedBox(height: spacingSmall),
            _questionBox(q['question'], fontSize, screenWidth),
            SizedBox(height: spacingMedium),
            _answerButtons(screenHeight, currentOptions, buttonFont),
          ],
        ),
      ),
    );
  }

  // =================================================================
  // WIDGET HELPER UNTUK TATA LETAK LEBAR (TABLET)
  // =================================================================
  Widget _buildWideLayout(BuildContext context, BoxConstraints constraints) {
    final money = context.watch<GameState>().money;
    final q = currentQuestion!;

    // Ukuran dinamis
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;
    final logoSize = screenWidth * 0.12; // Logo lebih kecil
    final fontSize = screenWidth * 0.02;
    final buttonFont = screenWidth * 0.022;
    final spacingMedium = screenHeight * 0.03;

    return Row(
      children: [
        // --- SISI KIRI: INFO (Logo, Bantuan, Uang) ---
        Expanded(
          flex: 2, // 2 bagian
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Logo(size: logoSize),
                SizedBox(height: spacingMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _helpButton('50:50', usedFifty, useFifty, fontSize, screenWidth * 0.3), // screenWidth dikecilkan
                    _helpButtonIcon(Icons.refresh, usedRefresh, useRefresh, screenWidth * 0.3),
                  ],
                ),
                SizedBox(height: spacingMedium),
                _moneyBox(money, fontSize, screenHeight, screenWidth * 0.3),
              ],
            ),
          ),
        ),

        // --- SISI KANAN: AKSI (Pertanyaan, Jawaban) ---
        Expanded(
          flex: 3, // 3 bagian, lebih besar
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _questionBox(q['question'], fontSize, screenWidth * 0.6), // screenWidth dikecilkan
                  SizedBox(height: spacingMedium),
                  _answerButtons(screenHeight, currentOptions, buttonFont),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ... (SEMUA WIDGET HELPER ANDA _helpButton, _moneyBox, dll TETAP SAMA) ...
  Widget _helpButton(String text, bool used, VoidCallback onPressed,
      double fontSize, double screenWidth) {
    return AnimatedOpacity(
      opacity: used ? 0.4 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        padding: EdgeInsets.all(screenWidth * 0.017),
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: TextButton(
          onPressed: used ? null : onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }

  Widget _helpButtonIcon(IconData icon, bool used, VoidCallback onPressed,
      double screenWidth) {
    return AnimatedOpacity(
      opacity: used ? 0.4 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        padding: EdgeInsets.all(screenWidth * 0.017),
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white, size: screenWidth * 0.04),
          onPressed: used ? null : onPressed,
        ),
      ),
    );
  }

  Widget _moneyBox(
      int money, double fontSize, double screenHeight, double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.06,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        'Rp ${formatter.format(money)}',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _questionBox(String question, double fontSize, double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        question,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _answerButtons(
      double screenHeight, List<String> options, double buttonFont) {
    return Column(
      children: List.generate(options.length, (i) {
        final disabled = removedOptions.contains(i);
        final optionText = options[i];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.007),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: disabled ? null : () => checkAnswer(optionText),
              style: ElevatedButton.styleFrom(
                backgroundColor: disabled ? Colors.grey.shade600 : Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                elevation: 2,
              ),
              child: Text(
                '${String.fromCharCode(65 + i)}. $optionText',
                style: TextStyle(fontSize: buttonFont),
              ),
            ),
          ),
        );
      }),
    );
  }
}