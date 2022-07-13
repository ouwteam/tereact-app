import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tereact/entities/room_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.isMine,
    required this.message,
  }) : super(key: key);

  final bool isMine;
  final RoomMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isMine
              ? const Color.fromARGB(255, 163, 206, 241)
              : const Color.fromARGB(255, 226, 225, 225),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message.value),
            const SizedBox(height: 5),
            Text(
              DateFormat.Hm().format(message.createdAt!),
              style: const TextStyle(fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
