import 'User.dart';

class Message {
  final int? id;
  final String content;
  final DateTime date;
  final User sender;
  final User receiver;

  Message({
    this.id,
    required this.content,
    required this.date,
    required this.sender,
    required this.receiver,
  });
}
