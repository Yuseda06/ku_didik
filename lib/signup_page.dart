import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ku_didik/common_widgets/didik_button.dart';
import 'package:ku_didik/common_widgets/didik_input_type.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final profileUrlController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    profileUrlController.dispose();
    super.dispose();
  }

  // Function to handle user registration
  Future<void> _signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Navigate to home page upon successful registration
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Handle registration failure, you can show an error message
      print('Error during registration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(16.0), // Adjust the radius as needed
                  bottomRight:
                      Radius.circular(16.0), // Adjust the radius as needed
                ),
                child: Image.asset(
                  'assets/images/login.gif',
                  height: 250,
                  width: MediaQuery.of(context).size.width * 1.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text('Create an account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  )),
              const SizedBox(
                height: 40,
              ),
              DidikInputType(
                  controller: usernameController, hintText: 'Username'),
              const SizedBox(
                height: 15,
              ),
              DidikInputType(
                  controller: profileUrlController, hintText: 'Profile URL'),
              const SizedBox(
                height: 15,
              ),
              DidikInputType(
                  controller: emailController, hintText: 'Email Address'),
              const SizedBox(
                height: 15,
              ),
              DidikInputType(
                  controller: passwordController, hintText: 'Password'),
              DidikButton(
                  emailController: emailController,
                  passwordController: passwordController,
                  hintText: "Sign Up",
                  buttonColor: Colors.teal,
                  isSignIn: false),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign_in');
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
