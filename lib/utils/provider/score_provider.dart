import 'package:flutter/material.dart';

class ScoreProvider extends ChangeNotifier {
  late String _score = '';

  String get score => _score;

  void setScore(String newScore) {
    _score = newScore;

    notifyListeners();
  }

  void clearScore() {
    _score = '';

    notifyListeners();
  }
}
