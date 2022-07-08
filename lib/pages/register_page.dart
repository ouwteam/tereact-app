// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/pages/home.dart';
import 'package:tereact/pages/login_page.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/providers/user_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "TEREACT",
              style: TextStyle(fontSize: 24),
            ),
            const Text(
              "we make sure everyone hear you",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10, top: 60),
              height: 50,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 234, 234, 234),
              ),
              child: TextFormField(
                controller: txtUsername,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Username",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 50,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 234, 234, 234),
              ),
              child: TextFormField(
                controller: txtPassword,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.blue,
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 50,
              child: TextButton(
                onPressed: () async {
                  var up = Provider.of<UserProvider>(context, listen: false);
                  var tp = Provider.of<TereactProvider>(context, listen: false);

                  User? user;
                  try {
                    user = await up.handleLogin(
                      username: txtUsername.text,
                      password: txtPassword.text,
                    );

                    if (user == null) {
                      var snackBar = const SnackBar(
                        content: Text("Login failed"),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                  } catch (e) {
                    var snackBar = SnackBar(
                      content: Text(e.toString()),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage(
                        title: "TEREACT",
                        socket: tp.socket,
                      ),
                    ),
                  );
                },
                child: const Text("Register"),
              ),
            ),
            Row(
              children: [
                const Text("Sudah memiliki akun?"),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
