// ignore_for_file: use_build_context_synchronously

import 'package:centrifuge/centrifuge.dart';
import 'package:flutter/material.dart';
import 'package:tereact/common/helper.dart';
import 'package:tereact/widgets/discovery.dart';
import 'package:tereact/widgets/obrolan.dart';
import 'package:tereact/widgets/saya.dart';

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
  late Client socket;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    socket = widget.socket;

    _widgetOptions = [
      const PageObrolan(),
      const Text(
        'Kontak',
        style: optionStyle,
      ),
      const DiscoveryPage(),
      const PageSaya(),
    ];
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
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
