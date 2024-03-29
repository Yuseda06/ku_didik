import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:ku_didik/utils/theme/profile_provider.dart';
import 'package:ku_didik/utils/theme/username_provider.dart';

class DidikDrawer extends StatefulWidget {
  @override
  _DidikDrawerState createState() => _DidikDrawerState();
}

class _DidikDrawerState extends State<DidikDrawer> {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final usernameProvider = Provider.of<UsernameProvider>(context);

    String base64Image = profileProvider.profileUrl ?? '';
    String username = usernameProvider.username ?? '';
    Uint8List bytes = base64.decode(base64Image.split(',').last);

    return Drawer(
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8),
              height: 400,
              child: DrawerHeader(
                padding: EdgeInsets.all(35),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 241, 182, 4),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(60.0),
                    bottomLeft: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/pick_image');
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: ClipOval(
                            child: Image.memory(
                              bytes,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Divider(
                          height: 30,
                          thickness: 2,
                        ),
                        Text(
                          username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Learn Vocabulary'),
            onTap: () {
              Navigator.pushNamed(context, '/add_vocab');
            },
          ),
          ListTile(
            title: Text('Test Your Vocabulary'),
            onTap: () {
              // Handle drawer item click
            },
          ),
          Spacer(), // Add Spacer to push "Sign Out" to the bottom
          Container(
            padding: EdgeInsets.all(8),
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                backgroundColor: Colors.amber,
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text('Sign Out',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
