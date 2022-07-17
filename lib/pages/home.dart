// ignore_for_file: use_build_context_synchronously

import 'package:centrifuge/centrifuge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tereact/common/helper.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/providers/user_provider.dart';
import 'package:tereact/widgets/obrolan.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.socket,
  }) : super(key: key);
  final String title;
  final Client socket;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TereactProvider tp;
  late UserProvider up;
  late Client socket;
  late User user;
  late Subscription subs;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    socket = widget.socket;

    tp = Provider.of<TereactProvider>(context, listen: false);
    up = Provider.of<UserProvider>(context, listen: false);
    user = up.getUserData!;

    _widgetOptions = [
      PageObrolan(user: user),
      const Text(
        'Kontak',
        style: optionStyle,
      ),
      const Text(
        'Temukan',
        style: optionStyle,
      ),
      const Text(
        'Saya',
        style: optionStyle,
      ),
    ];

    final subs = tp.socket.getSubscription("rooms:${user.id}");
    subs.subscribe();
  }

  @override
  void dispose() {
    super.dispose();
    subs.unsubscribe();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Helper.authChecker(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              up.handleLogout().then((_) {
                Helper.authChecker(context);
              });

              var snackBar = const SnackBar(content: Text("Logout berhasil"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            icon: const Icon(Icons.power_outlined),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Obrolan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt),
            label: 'Kontak',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compass_calibration_outlined),
            label: 'Temukan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Saya',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
