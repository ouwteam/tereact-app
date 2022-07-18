import 'package:flutter/material.dart';
import 'package:tereact/pages/search_user.dart';
import 'package:tereact/widgets/saya.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({Key? key}) : super(key: key);

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Temukan"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchUserPage(),
              ),
            ),
            icon: const Icon(Icons.search_outlined),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: const [
            CandybarItem(
              icon: Icons.featured_play_list_outlined,
              title: "Moment",
            ),
            CandybarItem(
              icon: Icons.qr_code_outlined,
              title: "Pindai",
            ),
            CandybarItem(
              icon: Icons.pin_drop_outlined,
              title: "Orang di sekitar",
            ),
          ],
        ),
      ),
    );
  }
}
