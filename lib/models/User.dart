import 'package:mobile_app_arosaje/models/UserType.dart';

class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? password;
  final UserType userType;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    required this.userType,
  });

  static User getUser() {
    return User(
        id: 1,
        firstName: "Michel",
        lastName: "Sardou",
        email: "michel.s@random.org",
        userType: UserType.USER);
  }

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, email: $email, password: $password, userType: $userType}';
  }
}
