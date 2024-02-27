import 'package:flutter/material.dart';
import 'package:ku_didik/common_widgets/didik_button.dart';
import 'package:ku_didik/common_widgets/didik_input_type.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
                bottomLeft: Radius.circular(60.0),
                bottomRight: Radius.circular(60.0),
              ),
              child: Image.asset(
                'assets/images/login.gif',
                height: 300,
                width: MediaQuery.of(context).size.width * 1.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'Create an Account',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            DidikInputType(
              controller: usernameController,
              hintText: 'Username',
            ),
            const SizedBox(
              height: 15,
            ),
            // DidikInputType(
            //   controller: profileUrlController,
            //   hintText: 'Profile URL',
            // ),
            // const SizedBox(
            //   height: 15,
            // ),
            DidikInputType(
              controller: emailController,
              hintText: 'Email Address',
            ),
            const SizedBox(
              height: 15,
            ),
            DidikInputType(
              controller: passwordController,
              hintText: 'Password',
            ),
            DidikButton(
                usernameController: usernameController,
                profileUrlController: profileUrlController,
                emailController: emailController,
                passwordController: passwordController,
                hintText: "Sign Up",
                buttonColor: Colors.teal,
                isSignIn: false,
                context: context),
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
          ],
        ),
      ),
    );
  }
}
