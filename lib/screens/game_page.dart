import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/questions_data.dart';
import '../states/game_state.dart';
import 'end_page.dart';
import '../widgets/logo.dart';
import '../widgets/back_button.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
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
    1000,
    10000,
    100000,
    1000000,
    10000000,
    100000000,
    1000000000,
    10000000000,
    100000000000,
    1000000000000,
  ];

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

    if (remainingQuestions.isEmpty ||
        !difficultyPool.contains(remainingQuestions.first)) {
      remainingQuestions = List.from(difficultyPool);
    }

    if (remainingQuestions.isEmpty) {
      endGame();
      return;
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
          content: Text(
            'Benar! Uang sekarang: Rp ${formatter.format(gameState.money)}',
          ),
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
    final playerName = context.read<GameState>().playerName;
    final totalMoney = context.read<GameState>().money;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EndPage(
          playerName: playerName,
          totalMoney: totalMoney,
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestion == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFB300),
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    final q = currentQuestion!;
    final money = context.watch<GameState>().money;

    // Gunakan MediaQuery untuk ukuran dinamis
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final timerSize = screenWidth * 0.10;
    final logoSize = screenHeight * 0.22;
    final fontSize = screenWidth * 0.04;
    final buttonFont = screenWidth * 0.042;
    final spacingSmall = screenHeight * 0.02;
    final spacingMedium = screenHeight * 0.03;

    return Scaffold(
      backgroundColor: const Color(0xFFFFB300),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB300),
        elevation: 0,
        leading: BackButtonWidget(
          onPressed: () {
            context.read<GameState>().resetGame();
            Navigator.pop(context);
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

      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: logoSize, child: Logo(size: logoSize)),
            SizedBox(height: spacingSmall),

            // Fitur bantuan
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: usedFifty ? 0.4 : 1.0,
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
                      onPressed: usedFifty ? null : useFifty,
                      child: Text(
                        '50:50',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: usedRefresh ? 0.4 : 1.0,
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
                      icon: Icon(Icons.refresh,
                          color: Colors.white, size: screenWidth * 0.04),
                      onPressed: usedRefresh ? null : useRefresh,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: spacingMedium),

            // Uang
            Container(
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
            ),

            SizedBox(height: spacingSmall),

            // Pertanyaan
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                q['question'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: spacingMedium),

            // Pilihan jawaban
            ...List.generate(currentOptions.length, (i) {
              final disabled = removedOptions.contains(i);
              final optionText = currentOptions[i];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.007),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: disabled ? null : () => checkAnswer(optionText),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      disabled ? Colors.grey.shade600 : Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.018,
                      ),
                    ),
                    child: Text(
                      '${String.fromCharCode(65 + i)}. $optionText',
                      style: TextStyle(fontSize: buttonFont),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
