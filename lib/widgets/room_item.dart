import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/pages/chat_page.dart';
import 'package:tereact/widgets/circle_avatar_with_indicator.dart';

class RoomItem extends StatelessWidget {
  const RoomItem({
    Key? key,
    required this.room,
  }) : super(key: key);

  final Room room;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CirleAvatarWithIndicator(
              isOnline: true,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.79,
              padding: const EdgeInsets.only(left: 8, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("Undefined Chat"),
                      const Spacer(),
                      Text(
                        room.getLastChat() != null
                            ? DateFormat.Hm()
                                .format(room.getLastChat()!.createdAt!)
                            : "",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    room.getLastChat() != null ? room.getLastChat()!.value : "",
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(room: room),
          ),
        );
      },
    );
  }
}
