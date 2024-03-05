import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ku_didik/utils/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class RoundedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  RoundedAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _RoundedAppBarState createState() => _RoundedAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _RoundedAppBarState extends State<RoundedAppBar> {
  @override
  Widget build(BuildContext context) {
    // Use Provider to get the profile image URL
    final profileProvider = Provider.of<ProfileProvider>(context);

    String base64Image = profileProvider.profileUrl;

    Uint8List bytes = base64.decode(base64Image.split(',').last);

    final Key imageKey = Key(base64Image);

    final Image avatarImage = Image.memory(bytes, key: imageKey);

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        color: Colors.amber, // Set your desired app bar color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Set the shadow color
            blurRadius: 10.0, // Set the blur radius
            spreadRadius: 5.0, // Set the spread radius
            offset: const Offset(0, 2), // Set the offset
          ),
        ],
      ),
      child: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0, // Remove app bar shadow
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          // ClipOval(
          //   child: Image.memory(
          //     bytes,
          //     width: 55, // Set your desired width
          //     fit: BoxFit.cover,
          //   ),
          // ),
          CircleAvatar(
            backgroundImage: avatarImage.image,
            radius: 20.0, // Set your desired radius
          ),
          const SizedBox(width: 16.0), // Adjust spacing as needed
        ],
      ),
    );
  }
}
