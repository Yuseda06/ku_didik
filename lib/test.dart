import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ku_didik/common_widgets/didik_app_bar.dart';
import 'package:ku_didik/features/lesson/controllers/firebase_controller.dart';
import 'package:translator/translator.dart' as translator_package;

class AddVocab extends StatefulWidget {
  const AddVocab({Key? key}) : super(key: key);

  @override
  State<AddVocab> createState() => _AddVocabState();
}

final firebaseController = FirebaseController();

class _AddVocabState extends State<AddVocab> {
  final TextEditingController _vocabController = TextEditingController();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance
      .ref()
      .child(
          'vocabulary'); // Replace with your Firebase database reference path

  List<Map<String, dynamic>> _vocabList = [];

  @override
  void initState() {
    super.initState();
    _fetchVocabulary(); // Load initial data from Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddVocabModal(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: RoundedAppBar(
        title: 'Adding More Vocab',
      ),
      body: ListView.builder(
        itemCount: _vocabList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_vocabList[index]['word']),
            subtitle: Text(_vocabList[index]['meaning']),
          );
        },
      ),
    );
  }

  void _showAddVocabModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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

                    // Call handleAddWord from FirebaseController
                    await firebaseController.handleAddWord(
                      enteredVocab,
                      bahasaMalaysiaMeaning,
                      'Irfan Yusri', // Replace with the actual username
                    );

                    // Close the modal
                    Navigator.pop(context);
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
          ),
        );
      },
    );
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

  Future<void> _fetchVocabulary() async {
    _databaseReference.onValue.listen((event) {
      _vocabList.clear();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values =
            (event.snapshot.value as Map<dynamic, dynamic>);
        values.forEach((key, value) {
          _vocabList.add({
            'word': value['word'],
            'meaning': value['meaning'],
          });
        });
      }
      setState(() {});
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AddVocab(),
    );
  }
}
