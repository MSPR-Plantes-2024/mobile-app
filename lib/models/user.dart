import 'package:mobile_app_arosaje/models/use_type.dart';
import 'dart:convert';

List<User> usersFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
String userToJson(User data) => json.encode(data.toJson());

class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? password;
  final UserType userType;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.password,
    required this.userType,
  });
  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, email: $email, password: $password, userType: $userType}';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      password: json["password"],
      userType: UserType.fromJson(json["userType"]),
    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email ,
    "password": password,
    "userType": userType.toJson(),
  };
}
