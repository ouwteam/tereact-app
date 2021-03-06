import 'package:tereact/entities/user.dart';

class RoomUser {
  RoomUser({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.user,
  });

  late final int id;
  late final int roomId;
  late final int userId;
  late final User user;

  RoomUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['room_id'];
    userId = json['user_id'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['room_id'] = roomId;
    data['user_id'] = userId;
    data['user'] = user.toJson();

    return data;
  }
}
