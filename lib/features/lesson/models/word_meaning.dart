import 'package:firebase_database/firebase_database.dart';

class WordMeaning {
  final String word;
  final String meaning;

  WordMeaning({required this.word, required this.meaning});

  factory WordMeaning.fromSnapshot(DataSnapshot snapshot) {
    final Map<dynamic, dynamic>? data =
        snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      return WordMeaning(
        word: data['word'] ?? '',
        meaning: data['meaning'] ?? '',
      );
    } else {
      // Handle the case where snapshot.value is null or not a Map
      // You can throw an exception, return a default value, or handle it accordingly.
      throw Exception('Invalid snapshot value');
    }
  }
}
