
import 'dart:convert';

enum AuthorizationType
{
  local,
  google
}

User clientFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String clientToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class User {
  int id;
  AuthorizationType authorizationType;
  String name;
  String email;
  String password;

  User({
    this.id = 0,
    this.authorizationType = AuthorizationType.local,
    required this.name,
    required this.email,
    required this.password,}
  );

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    authorizationType: AuthorizationType.values[json["authorizationType"]]

  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "password": password,
    "authorizationType":authorizationType.index
  };
}