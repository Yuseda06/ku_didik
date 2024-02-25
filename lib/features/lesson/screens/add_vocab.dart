import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:ku_didik/common_widgets/didik_app_bar.dart';
import 'package:ku_didik/features/lesson/controllers/firebase_controller.dart';
// Replace with the actual path
import 'package:translator/translator.dart' as translator_package;

class AddVocab extends StatefulWidget {
  const AddVocab({Key? key}) : super(key: key);

  @override
  State<AddVocab> createState() => _AddVocabState();
}

final firebaseController = FirebaseController(); // Create an instance
final databaseReference =
    FirebaseDatabase.instance.ref('users/Irfan Yusri/english/vocab/words');

class _AddVocabState extends State<AddVocab> {
  final TextEditingController _vocabController = TextEditingController();

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
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: databaseReference.orderByChild('timestamp'),
              itemBuilder: (context, snapshot, index, animation) {
                String word = snapshot.child('word').value?.toString() ?? "";
                String wordKey = snapshot.key ?? ""; // Get the unique key
                // Print the unique key (for debugging purposes
                // Get the meaning from the child 'meaning' and handle null case
                String meaning =
                    snapshot.child('meaning').value?.toString() ?? "";

                return ListTile(
                  title: Text(word),
                  subtitle: Text(meaning),
                  leading: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child:
                        const Icon(Icons.circle, color: Colors.teal, size: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Call handleDeleteWord from FirebaseController
                      firebaseController.handleDeleteWord(
                        wordKey,
                        'Irfan Yusri',
                        // Replace with the actual username
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
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
                      'Irfan Yusri',
                      // Replace with the actual username
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
}
