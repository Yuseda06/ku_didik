import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ku_didik/utils/theme/profile_provider.dart';
import 'package:provider/provider.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  RoundedAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    // Use Provider to get the profile image URL
    final profileProvider = Provider.of<ProfileProvider>(context);
    String base64Image = profileProvider.profileUrl ?? '';

    // Convert base64 image to bytes
    Uint8List bytes = base64.decode(base64Image.split(',').last);

    // Create a unique key for each user
    final Key imageKey = Key(base64Image);

    // Create Image.memory with the bytes and key
    final Image avatarImage = Image.memory(bytes, key: imageKey);

    return Container(
      height: 300,
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
        backgroundColor: Colors.transparent,
        elevation: 0.0, // Remove app bar shadow
        title: Text(title),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundImage: avatarImage.image,
          ),
          const SizedBox(width: 16.0), // Adjust spacing as needed
        ],
      ),
    );
  }
}
