import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ku_didik/common_widgets/didik_app_bar.dart';
import 'package:ku_didik/test.dart';
import 'package:ku_didik/utils/theme/username_provider.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart' as translator_package;
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddVocab(),
    );
  }
}

class AddVocab extends StatefulWidget {
  const AddVocab({Key? key}) : super(key: key);

  @override
  State<AddVocab> createState() => _AddVocabState();
}

class _AddVocabState extends State<AddVocab> {
  final TextEditingController _vocabController = TextEditingController();
  final _refreshController = StreamController<void>.broadcast();

  @override
  Widget build(BuildContext context) {
    final usernameProvider = Provider.of<UsernameProvider>(context);
    String username = usernameProvider.username ?? '';

    return Scaffold(
      appBar: RoundedAppBar(title: 'Add Your Vocabulary'),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<void>(
                stream: _refreshController.stream,
                builder: (context, snapshot) {
                  return FutureBuilder(
                    future: _getData(username),
                    builder: (context, AsyncSnapshot<List<Word>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Word> words = snapshot.data!;
                        return CarouselSlider(
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                            height: 400.0,
                            enlargeCenterPage: true,
                          ),
                          items: words.map((word) {
                            return CarouselItem(
                              word: word.word,
                              meaning: word.meaning,
                              onDelete: () {
                                _handleDeleteWord(username, word.key);
                              },
                            );
                          }).toList(),
                        );
                      }
                    },
                  );
                }),
          ),
          _buildAddVocabSection(username),
        ],
      ),
    );
  }

  void _refresh() {
    // Add an empty event to the stream to trigger a refresh
    _refreshController.add(null);
  }

  Widget _buildAddVocabSection(username) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _vocabController,
            decoration: InputDecoration(
              labelText: 'Enter Words Here!',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              String enteredVocab = _vocabController.text;
              String bahasaMalaysiaMeaning =
                  await _translateToBahasaMalaysia(enteredVocab);

              await firebaseController.handleAddWord(
                enteredVocab,
                bahasaMalaysiaMeaning,
                username,
              );
              // Clear the text field
              _refresh();
              _vocabController.clear();
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(40.0),
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Container(
              width: double.infinity,
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Word>> _getData(String username) async {
    try {
      DatabaseReference userDatabaseReference =
          FirebaseDatabase.instance.ref('users/$username/english/vocab/words');

      DatabaseEvent event =
          await userDatabaseReference.orderByChild('timestamp').once();
      DataSnapshot snapshot = event.snapshot;
      List<Word> words = [];

      Map<dynamic, dynamic> values =
          (snapshot.value as Map<dynamic, dynamic>) ?? {};

      // Sort the values based on timestamp
      List<MapEntry<dynamic, dynamic>> sortedValues = values.entries.toList()
        ..sort((a, b) =>
            (b.value['timestamp'] ?? 0).compareTo(a.value['timestamp'] ?? 0));

      for (var entry in sortedValues) {
        words.add(Word(
          word: entry.value['word'],
          meaning: entry.value['meaning'],
          key: entry.key,
        ));
      }

      return words;
    } catch (error) {
      print('Error retrieving data: $error');
      // Handle the error as needed
      return [
        Word(
            word: "Your Vocab is Zero",
            meaning: 'Please Add Some',
            key: "762431")
      ]; // Return an empty list or handle it in a way that makes sense for your application
    }
  }

  Future<String> _translateToBahasaMalaysia(String englishWord) async {
    // Create a translator instance
    final translator_package.GoogleTranslator translator =
        translator_package.GoogleTranslator();

    // Translate to Bahasa Malaysia
    var translation =
        await translator.translate(englishWord, from: 'en', to: 'ms');

    return translation.text;
  }

  void _handleDeleteWord(String username, String word) {
    print('username: $username');
    DatabaseReference userDatabaseReference =
        FirebaseDatabase.instance.ref('users/$username/english/vocab/words');

    userDatabaseReference.child(word).remove().then((_) {
      // Successfully deleted
      setState(() {
        // Refresh the UI after deleting a word
      });
    }).catchError((error) {
      print('Error deleting word: $error');
      // Handle the error as needed
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

void _speakWord(word) {
  FlutterTts flutterTts = FlutterTts();
  flutterTts.setLanguage("en-US");
  // Set language to English or your desired language
  flutterTts.speak(word);
}

String capitalize(String s) {
  if (s == null || s.isEmpty) {
    return s;
  }
  return s[0].toUpperCase() + s.substring(1);
}

class CarouselItem extends StatelessWidget {
  final String word;
  final String meaning;
  final VoidCallback onDelete;

  const CarouselItem({
    required this.word,
    required this.meaning,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.all(8.0), // Add margin for better visibility of the shadow
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color of the card
        borderRadius:
            BorderRadius.circular(16.0), // Adjust the radius as needed
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 234, 234, 233),
            blurRadius: 10.0, // Adjust the blur radius as needed
            spreadRadius: 5.0, // Adjust the spread radius as needed
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            ListTile(
              title: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {
                  _speakWord(word);
                },
                child: Text(
                  capitalize(word),
                  style: TextStyle(
                    color: const Color.fromARGB(255, 138, 106, 7),
                    fontSize: 30,
                  ),
                ),
              ),
              subtitle: SizedBox(
                width: 250, // Set the maximum width as needed
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20.0, 0.0, 0.0),
                  child: Text(
                    capitalize(meaning),
                    style: TextStyle(
                      color: Color.fromARGB(255, 96, 96, 94),
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 5.0,
              right: 5.0,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: 40.0),
                onPressed: onDelete,
              ),
            ),
            Positioned(
              top: 5.0,
              right: 0.0,
              child: Icon(Icons.volume_up, color: Colors.teal, size: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
