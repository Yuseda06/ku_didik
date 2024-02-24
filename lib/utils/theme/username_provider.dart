import 'package:flutter/material.dart';

class UsernameProvider extends ChangeNotifier {
  late String _username = '';

  String get username => _username;

  void setUsername(String newUsername) {
    _username = newUsername;

    notifyListeners();
  }

  void clearUsername() {
    _username = '';

    notifyListeners();
  }
}
