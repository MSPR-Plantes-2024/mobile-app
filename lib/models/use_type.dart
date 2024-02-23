import 'dart:convert';

UserType userTypeFromJson(String str) => UserType.fromJson(json.decode(str));

String userTypeToJson(UserType data) => json.encode(data.toJson());


class UserType {
  final int? id;
  final String name;

  UserType({
    this.id,
    required this.name,
  });


  static UserType getUserType() {
    return UserType(
        id: 1,
        name: "casual");
  }
  @override
  String toString() {
    return name;
  }

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}