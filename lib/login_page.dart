import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ku_didik/common_widgets/didik_input_type.dart';
import 'package:package_info/package_info.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String version = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    _getVersionInfo();
  }

  Future<void> _getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                  bottomLeft:
                      Radius.circular(20.0), // Adjust the radius as needed
                  bottomRight:
                      Radius.circular(20.0), // Adjust the radius as needed
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
              Text('Welcome Back',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  )),
              const SizedBox(
                height: 40,
              ),
              DidikInputType(
                  controller: emailController, hintText: 'Email Address'),
              const SizedBox(
                height: 15,
              ),
              DidikInputType(
                  controller: passwordController, hintText: 'Password'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black12, // You can change the shadow color
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
                            horizontal: 30, vertical: 12),

                        // Adjust the values as needed
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black12, // You can change the shadow color
                          spreadRadius:
                              0.5, // Adjust the spread radius for the shadow
                          blurRadius:
                              10.0, // Adjust the blur radius for the shadow
                          offset: Offset(
                              0.0, 2.0), // Adjust the offset for the shadow
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.fromLTRB(30, 40, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_up');
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.teal[600],
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
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 90,
              ),
              Center(
                child: Text('Version: $version', style: TextStyle(fontSize: 8)),
              ),
              Center(
                child: Text('Build Number: $buildNumber',
                    style: TextStyle(fontSize: 8)),
              ),
            ]),
      ),
    );
  }
}
