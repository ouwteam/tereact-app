import 'package:tereact/entities/user.dart';

class RoomMessage {
  RoomMessage({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.messageText,
    this.attachments,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
  });
  late final int id;
  late final int roomId;
  late final int userId;
  late final String messageText;
  late final String? attachments;
  late final DateTime createdAt;
  late final DateTime updatedAt;
  User? sender;

  RoomMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['room_id'];
    userId = json['user_id'];
    messageText = json['message_text'];
    attachments = null;
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);

    if (json['sender'] != null) {
      sender = User.fromJson(json['sender']);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['room_id'] = roomId;
    data['user_id'] = userId;
    data['message_text'] = messageText;
    data['attachments'] = attachments;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['sender'] = sender?.toJson();
    return data;
  }
}
