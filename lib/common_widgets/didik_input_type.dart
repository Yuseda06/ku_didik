import 'package:flutter/material.dart';

class DidikInputType extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  DidikInputType({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    Icon icon;

    if (hintText == 'Password') {
      icon = Icon(Icons.lock);
    } else if (hintText == 'Email Address') {
      icon = Icon(Icons.email);
    } else if (hintText == 'Username') {
      icon = Icon(Icons.person);
    } else {
      icon = Icon(Icons.link);
    }

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
            contentPadding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
            prefixIcon: icon,
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
