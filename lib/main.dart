import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ku_didik/home_page.dart';
import 'package:ku_didik/login_page.dart';
import 'package:ku_didik/signup_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  String apiKey = dotenv.env['API_KEY'] ?? '';
  String appId = dotenv.env['APP_ID'] ?? '';
  String messagingSenderId = dotenv.env['MESSAGING_SENDER_ID'] ?? '';
  String projectId = dotenv.env['PROJECT_ID'] ?? '';

  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: apiKey,
              appId: appId,
              messagingSenderId: messagingSenderId,
              projectId: projectId))
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/sign_in': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/sign_up': (context) => const SignUpPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber)
            .copyWith(secondary: Colors.amberAccent),
        useMaterial3: false,
      ),
      home: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const SignUpPage();
            } else if (snapshot.hasData) {
              return const HomePage();
            } else {
              // Check if a user has just signed up
              if (FirebaseAuth.instance.currentUser != null) {
                // Navigate to HomePage after signup
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, '/home');
                });
                return Container(); // Return an empty container as navigation is in progress
              } else {
                return const LoginPage();
              }
            }
          },
        ),
      ),
    );
  }
}
