import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/game_state.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int questionIndex = 0;
  bool usedFifty = false;
  bool usedRefresh = false;
  int timeLeft = 30;
  Timer? timer;
  List<int> removedOptions = [];

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Game populer “Genshin Impact” dibuat oleh perusahaan?',
      'options': ['HoYoverse', 'Tencent', 'miHoYo', 'Bandai Namco'],
      'answer': 0,
    },
    {
      'question': 'Karakter utama dalam anime “Attack on Titan” adalah?',
      'options': ['Naruto', 'Eren Yeager', 'Goku', 'Deku'],
      'answer': 1,
    },
    {
      'question': 'Film “Avengers: Endgame” rilis pada tahun?',
      'options': ['2017', '2018', '2019', '2020'],
      'answer': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 30;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        // nanti di sini bisa dipanggil fungsi "gameOver"
        t.cancel();
      }
    });
  }

  void useFifty() {
    if (usedFifty) return;
    usedFifty = true;
    final correct = questions[questionIndex]['answer'];
    final indices = [0, 1, 2, 3];
    indices.remove(correct);
    indices.shuffle();
    removedOptions = indices.take(2).toList();
    setState(() {});
  }

  void useRefresh() {
    if (usedRefresh) return;
    usedRefresh = true;
    final random = Random();
    questionIndex = random.nextInt(questions.length);
    removedOptions.clear();
    timeLeft = 30;
    setState(() {});
  }

  void checkAnswer(int index) {
    final correct = questions[questionIndex]['answer'];
    if (index == correct) {
      context.read<GameState>().addMoney(1000);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jawaban benar! +\$1000')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jawaban salah!')),
      );
    }
    removedOptions.clear();
    timeLeft = 30;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[questionIndex];
    final options = q['options'] as List<String>;
    final money = context.watch<GameState>().money;

    return Scaffold(
      backgroundColor: const Color(0xFFFFB300),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB300),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            'Waktu: $timeLeft',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/logo1.png', height: 200),
                  Positioned(
                    top: 40,
                    child: Image.asset('assets/images/logo2.png', height: 80),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '\$$money',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                q['question'],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),

            // lifelines
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: usedFifty ? null : useFifty,
                  icon: const Icon(Icons.percent, color: Colors.black, size: 28),
                ),
                IconButton(
                  onPressed: usedRefresh ? null : useRefresh,
                  icon: const Icon(Icons.refresh, color: Colors.black, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // options
            ...List.generate(4, (i) {
              final disabled = removedOptions.contains(i);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: disabled ? null : () => checkAnswer(i),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: disabled ? Colors.grey : Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    '${String.fromCharCode(65 + i)}. ${options[i]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
