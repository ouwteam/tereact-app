import 'package:tereact/entities/user.dart';

class RoomUser {
  RoomUser({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });
  late final int id;
  late final int roomId;
  late final int userId;
  late final String createdAt;
  late final String updatedAt;
  late final User? user;

  RoomUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['room_id'];
    userId = json['user_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['room_id'] = roomId;
    data['user_id'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['user'] = user?.toJson();
    return data;
  }
}
