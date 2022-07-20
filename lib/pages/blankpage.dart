import 'dart:convert';
import 'dart:developer';

import 'package:centrifuge/centrifuge.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tereact/common/constant.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/pages/home.dart';
import 'package:tereact/pages/login_page.dart';
import 'package:tereact/providers/api_provider.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/providers/user_provider.dart';

class BlankPage extends StatefulWidget {
  const BlankPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  Future<void> handleAsyncProcess({
    required UserProvider userProvider,
    required ApiProvider apiProvider,
    required Function(User? user, Client socket) callback,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString(spKeyUserData);
    log("userData: $userData");
    if (userData != null) {
      var jsonUser = jsonDecode(userData);
      userProvider.setUserData = User.fromJson(jsonUser);
    }

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 24),
    ));
    await remoteConfig.fetchAndActivate();

    final wsBaseUrl = remoteConfig.getString("ws_base_url");
    final baseUrl = remoteConfig.getString("base_api");
    final socket = createClient(wsBaseUrl);
    apiProvider.baseUrl = baseUrl;

    FlutterNativeSplash.remove();
    callback.call(
      userProvider.getUserData,
      socket,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      TereactProvider tp = Provider.of<TereactProvider>(context, listen: false);
      ApiProvider api = Provider.of<ApiProvider>(context, listen: false);

      handleAsyncProcess(
          apiProvider: api,
          userProvider: userProvider,
          callback: (userData, socket) {
            tp.socket = socket;

            if (userData == null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage(),
                ),
              );

              return;
            }

            final User user = userProvider.getUserData!;
            log("user.token: ${user.token}");
            tp.socket.setToken(user.token!);

            tp.socket.connectStream.listen((event) {
              log("socket.connectStream:");
              log(event.toString());
            });

            tp.socket.disconnectStream.listen((event) {
              log("socket.disconnectStream:");
              log(event.toString());
            });

            tp.socket.connect();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(
                  title: "TEREACT",
                  socket: tp.socket,
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
