import 'package:mobile_app_arosaje/models/Publication.dart';

import 'Picture.dart';

class Report {
  final int? id;
  final DateTime date;
  final Publication publication;
  final List<Picture> pictures;
  final String? text;

  Report({
    this.id,
    required this.date,
    required this.publication,
    this.pictures = const [],
    this.text,
  });
}
