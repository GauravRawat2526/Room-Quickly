import 'package:flutter/foundation.dart';

class UserData extends ChangeNotifier {
  String _userName;
  String _name;
  String _imageUrl;
  String _phoneNumber;

  void setUserData(
      String userName, String name, String imageUrl, String phoneNumber) {
    _userName = userName;
    _name = name;
    _imageUrl = imageUrl;
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  String get userName {
    return _userName;
  }

  String get name {
    return _name;
  }

  String get imageUrl {
    return _imageUrl;
  }

  String get phoneNumber {
    return _phoneNumber;
  }
}
