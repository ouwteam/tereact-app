import 'package:flutter/material.dart';
import 'package:tereact/entities/room.dart';
import 'package:tereact/components/room_item.dart';

class RoomItemCard extends StatelessWidget {
  const RoomItemCard({
    Key? key,
    required this.scrollCtrl,
    required this.listRooms,
  }) : super(key: key);

  final ScrollController scrollCtrl;
  final List<Room> listRooms;

  @override
  Widget build(BuildContext context) {
    if (listRooms.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada data",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      controller: scrollCtrl,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listRooms.length,
      itemBuilder: (context, i) {
        Room contact = listRooms[i];
        return RoomItem(room: contact);
      },
    );
  }
}
