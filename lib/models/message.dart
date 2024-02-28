import 'dart:convert';

import 'user.dart';

List<Message> messagesFromJson(String str) => List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

String messageToJson(Message data) => json.encode(data.toJson());


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

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      sender: User.fromJson(json['sender']),
      receiver: User.fromJson(json['receiver']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "content": content,
      "date": date.toIso8601String(),
      "sender": sender.toJson(),
      "receiver": receiver.toJson(),
    };
  }
}
