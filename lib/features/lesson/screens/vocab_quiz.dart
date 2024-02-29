import 'package:flutter/material.dart';

class VocabularyQuizScreen extends StatefulWidget {
  final List<Word> words; // Assuming Word class is defined

  VocabularyQuizScreen({required this.words});

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
    for (int i = 0; i < widget.words.length; i++) {
      controllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vocabulary Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.words.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.words[index].word),
                    subtitle: TextField(
                      controller: controllers[index],
                      decoration: InputDecoration(labelText: 'Enter meaning'),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _checkAnswers();
              },
              child: Text('Check'),
            ),
            SizedBox(height: 16),
            Text('Correct: $correctCount, Wrong: $wrongCount'),
          ],
        ),
      ),
    );
  }

  void _checkAnswers() {
    int correct = 0;
    int wrong = 0;

    for (int i = 0; i < widget.words.length; i++) {
      String enteredMeaning = controllers[i].text.trim().toLowerCase();
      String correctMeaning = widget.words[i].meaning.trim().toLowerCase();

      if (enteredMeaning == correctMeaning) {
        correct++;
      } else {
        wrong++;
      }
    }

    setState(() {
      correctCount = correct;
      wrongCount = wrong;
    });
  }
}

class Word {
  final String word;
  final String meaning;
  final String key;

  Word({
    required this.word,
    required this.meaning,
    required this.key,
  });

  // Factory constructor to create Word instance from a map
  factory Word.fromMap(String key, Map<String, dynamic> map) {
    return Word(
      word: map['word'],
      meaning: map['meaning'],
      key: key,
    );
  }
}
