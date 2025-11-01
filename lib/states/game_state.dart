import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameState extends ChangeNotifier {
  String playerName = '';
  int money = 0;

  // set nama player
  void setPlayerName(String name) {
    playerName = name;
    saveName();
    notifyListeners();
  }

  // tambah uang
  void addMoney(int amount) {
    money += amount;
    notifyListeners();
  }

  void resetGame() {
    money = 0;
    playerName = '';
    notifyListeners();
  }

  // simpan nama ke lokal
  Future<void> saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('playerName', playerName);
  }

  // load nama dari lokal
  Future<void> loadName() async {
    final prefs = await SharedPreferences.getInstance();
    playerName = prefs.getString('playerName') ?? '';
    notifyListeners();
  }
}
