import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/pages/chat_page.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/widgets/circle_avatar_with_indicator.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({
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
                      Text(room.groupName),
                      const Spacer(),
                      const Text(
                        "20:00",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Lorem ipsum dolor sit amet",
                    maxLines: 1,
                    style: TextStyle(
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
        TereactProvider tp =
            Provider.of<TereactProvider>(context, listen: false);
        tp.createRoomPrivate(userId: 1, guestId: room.id).then((room) {
          if (room == null) {
            const snackBar = SnackBar(
              content: Text('Failed to create room'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(room: room),
            ),
          );
        }).onError((error, stackTrace) {
          var snackBar = SnackBar(
            content: Text(error.toString()),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      },
    );
  }
}
