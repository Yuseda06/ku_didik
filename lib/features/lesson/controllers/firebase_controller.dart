import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:ku_didik/features/lesson/models/word_meaning.dart';

class FirebaseController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> handleDeleteWord(String wordKey, String username) async {
    try {
      // Construct the path to the word in the database
      String wordPath = 'users/$username/english/vocab/words/$wordKey';

      // Get a reference to the word in the database
      DatabaseReference wordRef = FirebaseDatabase.instance.ref(wordPath);

      // Remove the word and its children (meaning, timestamp) from the database
      await wordRef.remove();

      print(
          'Word and associated data deleted successfully for wordKey: $wordKey');
    } catch (error) {
      print('Error deleting word and associated data: $error');
      // Handle the error as needed
    }
  }

  Future<void> handleAddWord(
    String word,
    String meaning,
    String username,
  ) async {
    try {
      // Construct the path to the words in the database
      String path = 'users/$username/english/vocab/words';

      // Get a reference to the words in the database and push a new child
      DatabaseReference wordsRef = FirebaseDatabase.instance.ref(path);
      DatabaseReference newWordRef = wordsRef.push();

      // Set the values for the new word entry
      await newWordRef.set({
        'word': word,
        'meaning': meaning,
        'timestamp': ServerValue.timestamp,
      });

      print('Word added successfully: $word');
    } catch (error) {
      print('Error adding word: $error');
      // Handle the error as needed
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
