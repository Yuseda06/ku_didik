import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DidikButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String hintText;
  final Color buttonColor;
  final bool isSignIn;

  DidikButton(
      {required this.emailController,
      required this.passwordController,
      required this.hintText,
      required this.buttonColor,
      required this.isSignIn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // You can change the shadow color
            spreadRadius: 1.0, // Adjust the spread radius for the shadow
            blurRadius: 10.0, // Adjust the blur radius for the shadow
            offset: Offset(0.0, 2.0), // Adjust the offset for the shadow
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: ElevatedButton(
        onPressed: () {
          if (isSignIn) {
            _signInWithEmailAndPassword();
          } else {
            _createUserWithEmailAndPassword();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10), // Adjust the value as needed
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),

          // Adjust the values as needed
        ),
        child: Text(
          hintText,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      // Handle sign-in errors
      print('Error signing in: $e');
    }
  }

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      // Handle sign-up errors
      print('Error signing up: $e');
    }
  }
}
