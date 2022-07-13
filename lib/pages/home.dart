// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:centrifuge/centrifuge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tereact/common/helper.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/providers/user_provider.dart';
import 'package:tereact/widgets/room_item.dart';

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
  late List<Room> listRooms;
  ScrollController scrollCtrl = ScrollController();
  late TereactProvider tp;
  late UserProvider up;
  late Client socket;
  final txtSearch = TextEditingController();
  late User user;
  late Subscription subs;

  @override
  void initState() {
    super.initState();
    listRooms = [];
    socket = widget.socket;

    tp = Provider.of<TereactProvider>(context, listen: false);
    up = Provider.of<UserProvider>(context, listen: false);
    user = up.getUserData!;

    tp.getRooms(user: user).then((values) {
      setState(() {
        listRooms.addAll(values);
      });
    }).onError((error, stackTrace) {
      log(error.toString());
    });

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
    return NotificationListener<ScrollNotification>(
      onNotification: (notif) {
        if (notif.metrics.atEdge && notif.metrics.pixels > 0) {
          log("loadmore..");
        }

        return true;
      },
      child: Scaffold(
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
        body: RefreshIndicator(
          color: Colors.blue,
          onRefresh: () async {
            tp.getRooms(user: user).then((values) {
              setState(() {
                listRooms = values;
              });
            }).onError((error, stackTrace) {
              log(error.toString());
            });
            return;
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 245, 245, 245),
                  ),
                  width: double.infinity,
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.search, color: Colors.grey),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: txtSearch,
                          cursorColor: Colors.grey,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.grey,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            hintText: "Cari kontak atau percakapan",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(12),
                  child: ListView.builder(
                    controller: scrollCtrl,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listRooms.length,
                    itemBuilder: (context, i) {
                      Room contact = listRooms[i];
                      return RoomItem(room: contact);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
