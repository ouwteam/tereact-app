import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tereact/entities/contact.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/widgets/contact_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.socket,
  }) : super(key: key);
  final String title;
  final Socket socket;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Contact> listContacts;
  ScrollController scrollCtrl = ScrollController();
  late TereactProvider tp;
  late Socket socket;

  @override
  void initState() {
    super.initState();
    listContacts = [];
    socket = widget.socket;
    tp = Provider.of<TereactProvider>(context, listen: false);
    tp.getListContacts(userId: 1).then((values) {
      setState(() {
        listContacts.addAll(values);
      });
    }).onError((error, stackTrace) {
      log(error.toString());
    });

    socket.onConnect((_) {
      log('connect');
    });

    socket.onConnectError((d) {
      log(d.toString());
      log('connection failed');
    });

    tp.socket = socket;
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
        ),
        body: RefreshIndicator(
          color: Colors.blue,
          onRefresh: () async {
            tp.getListContacts(userId: 1).then((values) {
              setState(() {
                listContacts = values;
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
                    itemCount: listContacts.length,
                    itemBuilder: (context, i) {
                      Contact contact = listContacts[i];
                      return ContactItem(contact: contact);
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
