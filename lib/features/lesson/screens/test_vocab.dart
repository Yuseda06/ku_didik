import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ku_didik/common_widgets/didik_app_bar.dart';
import 'package:ku_didik/features/lesson/controllers/firebase_controller.dart';
import 'package:ku_didik/test.dart';
import 'package:ku_didik/utils/provider/score_provider.dart';
import 'package:ku_didik/utils/provider/username_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;

class TestVocab extends StatefulWidget {
  const TestVocab({super.key});

  @override
  State<TestVocab> createState() => _TestVocabState();
}

class _TestVocabState extends State<TestVocab> {
  late BuildContext storedContext;
  late int scoreLate = 0;
  late String usernameLate = '';
  late String wordEnteredLate = '';

  bool autoPlay = false;
  final StreamController<void> _refreshController =
      StreamController<void>.broadcast();

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // updateScore(usernameLate, 'wrong', scoreLate, storedContext);
    // print("scoreLate $scoreLate"); // Do some stuff.
    // Navigator.of(storedContext).pushReplacementNamed('/home');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    storedContext = context;
    final usernameProvider = Provider.of<UsernameProvider>(context);
    String username = usernameProvider.username ?? '';
    usernameLate = username;

    final scoreProvider = Provider.of<ScoreProvider>(context);
    String score = scoreProvider.score ?? '';

    scoreLate = int.parse(score);
    void goToHome() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TestVocab()),
      );
    }

    return Scaffold(
      appBar: RoundedAppBar(title: 'Test Your Vocab!'),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 30.0, left: 100.0, right: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Current Score:', style: TextStyle(fontSize: 20)),
                Text(score,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal)),
              ],
            ),
          ),
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
                            autoPlay: autoPlay,
                            height: MediaQuery.of(context).size.height * 0.6,
                            enlargeCenterPage: true,
                          ),
                          items: words.map((word) {
                            return CarouselItem(
                                word: word.word,
                                meaning: word.meaning,
                                wordKey: word.key,
                                refresh: _refreshController);
                          }).toList(),
                        );
                      }
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
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

    // Take only 20 items
    sortedValues = sortedValues.toList();

    // Randomize the order
    sortedValues.shuffle();

    sortedValues = sortedValues.take(1).toList();

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
          word: "Your Vocab is Zero", meaning: 'Please Add Some', key: "762431")
    ]; // Return an empty list or handle it in a way that makes sense for your application
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

void _speakWord(String word, FlutterTts flutterTts) async {
  final language = langdetect.detect(word);

  // FlutterTts flutterTts = FlutterTts();

  // Map detected language to FlutterTts language code (adjust as needed)
  String flutterTtsLanguageCode = _mapLanguageToFlutterTtsCode(language);

  // Set language to FlutterTts
  await flutterTts.setLanguage(flutterTtsLanguageCode);

  // Speak the word
  await flutterTts.speak(word);
}

String _mapLanguageToFlutterTtsCode(String language) {
  // Map detected language to FlutterTts language code
  // You may need to customize this mapping based on your needs
  switch (language.toLowerCase()) {
    case 'en':
      return 'en-US'; // Example: 'en-US' for English (United States)
    case 'es':
      return 'es-US'; // Example: 'es-US' for Spanish (United States)
    // Add more cases for other languages if needed
    default:
      return 'en-US'; // Default to English
  }
}

String capitalize(String s) {
  if (s == null || s.isEmpty) {
    return s;
  }
  return s[0].toUpperCase() + s.substring(1);
}

class CarouselItem extends StatefulWidget {
  final String word;
  final String meaning;
  final String wordKey;
  final StreamController<void> refresh;

  const CarouselItem({
    required this.word,
    required this.meaning,
    required this.wordKey,
    required this.refresh,
  });

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem> {
  bool isVisible = false;
  bool isCorrect = false; // Added variable to track correctness
  FlutterTts flutterTts = FlutterTts();
  TextEditingController meaningController = TextEditingController();
  FocusNode meaningFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final usernameProvider = Provider.of<UsernameProvider>(context);
    String username = usernameProvider.username ?? '';

    final scoreProvider = Provider.of<ScoreProvider>(context);
    String score = scoreProvider.score ?? '';

    meaningFocusNode.requestFocus();

    Widget resultWidget() {
      if (isVisible) {
        if (isCorrect) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 250,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 15.0, 0.0, 0.0),
                  child: Column(
                    children: [
                      Text(
                        'Correct!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 35,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'another 10 more points added!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 250,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 15.0, 0.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Wrong! The correct meaning is:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      capitalize(widget.meaning),
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '- 5 points!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      } else {
        return Container();
      }
    }

    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 234, 234, 233),
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    _speakWord(widget.word, flutterTts);
                  },
                  child: Text(
                    capitalize(widget.word),
                    style: TextStyle(
                      color: const Color.fromARGB(255, 138, 106, 7),
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 283,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 15.0, 0.0, 0.0),
                  child: TextField(
                    // onTapOutside: (event) {
                    //   setState(() {
                    //     isVisible = true;
                    //   });

                    //   String enteredMeaning = meaningController.text;

                    //   isCorrect = enteredMeaning.toLowerCase().trim() ==
                    //       widget.meaning.toLowerCase().trim();

                    //   meaningFocusNode.unfocus();

                    //   Future.delayed(Duration(seconds: 3), () {
                    //     setState(() {
                    //       updateScore(username, isCorrect ? 'correct' : 'wrong',
                    //           int.parse(score), context);
                    //     });
                    //   });
                    // },
                    enabled: isVisible ? false : true,
                    focusNode: meaningFocusNode,
                    // maxLines: null,
                    controller: meaningController,
                    decoration: InputDecoration(
                      labelText: 'Enter meaning',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Visibility(
                visible: !isVisible,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isVisible = true;
                    });

                    String enteredMeaning = meaningController.text;

                    isCorrect = enteredMeaning.toLowerCase().trim() ==
                        widget.meaning.toLowerCase().trim();

                    meaningFocusNode.unfocus();

                    Future.delayed(Duration(seconds: 3), () {
                      setState(() {
                        updateScore(username, isCorrect ? 'correct' : 'wrong',
                            int.parse(score), context);
                      });
                    });

                    // Trigger a rebuild to update the UI
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                  ),
                  child: Text(
                    'Check!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              resultWidget(),
              SizedBox(height: 20),
              // Padding(
              //   padding: const EdgeInsets.only(top: 50),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       IconButton(
              //           onPressed: () {
              //             String enteredMeaning = meaningController.text;

              //             isCorrect = enteredMeaning.toLowerCase().trim() ==
              //                 widget.meaning.toLowerCase().trim();
              //             updateScore(username, isCorrect ? 'correct' : 'wrong',
              //                 int.parse(score), context);

              //             Navigator.of(context).pushReplacementNamed('/home');
              //           },
              //           icon: Icon(
              //             Icons.home_filled,
              //             size: 30,
              //             color: Colors.black54,
              //           )),
              //     ],
              //   ),
              // )

              // Display correct/wrong message
            ],
          ),
        ),
      ),
    );
  }
}
