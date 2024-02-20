import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ku_didik/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LoginPage();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home Page'),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(' ${user.email}'),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(
                      228, 228, 228, 1), // You can change the shadow color
                  spreadRadius: 1.0, // Adjust the spread radius for the shadow
                  blurRadius: 10.0, // Adjust the blur radius for the shadow
                  offset: Offset(0.0, 2.0), // Adjust the offset for the shadow
                ),
              ],
            ),
            margin: const EdgeInsets.fromLTRB(10, 40, 0, 0),
            child: ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(60), // Adjust the value as needed
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

                // Adjust the values as needed
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 6, 100, 105)),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
