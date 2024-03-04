import 'package:flutter/material.dart';

class VocabularyQuizScreen extends StatefulWidget {
  // final List<Word> words; // Assuming Word class is defined

  // VocabularyQuizScreen({required this.words});

  @override
  _VocabularyQuizScreenState createState() => _VocabularyQuizScreenState();
}

class _VocabularyQuizScreenState extends State<VocabularyQuizScreen> {
  List<TextEditingController> controllers = [];
  int correctCount = 0;
  int wrongCount = 0;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers for each word
    // for (int i = 0; i < widget.words.length; i++) {
    //   controllers.add(TextEditingController());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vocabulary Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Hello, World!'), // Replace with the actual UI
      ),
    );
  }
}
