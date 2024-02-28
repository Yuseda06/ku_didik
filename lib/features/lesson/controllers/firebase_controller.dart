import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseController {
  Future<void> handleDeleteWord(String word, String username) async {
    try {
      // Construct the path to the word in the database
      String path = 'users/$username/english/vocab/words/$word';

      // Get a reference to the word in the database
      DatabaseReference wordRef = FirebaseDatabase.instance.ref(path);

      // Remove the word from the database
      await wordRef.remove();

      print('Word deleted successfully: $word');
    } catch (error) {
      print('Error deleting word: $error');
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
      print('username: $username');
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

      // Update the word count in Firestore
      await updateWordCount(username);
    } catch (error) {
      print('Error adding word: $error');
      // Handle the error as needed
    }
  }

  Future<void> updateWordCount(username) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'wordCount': await _retrieveWordCount(username),
        });
        print(_retrieveWordCount(username));
//close the model sheet
      } catch (error) {
        print('Failed to update profile in Firestore: $error');
      }
    }
  }
}

Future<int> _retrieveWordCount(String username) async {
  final user = FirebaseAuth.instance.currentUser;
  List<String> wordList = [];
  int wordCount = 0;

  if (user != null) {
    try {
      // Use FirebaseDatabase instead of FirebaseFirestore
      DatabaseReference userDatabaseReference =
          FirebaseDatabase.instance.ref('users/$username/english/vocab/words');

      DatabaseEvent event = await userDatabaseReference.once();
      DataSnapshot snapshot = event.snapshot;

      // Check if the snapshot has data
      if (snapshot.value != null) {
        // Iterate through the children and add them to the wordList
        snapshot.children.forEach((childSnapshot) {
          String word = childSnapshot.key as String;
          wordList.add(word);
          wordCount++;
        });

        // You can now use the wordList as needed
        print('snapshot: $wordCount');
        return wordCount;
      } else {
        print('Snapshot is null');
      }
    } catch (error) {
      print('Failed to retrieve word list from Realtime Database: $error');
    }
  }

  // Return an empty list or another default value in case of an error or if the data is not available
  return 0;
}
