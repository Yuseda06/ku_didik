import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ku_didik/utils/theme/profile_provider.dart';

class DidikDrawer extends StatefulWidget {
  @override
  _DidikDrawerState createState() => _DidikDrawerState();
}

class _DidikDrawerState extends State<DidikDrawer> {
  late String avatarUrl = '';

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    String base64Image = profileProvider.profileUrl ?? '';
    Uint8List bytes = base64.decode(base64Image.split(',').last);

    // Create a unique key for each user
    final Key imageKey = Key(avatarUrl);

    // Create Image.memory with the bytes and key
    final Image avatarImage = Image.memory(bytes, key: imageKey);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            child: GestureDetector(
              onTap: () async {
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  final bytes = await pickedFile.readAsBytes();
                  final base64Image = base64.encode(bytes);
                  setState(() {
                    avatarUrl = base64Image;
                  });
                  profileProvider.setProfileUrl(base64Image);
                }
              },
              child: CircleAvatar(
                backgroundImage: avatarImage.image,
              ),
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // Handle drawer item click
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              // Handle drawer item click
            },
          ),
        ],
      ),
    );
  }
}
