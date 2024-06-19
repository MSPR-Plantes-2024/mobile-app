import 'dart:convert';

import 'user.dart';

List<Message> messagesFromJson(String str) => List<Message>.from(json.decode(utf8.decode(str.codeUnits)).map((x) => Message.fromJson(x)));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  final int? id;
  final String text;
  final DateTime date;
  final User sender;
  final User receiver;

  Message({
    this.id,
    required this.text,
    required this.date,
    required this.sender,
    required this.receiver,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'],
      date: DateTime.parse(json['publishingDate']),
      sender: User.fromJson(json['sender']),
      receiver: User.fromJson(json['receiver']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "publishingDate": date.toIso8601String(),
      "sender": sender.toJson(),
      "receiver": receiver.toJson(),
    };
  }

  @override
  String toString() {
    return 'Message{id: $id, text: $text, date: $date, sender: $sender, receiver: $receiver}';
  }
}
