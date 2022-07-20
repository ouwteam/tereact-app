// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/pages/blankpage.dart';
import 'package:tereact/pages/login_page.dart';
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logos/bar-logo.png",
              width: MediaQuery.of(context).size.width,
              height: 55,
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

                  try {
                    User user = User(
                      email: txtUsername.text,
                      password: txtPassword.text,
                      name: txtUsername.text,
                      phoneNumber: txtUsername.text,
                    );

                    await up.handleRegister(
                      context,
                      user: user,
                    );
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
                      builder: (BuildContext context) => const BlankPage(),
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
