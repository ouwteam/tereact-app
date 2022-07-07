import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:tereact/entities/contact.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/entities/room_message.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/widgets/circle_avatar_with_indicator.dart';
import 'package:tereact/widgets/group_sparator.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.contact,
    required this.room,
  }) : super(key: key);

  final Contact contact;
  final Room room;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GroupedItemScrollController _groupedItemSc =
      GroupedItemScrollController();
  late List<RoomMessage> listMessages;
  late TereactProvider tp;
  StreamController<List<RoomMessage>> streamMessage =
      StreamController<List<RoomMessage>>();

  Stream<RoomMessage> handleSreamMessage(dynamic data) async* {
    log("masuk pak eko");
    if (data['message'] == null) {
      return;
    }

    RoomMessage roomMessage = RoomMessage.fromJson(data['message']);
    yield roomMessage;
  }

  void handleIncomingMessage(dynamic data) {
    log("Incoming message.. ");
    if (data['message'] == null) {
      return;
    }

    var roomMessage = RoomMessage.fromJson(data['message']);
    listMessages.add(roomMessage);
    streamMessage.add(listMessages);

    if (_groupedItemSc.isAttached) {
      _groupedItemSc.scrollTo(
        index: (listMessages.length - 1),
        duration: const Duration(microseconds: 500),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    tp.socket.off("subscribe_room");
  }

  @override
  void initState() {
    super.initState();
    tp = Provider.of<TereactProvider>(context, listen: false);
    listMessages = [];

    tp.getListMessages(roomId: widget.room.id, userId: 1).then((values) {
      setState(() {
        listMessages.addAll(values
          ..sort(
            (m1, m2) {
              return m1.createdAt.compareTo(m2.createdAt);
            },
          ));
      });
    }).catchError((err) {
      log(err.toString());
    });

    Map<String, dynamic> payload = {"room_id": widget.room.id};
    tp.socket.emit("subscribe_room", payload);
    tp.socket.on("message", handleIncomingMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CirleAvatarWithIndicator(isOnline: true, size: "M"),
            Container(
              margin: const EdgeInsets.only(left: 10, top: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contact.alias ?? widget.contact.user.username,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Online",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 70),
            child: StreamBuilder(
              initialData: listMessages,
              stream: streamMessage.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error loading message");
                }

                if (snapshot.hasData) {
                  var mesageItems = snapshot.data as List<RoomMessage>;
                  if (mesageItems.isNotEmpty) {
                    log("mesageItems: ${mesageItems.length}");

                    return StickyGroupedListView<RoomMessage, DateTime>(
                      addAutomaticKeepAlives: true,
                      floatingHeader: true,
                      shrinkWrap: true,
                      itemScrollController: _groupedItemSc,
                      elements: mesageItems,
                      groupBy: (message) {
                        return DateTime(
                          message.createdAt.year,
                          message.createdAt.month,
                          message.createdAt.day,
                        );
                      },
                      groupSeparatorBuilder: (message) =>
                          GroupSparator(message: message),
                      itemBuilder: (context, message) {
                        bool isMine = message.userId == 1;
                        return Align(
                          alignment:
                              isMine ? Alignment.topRight : Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isMine
                                  ? const Color.fromARGB(255, 163, 206, 241)
                                  : const Color.fromARGB(255, 226, 225, 225),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: isMine
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(message.messageText),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat.Hm().format(message.createdAt),
                                  style: const TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (mesageItems.isEmpty) {
                    return const Text("Loading..");
                  }
                }

                return const Text("Loading");
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Ketik sesuatu..",
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
