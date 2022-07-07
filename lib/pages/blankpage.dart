import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/pages/home.dart';
import 'package:tereact/providers/user_provider.dart';

class BlankPage extends StatefulWidget {
  const BlankPage({
    Key? key,
    required this.socket,
  }) : super(key: key);

  final Socket socket;

  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  @override
  void initState() {
    super.initState();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SharedPreferences.getInstance().then((prefs) {
        var userData = prefs.getString("user_data");
        if (userData != null) {
          var jsonUser = jsonDecode(userData);
          userProvider.setUserData = User.fromJson(jsonUser);
        }

        if (userData == null) {
          // TODO
          // redirect to login page
        }

        FlutterNativeSplash.remove();
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
