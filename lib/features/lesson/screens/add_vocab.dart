import 'package:flutter/material.dart';
import 'package:ku_didik/common_widgets/didik_app_bar.dart';

class AddVocab extends StatefulWidget {
  const AddVocab({super.key});

  @override
  State<AddVocab> createState() => _AddVocabState();
}

class _AddVocabState extends State<AddVocab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(
        title: 'Adding More Vocab',
      ),
      body: const Center(
        child: Text('Add Vocab'),
      ),
    );
  }
}
