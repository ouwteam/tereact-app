import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:centrifuge/centrifuge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tereact/components/room_item_card.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/providers/user_provider.dart';

class PageObrolan extends StatefulWidget {
  const PageObrolan({
    Key? key,
  }) : super(key: key);

  @override
  State<PageObrolan> createState() => _PageObrolanState();
}

class _PageObrolanState extends State<PageObrolan> {
  late TereactProvider tp;
  late UserProvider up;
  late User user;
  late List<Room> listRooms;
  late Subscription subs;
  late StreamSubscription<String> roomsListener;
  final txtSearch = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();

  int page = 1;
  Timer? searchOnStoppedTyping;

  @override
  void initState() {
    super.initState();
    listRooms = [];
    tp = Provider.of<TereactProvider>(context, listen: false);
    up = Provider.of<UserProvider>(context, listen: false);
    user = up.getUserData!;

    subs = tp.socket.getSubscription("rooms:${user.id}");
    roomsListener = subs.publishStream
        .map<String>((e) => utf8.decode(e.data))
        .listen((event) {
      tp
          .getRooms(
        context,
        user: user,
        page: page,
        search: txtSearch.text,
      )
          .then((values) {
        setState(() {
          listRooms = values;
        });
      }).onError((error, stackTrace) {
        log(error.toString());
      });
    });

    subs.subscribe();
  }

  @override
  void dispose() {
    roomsListener.cancel();
    subs.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notif) {
        if (notif.metrics.atEdge && notif.metrics.pixels > 0) {
          setState(() {
            page = page + 1;
          });
        }

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: () {},
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          elevation: 0,
          title: const Text("TEREACT"),
        ),
        body: RefreshIndicator(
          color: Colors.blue,
          onRefresh: () async {
            tp
                .getRooms(
              context,
              user: user,
              page: page,
              search: txtSearch.text,
            )
                .then((values) {
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
                          onChanged: _onChangeHandler,
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
                  child: FutureBuilder(
                    future: tp.getRooms(
                      context,
                      user: user,
                      page: page,
                      search: txtSearch.text,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        listRooms = snapshot.data as List<Room>;
                        return RoomItemCard(
                          scrollCtrl: scrollCtrl,
                          listRooms: listRooms,
                        );
                      }

                      return const Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ),
                      );
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

  _onChangeHandler(String txtSrch) {
    const duration = Duration(milliseconds: 800);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }

    setState(
      () => searchOnStoppedTyping = Timer(duration, () {
        tp
            .getRooms(
          context,
          user: user,
          page: page,
          search: txtSearch.text,
        )
            .then((values) {
          setState(() {
            listRooms = values;
          });
        }).onError((error, stackTrace) {
          log(error.toString());
        });
      }),
    );
  }
}
