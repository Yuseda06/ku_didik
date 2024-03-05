import 'package:flutter/material.dart';

class WordsProvider extends ChangeNotifier {
  late String _words = '';

  String get words => _words;

  void setWords(String newWords) {
    _words = newWords;

    notifyListeners();
  }

  void clearWords() {
    _words = '';

    notifyListeners();
  }
}
