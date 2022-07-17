import 'package:tereact/entities/user.dart';

class RoomMessage {
  RoomMessage({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.type,
    required this.value,
    required this.status,
    required this.isReply,
    required this.replyChatId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.sender,
  });

  late final int id;
  late final int roomId;
  late final int userId;
  late final int type;
  late final String value;
  late final int status;
  late final int isReply;
  late final int replyChatId;
  late final String content;
  late final DateTime? createdAt;
  late final DateTime? updatedAt;
  late final DateTime? deletedAt;
  late final User sender;

  RoomMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['room_id'];
    userId = json['user_id'];
    type = json['type'];
    value = json['value'];
    status = json['status'];
    isReply = json['is_reply'];
    replyChatId = json['reply_chat_id'];
    content = json['content'];
    createdAt = DateTime.tryParse(json['created_at']);
    updatedAt = DateTime.tryParse(json['updated_at']);
    deletedAt = DateTime.tryParse(json['deleted_at']);

    if (json['user'] != null) {
      sender = User.fromJson(json['user']);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['room_id'] = roomId;
    data['user_id'] = userId;
    data['type'] = type;
    data['value'] = value;
    data['status'] = status;
    data['is_reply'] = isReply;
    data['reply_chat_id'] = replyChatId;
    data['content'] = content;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['user'] = sender.toJson();

    return data;
  }
}
