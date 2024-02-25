import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart'; // Import from the image package

class ProfileProvider extends ChangeNotifier {
  late String _profileUrl = '';
  String get profileUrl => _profileUrl;

  String? _imageBase64;
  String? get imageBase64 => _imageBase64;

  Future<void> setImage(File? image) async {
    // Convert the image to base64 after resizing
    if (image != null) {
      final resizedImage = await resizeImage(image);
      final imageBytes = resizedImage.readAsBytesSync();
      _imageBase64 = base64Encode(imageBytes);
      notifyListeners();
    }
  }

  Future<File> resizeImage(File image) async {
    // Resize the image to a smaller size using the image package
    final decodedImage = img.decodeImage(await image.readAsBytes());
    final resizedImage =
        img.copyResize(decodedImage!, width: 300); // Adjust width as needed

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/resized_image.jpg');
    await tempFile.writeAsBytes(img.encodeJpg(resizedImage));

    return tempFile;
  }

  void setProfileUrlAndImage() {
    // Ensure that both profile URL and image are available before updating Firestore
    if (_profileUrl.isNotEmpty && _imageBase64 != null) {
      _updateFirestoreProfile();
    }
  }

  void setProfileUrl(String newProfileUrl) {
    _profileUrl = newProfileUrl;

    // Add code to update Firestore here
    setProfileUrlAndImage();
  }

  Future<void> _updateFirestoreProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          // 'profileUrl': _profileUrl,
          'profileUrl': _imageBase64,
        });
        print(
            'Profile updated in Firestore. URL: $_profileUrl, Image Base64: $_imageBase64');
//close the model sheet
      } catch (error) {
        print('Failed to update profile in Firestore: $error');
      }
    }
  }
}
