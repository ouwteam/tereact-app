import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tereact/common/helper.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/providers/user_provider.dart';

class PageSaya extends StatelessWidget {
  const PageSaya({Key? key}) : super(key: key);

  static const imgSrc =
      "https://ptipd.uinjambi.ac.id/wp-content/uploads/2014/03/U-member-4-263x263.jpg";

  @override
  Widget build(BuildContext context) {
    UserProvider up = Provider.of<UserProvider>(context, listen: false);
    User user = up.getUserData!;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 50, left: 25, right: 25),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 90,
              backgroundImage: CachedNetworkImageProvider(imgSrc),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25, bottom: 25),
              child: Text(
                user.name,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const CandybarItem(
              icon: Icons.person,
              title: "Account Detail",
            ),
            const CandybarItem(
              icon: Icons.settings,
              title: "Settings",
            ),
            const CandybarItem(
              icon: Icons.call,
              title: "Contact Us",
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: TextButton(
                  onPressed: () {
                    UserProvider up =
                        Provider.of<UserProvider>(context, listen: false);
                    up.handleLogout().then((_) {
                      Helper.authChecker(context);
                    });

                    var snackBar =
                        const SnackBar(content: Text("Logout berhasil"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.black),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class CandybarItem extends StatelessWidget {
  const CandybarItem({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 20),
          Text(title),
          const Spacer(),
          const Icon(Icons.chevron_right)
        ],
      ),
    );
  }
}
