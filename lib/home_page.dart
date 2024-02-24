import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ku_didik/common_widgets/didik_app_bar.dart';
import 'package:ku_didik/common_widgets/didik_drawer.dart';
import 'package:ku_didik/features/authentication/models/users.dart';
import 'package:provider/provider.dart';
import 'package:ku_didik/utils/theme/profile_provider.dart';
import 'package:ku_didik/utils/theme/username_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<Users?> _userStream;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;

    _userStream = readUser(user?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final usernameProvider = Provider.of<UsernameProvider>(context);

    return Scaffold(
      appBar: RoundedAppBar(
        title: 'Home Page',
      ),
      drawer: DidikDrawer(),
      body: Stack(
        children: [
          StreamBuilder<Users?>(
            stream: _userStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                profileProvider.setProfileUrl(snapshot.data!.profileUrl);
                usernameProvider.setUsername(snapshot.data!.username);
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                final String base64Image = snapshot.data!.profileUrl;
                Uint8List bytes = base64Decode(base64Image.split(',').last);
                profileProvider.setProfileUrl(snapshot.data!.profileUrl);
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        child: Text('Sign Out'),
                      ),
                    ),
                    Positioned(
                      top: -30,
                      right: 0,
                      height: 50,
                      width: 50,
                      child: ClipOval(
                        child: Image.memory(
                          bytes,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(snapshot.data!.username),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('User data not found'),
                );
              }
            },
          ),
        ],
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
