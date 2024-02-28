import 'package:flutter/material.dart';

class TestVocab extends StatefulWidget {
  const TestVocab({super.key});

  @override
  State<TestVocab> createState() => _TestVocabState();
}

class _TestVocabState extends State<TestVocab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Test Vocab'),
        ),
        body: const Center(
          child: Text('Test Vocab'),
        ));
  }
}
