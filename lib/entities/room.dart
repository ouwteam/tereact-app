import 'package:tereact/entities/room_user.dart';

class Room {
  Room({
    required this.id,
    required this.title,
    required this.description,
    required this.roomType,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String title;
  late final String description;
  late final String roomType;
  late final String createdAt;
  late final String updatedAt;
  late final List<RoomUser>? participants;

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    roomType = json['room_type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    if (json['participants'] != null) {
      participants = (json['participants'] as Iterable)
          .map((e) => RoomUser.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['room_type'] = roomType;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['participants'] = participants?.map((e) => e.toJson()).toList();
    return data;
  }
}
