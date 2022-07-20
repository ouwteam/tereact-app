import 'package:firebase_remote_config/firebase_remote_config.dart';

class User {
  User({
    this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.token,
    this.password,
    this.photoProfile = "",
  });

  int? id;
  late final String email;
  late final String name;
  late final String phoneNumber;
  late String photoProfile;
  String? token;
  String? password;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    token = json['token'];
    password = json['password'];
    photoProfile = json['photo_profile'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['token'] = token;
    data['password'] = password;
    data['photo_profile'] = photoProfile;
    return data;
  }

  String getAvatar() {
    if (photoProfile == "") {
      final remoteConfig = FirebaseRemoteConfig.instance;
      return remoteConfig.getString("default_avatar");
    }

    return photoProfile;
  }
}
