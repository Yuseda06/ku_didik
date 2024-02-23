import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ku_didik/features/authentication/models/users.dart';
import 'package:ku_didik/login_page.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.dark, // Dark icons on status bar
      systemNavigationBarColor:
          Colors.transparent, // Transparent navigation bar
      systemNavigationBarIconBrightness:
          Brightness.dark, // Dark icons on navigation bar
    ));

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LoginPage();
    }
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.amber,
      //   centerTitle: true,
      //   title: const Text('Home Page'),
      // ),
      body: Container(
        child: Stack(children: [
          Positioned(
            top: 50,
            left: 0,
            child: ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text('Sign Out'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20),
            child: SafeArea(
              child: StreamBuilder<List<Users>>(
                stream: readUser(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final users = snapshot.data!;
                    for (int i = 0; i < users.length; i++) {
                      print('User $i: ${users[i].username}');
                    }
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(users[index].username),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No data found'),
                    );
                  }
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

Stream<List<Users>> readUser() =>
    FirebaseFirestore.instance.collection('users').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Users.fromJson(doc.data() as Map<String, dynamic>))
              .toList(),
        );

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}
