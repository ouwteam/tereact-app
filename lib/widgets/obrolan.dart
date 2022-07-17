import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tereact/components/room_item_card.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/providers/tereact_provider.dart';

class PageObrolan extends StatefulWidget {
  const PageObrolan({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<PageObrolan> createState() => _PageObrolanState();
}

class _PageObrolanState extends State<PageObrolan> {
  late TereactProvider tp;
  late User user;
  late List<Room> listRooms;
  final txtSearch = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();

  int page = 1;
  String search = "";

  @override
  void initState() {
    super.initState();
    listRooms = [];
    tp = Provider.of<TereactProvider>(context, listen: false);
    user = widget.user;
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
      child: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          tp.getRooms(user: user, page: page, search: search).then((values) {
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
                        onChanged: (value) => search = txtSearch.text,
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
                    user: user,
                    page: page,
                    search: search,
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
    );
  }
}
