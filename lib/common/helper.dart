import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tereact/pages/login_page.dart';
import 'package:tereact/providers/user_provider.dart';

class Helper {
  static void authChecker(BuildContext context) {
    var up = Provider.of<UserProvider>(context, listen: false);
    if (up.getUserData != null) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
    );
  }
}
