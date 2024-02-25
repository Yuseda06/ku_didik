import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:ku_didik/features/lesson/models/word_meaning.dart';

class FirebaseController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> handleAddWord(
      String word, String meaning, String? username) async {
    print("word in english $word");
    print("meaning in english $meaning");

    if (username != null) {
      final userLessonRef =
          _database.child('users/$username/english/vocab/words/$word');

      // Set the meaning directly under the word
      await userLessonRef.set({'meaning': meaning});
      print("Word added successfully");
    } else {
      // If user doesn't exist, create the user and then add the word
      final newUserRef = _database.child('users').push();
      final newUserId = newUserRef.key;

      final newUserLessonRef =
          _database.child('users/$newUserId/english/vocab/words/$word');

      // Set the meaning directly under the word
      await newUserLessonRef.set({'meaning': meaning});
      print("User and word added successfully");
    }
  }

  Future<WordMeaning?> retrieveWord(String username, String word) async {
    final userLessonRef =
        _database.child('users/$username/english/vocab/words/$word');

    // Use the onValue method to listen for changes
    final completer =
        Completer<WordMeaning?>(); // Completer to handle async operation

    userLessonRef.onValue.listen((event) {
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        // Use WordMeaning.fromSnapshot to convert the snapshot to your model
        final wordMeaning = WordMeaning.fromSnapshot(snapshot);
        completer.complete(wordMeaning);
      } else {
        completer.complete(null);
      }
    });

    // Return the Future from the Completer
    return completer.future;
  }
}
