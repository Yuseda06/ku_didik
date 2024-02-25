import 'package:flutter/material.dart';
import 'package:ku_didik/common_widgets/didik_button.dart';
import 'package:ku_didik/common_widgets/didik_input_type.dart';
import 'package:package_info/package_info.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
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
                  'Welcome Back',
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
                const SizedBox(
                  height: 30,
                ),
                DidikButton(
                  emailController: emailController,
                  passwordController: passwordController,
                  buttonColor: Colors.amber,
                  hintText: 'Sign In',
                  isSignIn: true,
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account yet?",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_up');
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Version: $version',
                    style: TextStyle(fontSize: 8),
                  ),
                  Text(
                    'Build Number: $buildNumber',
                    style: TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
