import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  late String _profileUrl = '';

  String get profileUrl => _profileUrl;

  void setProfileUrl(String newProfileUrl) {
    _profileUrl = newProfileUrl;

    // Add code to update Firestore here
    _updateFirestoreProfileUrl(_profileUrl);

    notifyListeners();
  }

  Future<void> _updateFirestoreProfileUrl(String profileUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'profileUrl': profileUrl,
        });
        print('Profile URL updated in Firestore: $profileUrl');
      } catch (error) {
        print('Failed to update profile URL in Firestore: $error');
      }
    }
  }
}
