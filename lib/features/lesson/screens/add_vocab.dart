import 'package:flutter/material.dart';
import 'package:ku_didik/common_widgets/didik_app_bar.dart';
import 'package:firebase_database/firebase_database.dart';

class AddVocab extends StatefulWidget {
  const AddVocab({Key? key}) : super(key: key);

  @override
  State<AddVocab> createState() => _AddVocabState();
}

class _AddVocabState extends State<AddVocab> {
  DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _vocabController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the modal bottom sheet when the FAB is clicked
          _showAddVocabModal(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: RoundedAppBar(
        title: 'Adding More Vocab',
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DatabaseEvent>(
          stream: ref.onValue,
          builder:
              (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            var data = snapshot.data?.snapshot.value as Map<String, dynamic>?;

            print('data: $data  ');
            if (data != null) {
              return Text(data.toString());
            } else {
              return Text('No data');
            }
          },
        ),
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
                    onPressed: () {
                      // Handle adding vocab here
                      String enteredVocab = _vocabController.text;
                      // TODO: Add your logic to handle the vocab
                      print('Added Vocab: $enteredVocab');

                      // Close the modal
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromHeight(40.0),
                      backgroundColor:
                          Colors.teal, // Set your desired background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
