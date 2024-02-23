import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DidikButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? usernameController;
  final TextEditingController? profileUrlController;
  final String hintText;
  final Color buttonColor;
  final bool isSignIn;
  final BuildContext? context;

  DidikButton({
    required this.emailController,
    required this.passwordController,
    required this.hintText,
    required this.buttonColor,
    required this.isSignIn,
    this.usernameController,
    this.profileUrlController,
    this.context,
  });

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1.0,
            blurRadius: 10.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: ElevatedButton(
        onPressed: () {
          if (isSignIn) {
            _signInWithEmailAndPassword();
          } else {
            _signUp();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
      print('Error signing in: $e');
    }
  }

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String userId = userCredential.user!.uid;

      if (usernameController != null && profileUrlController != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'username': usernameController!.text.trim(),
          'profileUrl': profileUrlController!.text.trim(),
        });
      }

      if (context != null) {
        Navigator.pushReplacementNamed(context!, '/home');
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        // Handle Firebase Authentication errors
        switch (e.code) {
          case 'invalid-email':
            showToast('Please enter a valid email');
            break;
          case 'user-disabled':
            showToast('User with this email has been disabled');
            break;
          case 'user-not-found':
            showToast('User with this email not found');
            break;
          case 'wrong-password':
            showToast('Wrong password provided for this user');
            break;
          case 'email-already-in-use':
            showToast('Email address is already in use');
            break;
          case 'account-exists-with-different-credential':
            showToast('Email address already exists with a different sign-in');
            break;
          case 'requires-recent-login':
            showToast('Please sign in again to continue');
          case 'weak-password':
            showToast('Password provided is too weak');
            break;
          default:
            showToast('Error during registration: ${e.message}');
        }
      } else {
        // Handle other non-Firebase errors
        showToast('Error during registration: $e');
      }
    }
  }
}
