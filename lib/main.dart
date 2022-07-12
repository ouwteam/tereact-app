import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tereact/common/constant.dart';
import 'package:tereact/pages/blankpage.dart';
import 'package:provider/provider.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/providers/user_provider.dart';
import 'package:centrifuge/centrifuge.dart';

void main() {
  final socket = createClient(wsBaseUrl);

  socket.connect().then((_) {
    log("connected");
  }).onError((error, stackTrace) {
    log(error.toString());
  });

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(MyApp(socket: socket));
}

class MyApp extends StatelessWidget {
  final Client socket;

  const MyApp({
    Key? key,
    required this.socket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TereactProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        title: 'Tereact',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.white,
            onPrimary: Colors.black,
          ),
        ),
        home: BlankPage(socket: socket),
      ),
    );
  }
}
