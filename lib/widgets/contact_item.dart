import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tereact/entities/contact.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/pages/chat_page.dart';
import 'package:tereact/providers/tereact_provider.dart';
import 'package:tereact/widgets/circle_avatar_with_indicator.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({
    Key? key,
    required this.contact,
  }) : super(key: key);

  final Contact contact;

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
                      Text(contact.alias ?? contact.user.name),
                      const Spacer(),
                      Text(
                        contact.lastInteract != null
                            ? DateFormat.Hm().format(contact.lastInteract!)
                            : DateFormat.Hm().format(contact.updatedAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    contact.snapshot ?? "",
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
        TereactProvider tp =
            Provider.of<TereactProvider>(context, listen: false);
        tp.createRoomPrivate(userId: 1, guestId: contact.guestId).then((room) {
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
              builder: (context) => ChatPage(contact: contact, room: room),
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
