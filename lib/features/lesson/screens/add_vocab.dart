import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ku_didik/common_widgets/didik_app_bar.dart';
import 'package:ku_didik/test.dart';
import 'package:translator/translator.dart' as translator_package;

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

final databaseReference =
    FirebaseDatabase.instance.ref('users/Irfan Yusri/english/vocab/words');

class _AddVocabState extends State<AddVocab> {
  final TextEditingController _vocabController = TextEditingController();
  final _refreshController = StreamController<void>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(title: 'Add Your Vocabulary'),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<void>(
                stream: _refreshController.stream,
                builder: (context, snapshot) {
                  return FutureBuilder(
                    future: _getData(),
                    builder: (context, AsyncSnapshot<List<Word>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Word> words = snapshot.data!;
                        return CarouselSlider(
                          options: CarouselOptions(
                            height: 400.0,
                            enlargeCenterPage: true,
                          ),
                          items: words.map((word) {
                            return CarouselItem(
                              word: word.word,
                              meaning: word.meaning,
                              onDelete: () {
                                _handleDeleteWord(word.key);
                              },
                            );
                          }).toList(),
                        );
                      }
                    },
                  );
                }),
          ),
          _buildAddVocabSection(),
        ],
      ),
    );
  }

  void _refresh() {
    // Add an empty event to the stream to trigger a refresh
    _refreshController.add(null);
  }

  Widget _buildAddVocabSection() {
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
                'Irfan Yusri',
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
            child: Text(
              'Add',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Word>> _getData() async {
    DatabaseEvent event = await databaseReference.once();
    DataSnapshot snapshot = event.snapshot;
    List<Word> words = [];

    Map<dynamic, dynamic> values =
        (snapshot.value as Map<dynamic, dynamic>) ?? {};
    values.forEach((key, value) {
      words.add(Word(
        word: value['word'],
        meaning: value['meaning'],
        key: key,
      ));
    });

    return words;
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

  void _handleDeleteWord(String word) {
    databaseReference.child(word).remove();
    setState(() {
      // Refresh the UI after deleting a word
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
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(word),
            subtitle: Text(meaning),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ),
          if (word.isEmpty && meaning.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please add a word and its meaning.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
