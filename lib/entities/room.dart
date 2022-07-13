class Room {
  Room({
    required this.id,
    required this.isGroup,
    required this.groupName,
    required this.userId,
    required this.name,
    required this.value,
    required this.senderName,
    required this.timeSent,
  });
  late final int id;
  late final int isGroup;
  late final String groupName;
  late final int userId;
  late final String name;
  late final String value;
  late final String senderName;
  late final DateTime? timeSent;

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isGroup = json['is_group'];
    groupName = json['group_name'];
    userId = json['user_id'];
    name = json['name'];
    value = json['value'];
    senderName = json['sender_name'];
    timeSent = DateTime.tryParse(json['time_sent']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['is_group'] = isGroup;
    data['group_name'] = groupName;
    data['user_id'] = userId;
    data['name'] = name;
    data['value'] = value;
    data['sender_name'] = senderName;
    data['time_sent'] = timeSent;
    return data;
  }
}
