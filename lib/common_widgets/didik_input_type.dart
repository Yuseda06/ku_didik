import 'package:flutter/material.dart';

class DidikInputType extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  DidikInputType({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.transparent,
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextField(
          obscureText: hintText == 'Password' ? true : false,
          controller: controller,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.black45,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
