import 'package:tereact/entities/room_message.dart';
import 'package:tereact/entities/room_user.dart';

class Room {
  Room({
    required this.id,
    required this.isGroup,
    required this.groupName,
    required this.roomMember,
    required this.chats,
  });

  late final int id;
  late final int isGroup;
  late final String groupName;
  late final List<RoomUser> roomMember;
  late final List<RoomMessage> chats;

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isGroup = json['is_group'];
    groupName = json['group_name'];

    if (json['room_member'] != null) {
      roomMember = (json['room_member'] as Iterable)
          .map((e) => RoomUser.fromJson(e))
          .toList();
    }

    if (json['chat'] != null) {
      chats = (json['chat'] as Iterable)
          .map((e) => RoomMessage.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['is_group'] = isGroup;
    data['group_name'] = groupName;

    return data;
  }

  RoomMessage? getLastChat() {
    if (chats.isEmpty) {
      return null;
    }

    return chats.first;
  }
}
