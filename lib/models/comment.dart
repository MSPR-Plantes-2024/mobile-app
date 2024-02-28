import 'dart:convert';

import 'report.dart';
import 'user.dart';

List<Comment> commentsFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(Comment data) => json.encode(data.toJson());


class Comment {
  final int? id;
  final String content;
  final DateTime date;
  final User author;
  final Report report;

  Comment({
    this.id,
    required this.content,
    required this.date,
    required this.author,
    required this.report,
  });


  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      author: User.fromJson(json['author']),
      report: Report.fromJson(json['report']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "content": content,
      "date": date.toIso8601String(),
      "author": author.toJson(),
      "report": report.toJson(),
    };
  }
}
