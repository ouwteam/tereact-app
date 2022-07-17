import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:centrifuge/centrifuge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:tereact/common/helper.dart';
import 'package:tereact/components/chat_bubble.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/entities/room_message.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/providers/user_provider.dart';
import 'package:tereact/widgets/circle_avatar_with_indicator.dart';
import 'package:tereact/widgets/group_sparator.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.room,
  }) : super(key: key);

  final Room room;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GroupedItemScrollController _groupedItemSc =
      GroupedItemScrollController();
  late List<RoomMessage> listMessages;
  late TereactProvider tp;
  late UserProvider up;
  StreamController<List<RoomMessage>> streamMessage =
      StreamController<List<RoomMessage>>();
  final TextEditingController txtMessage = TextEditingController();
  late User user;
  late Subscription chatSubscription;

  Stream<RoomMessage> handleSreamMessage(dynamic data) async* {
    log("masuk pak eko");
    if (data['message'] == null) {
      return;
    }

    RoomMessage roomMessage = RoomMessage.fromJson(data['message']);
    yield roomMessage;
  }

  void handleIncomingMessage(User user) {
    tp.getMessageFromRoom(room: widget.room, user: user).then((values) {
      setState(() {
        listMessages.addAll(values
          ..sort(
            (m1, m2) {
              return m1.createdAt!.compareTo(m2.createdAt!);
            },
          ));

        streamMessage.add(listMessages);
      });
    }).catchError((err) {
      log(err.toString());
    });

    moveToNewMessage();
  }

  void moveToNewMessage() {
    if (_groupedItemSc.isAttached) {
      _groupedItemSc.scrollTo(
        index: (listMessages.length - 1),
        duration: const Duration(microseconds: 500),
      );
    }
  }

  @override
  void dispose() {
    chatSubscription.unsubscribe();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tp = Provider.of<TereactProvider>(context, listen: false);
    up = Provider.of<UserProvider>(context, listen: false);
    listMessages = [];
    user = up.getUserData!;

    handleIncomingMessage(user);
    chatSubscription = tp.socket.getSubscription("room:${widget.room.id}");
    chatSubscription.publishStream
        .map<String>((e) => utf8.decode(e.data))
        .listen((data) {
      final d = json.decode(data) as Map<String, dynamic>;
      if (d['chat'] == null) {
        const snackbar =
            SnackBar(content: Text("Failed to listen to new chat"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);

        return;
      }

      var message = RoomMessage.fromJson(d['chat']);
      setState(() {
        listMessages.add(message);
        streamMessage.add(listMessages);
      });

      moveToNewMessage();
    });

    chatSubscription.subscribe();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Helper.authChecker(context);
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
                children: const [
                  Text(
                    "Undefined Chat",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
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
              stream: streamMessage.stream,
              builder: (context, snapshot) {
                log("${snapshot.hasData}");
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
                          message.createdAt!.year,
                          message.createdAt!.month,
                          message.createdAt!.day,
                        );
                      },
                      groupSeparatorBuilder: (message) =>
                          GroupSparator(message: message),
                      itemBuilder: (context, message) {
                        bool isMine = message.userId == user.id;
                        return ChatBubble(isMine: isMine, message: message);
                      },
                    );
                  }

                  if (mesageItems.isEmpty) {
                    return const Center(
                      child: Text(
                        "Tidak ada pesan",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                }

                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
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
                      controller: txtMessage,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Ketik sesuatu..",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      tp.sendMessageToRoom(
                        user: user,
                        roomId: widget.room.id,
                        strMessage: txtMessage.text,
                      );

                      txtMessage.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
