import 'package:flutter/material.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String avatarUrl;

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
  const RoundedAppBar({Key? key, required this.title, required this.avatarUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.0, // Set elevation to 0 to remove default shadow
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
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
            // Add the avatar icon to the app bar
            CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
            ),

            const SizedBox(width: 16.0), // Adjust spacing as needed
          ],
        ),
      ),
    );
  }
}
