import 'dart:convert';
List<User> usersFromJson(String str) =>
    List<User>.from(json.decode(utf8.decode(str.codeUnits)).map((x) => User.fromJson(x)));
String userToJson(User data) => json.encode(data.toJson());

class User {
  final int? id;
  final String firstName;
  final String lastName;
  String? email;
  final String? password;
  final String? userType;

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
      userType: json["userType"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "userType": userType,
      };
}
