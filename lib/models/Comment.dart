import 'Report.dart';
import 'User.dart';

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
}
