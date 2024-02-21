class UserType {
  final String value;
  const UserType._(this.value);

  static const UserType SPECIALIST = UserType._("SPECIALIST");
  static const UserType USER = UserType._("USER");

  static List<UserType> get values => [SPECIALIST, USER];

  @override
  String toString() {
    return value;
  }
}