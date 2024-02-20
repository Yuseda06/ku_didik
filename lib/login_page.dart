import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: emailController,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: passwordController,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(198, 196, 196,
                              1), // You can change the shadow color
                          spreadRadius:
                              1.0, // Adjust the spread radius for the shadow
                          blurRadius:
                              10.0, // Adjust the blur radius for the shadow
                          offset: Offset(
                              0.0, 2.0), // Adjust the offset for the shadow
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              60), // Adjust the value as needed
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),

                        // Adjust the values as needed
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(228, 228, 228,
                              1), // You can change the shadow color
                          spreadRadius:
                              1.0, // Adjust the spread radius for the shadow
                          blurRadius:
                              10.0, // Adjust the blur radius for the shadow
                          offset: Offset(
                              0.0, 2.0), // Adjust the offset for the shadow
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.fromLTRB(10, 40, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              60), // Adjust the value as needed
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),

                        // Adjust the values as needed
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 6, 100, 105)),
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
