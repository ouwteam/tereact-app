class Room {
  Room({
    required this.id,
    required this.isGroup,
    required this.groupName,
  });

  late final int id;
  late final String isGroup;
  late final String groupName;

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isGroup = json['is_group'];
    groupName = json['group_name'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "is_group": isGroup,
      "group_name": groupName,
    };
  }
}
