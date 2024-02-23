import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  String? _profileUrl;

  String? get profileUrl => _profileUrl;

  void setProfileUrl(String? url) {
    _profileUrl = url;
    notifyListeners();
  }
}
