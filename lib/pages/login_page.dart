// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tereact/pages/home.dart';
import 'package:tereact/pages/register_page.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  bool isLoginProcess = false;

  @override
  void initState() {
    super.initState();
    txtUsername.text = "081";
    txtPassword.text = "ihsan123";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.center,
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
            isLoginProcess
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const CircularProgressIndicator(color: Colors.blue),
                  )
                : Container(
                    width: double.infinity,
                    color: Colors.blue,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 50,
                    child: TextButton(
                      onPressed: () async {
                        var up =
                            Provider.of<UserProvider>(context, listen: false);
                        var tp = Provider.of<TereactProvider>(context,
                            listen: false);
                        setState(() => isLoginProcess = true);

                        try {
                          await up.handleLogin(
                            username: txtUsername.text,
                            password: txtPassword.text,
                          );
                        } catch (e) {
                          setState(() => isLoginProcess = false);
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
                      child: const Text("Login"),
                    ),
                  ),
            Row(
              children: [
                const Text("Belum punya akun?"),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  ),
                  child: const Text(
                    "Mendaftar",
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
