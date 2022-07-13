class Room {
  Room({
    required this.id,
    required this.isGroup,
    required this.groupName,
    required this.userId,
    required this.name,
  });
  late final int id;
  late final int isGroup;
  late final String groupName;
  late final int userId;
  late final String name;

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isGroup = json['is_group'];
    groupName = json['group_name'];
    userId = json['user_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['is_group'] = isGroup;
    data['group_name'] = groupName;
    data['user_id'] = userId;
    data['name'] = name;
    return data;
  }
}
