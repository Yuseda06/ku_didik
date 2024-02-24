import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
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
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
              height: 330,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 241, 182, 4),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(60.0),
                  ),
                ),
                child: GestureDetector(
                    onTap: () async {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.camera);

                      if (pickedFile != null) {
                        final bytes = await pickedFile.readAsBytes();
                        final base64Image = base64.encode(bytes);
                        profileProvider.setProfileUrl(base64Image);
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: ClipOval(
                            child: Image.memory(
                              bytes,
                              width: 200, // Set your desired width
                              height: 200, // Set your desired height
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    )),
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
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // background
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text('Sign Out', style: TextStyle(color: Colors.white))),
          )
        ],
      ),
    );
  }
}
