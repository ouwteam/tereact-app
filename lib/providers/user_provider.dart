import 'package:flutter/material.dart';
import 'package:tereact/entities/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get getUserData => _user;
  set setUserData(User value) {
    _user = value;
    notifyListeners();
  }
}
