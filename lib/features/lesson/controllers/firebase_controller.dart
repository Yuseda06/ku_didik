import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ku_didik/utils/provider/score_provider.dart';
import 'package:provider/provider.dart';

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

  Future<void> handleUpdateMeaning(
    String enteredMeaning,
    String username,
    String wordKey, // Pass the wordKey to identify the specific word
  ) async {
    try {
      // Construct the path to the word in the database
      String path = 'users/$username/english/vocab/words/$wordKey';
      // String path = 'users/$username/english/vocab/words/';
      // Get a reference to the specific word in the database
      DatabaseReference wordRef = FirebaseDatabase.instance.ref(path);

      // Set only the value for enteredMeaning without changing the timestamp
      await wordRef.update({
        'enteredMeaning': enteredMeaning.toLowerCase(),
      });
    } catch (error) {
      print('Error updating meaning: $error');
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

Future<String> getScore(String username, BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Access the 'score' field from the document
      dynamic score = userDoc.get('score');

      String scoreString = score.toString();

      Provider.of<ScoreProvider>(context, listen: false).setScore(scoreString);

      print('score: $scoreString');

      return scoreString;
      // Close the modal sheet
    } catch (error) {
      print('Failed to get score in Firestore: $error');
    }
  }
  return '0';
}

Future<void> updateScore(String username, String status, int score) async {
  print('newScore: $username');
  print('newScore: $status');
  try {
    final user = FirebaseAuth.instance.currentUser;

    // int newScore = int.parse(score);

    // if (status == 'correct') {
    //   newScore += 10;
    // } else if (status == 'wrong') {
    //   newScore -= 5;
    // }

    print('newScore: $score');
    // if (user != null) {
    //   try {
    //     await FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(user.uid)
    //         .update({
    //       'count': await _retrieveScore(username),
    //     });
    //   } catch (error) {
    //     print('Failed to update profile in Firestore: $error');
    //   }
    // }
  } on Exception catch (e) {
    print('Error))))))))))))))): $e');
  }
}
