class User {
  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.token,
    this.password,
  });
  late final int id;
  late final String email;
  late final String name;
  late final String phoneNumber;
  String? token;
  String? password;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    token = json['token'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['token'] = token;
    data['password'] = password;
    return data;
  }
}
