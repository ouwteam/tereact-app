import 'package:tereact/entities/user.dart';

class Contact {
  Contact({
    required this.id,
    required this.userId,
    required this.guestId,
    this.alias,
    this.snapshot,
    this.lastInteract,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  late final int id;
  late final int userId;
  late final int guestId;
  late final String? alias;
  late final String? snapshot;
  late final DateTime? lastInteract;
  late final DateTime createdAt;
  late final DateTime updatedAt;
  late final User user;

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    guestId = json['guest_id'];
    alias = json['alias'];
    snapshot = json['snapshot'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    user = User.fromJson(json['user']);

    if (json['lastInteract'] != null) {
      lastInteract = DateTime.parse(json['lastInteract']);
    } else {
      lastInteract = null;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['guest_id'] = guestId;
    data['alias'] = alias;
    data['snapshot'] = snapshot;
    data['lastInteract'] = lastInteract;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['user'] = user.toJson();
    return data;
  }
}
