import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ku_didik/common_widgets/didik_app_bar.dart';
import 'package:ku_didik/features/authentication/models/users.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<Users?> _userStream;
  String? profileUrl;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;

    _userStream = readUser(user?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    print('profileUrl: $profileUrl');
    return Scaffold(
      appBar: RoundedAppBar(
        title: 'Home Page',
        avatarUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0k57tiz2Zsqf1lW7hd2tUJSHqFbD56uugug&usqp=CAU',
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: const Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Handle drawer item click
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Handle drawer item click
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: [
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
                child: StreamBuilder<Users?>(
                  stream: _userStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data!.username),
                            subtitle: Text(snapshot.data!.profileUrl),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('User data not found'),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<Users?> readUser(String userId) => FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots()
          .map(
        (snapshot) {
          if (snapshot.exists) {
            profileUrl = snapshot.data()!['profileUrl'];

            return Users.fromJson(snapshot.data() as Map<String, dynamic>);
          } else {
            return null;
          }
        },
      );
}

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}
