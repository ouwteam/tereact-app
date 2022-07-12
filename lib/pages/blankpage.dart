import 'dart:convert';
import 'dart:developer';

import 'package:centrifuge/centrifuge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tereact/common/constant.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/pages/home.dart';
import 'package:tereact/pages/login_page.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/providers/user_provider.dart';

class BlankPage extends StatefulWidget {
  const BlankPage({
    Key? key,
    required this.socket,
  }) : super(key: key);

  final Client socket;

  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  @override
  void initState() {
    super.initState();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    TereactProvider tp = Provider.of<TereactProvider>(context, listen: false);
    tp.socket = widget.socket;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SharedPreferences.getInstance().then((prefs) {
        var userData = prefs.getString(spKeyUserData);
        log("userData: $userData");
        if (userData != null) {
          var jsonUser = jsonDecode(userData);
          userProvider.setUserData = User.fromJson(jsonUser);
        }

        FlutterNativeSplash.remove();
        if (userData == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage(),
            ),
          );

          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MyHomePage(
              title: "TEREACT",
              socket: widget.socket,
            ),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
