import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tereact/entities/room_message.dart';

class GroupSparator extends StatelessWidget {
  final RoomMessage message;

  const GroupSparator({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      margin: const EdgeInsets.all(5),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          DateFormat.yMMMd().format(message.createdAt),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
