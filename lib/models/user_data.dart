import 'package:flutter/foundation.dart';

class UserData extends ChangeNotifier {
  String _userName;
  String _name;
  String _imageUrl;
  String _phoneNumber;
  String _email;
  String _upid;

  void setUserData(
      String userName, String name, String imageUrl, String phoneNumber, String email, String upid) {
    _userName = userName;
    _name = name;
    _imageUrl = imageUrl;
    _phoneNumber = phoneNumber;
    _email=email;
    _upid=upid;
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

  String get email {
    return _email;
  }

  String get upid {
    return _upid;
  }
}
