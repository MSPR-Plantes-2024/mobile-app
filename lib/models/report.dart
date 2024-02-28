import 'dart:convert';

import 'package:mobile_app_arosaje/models/publication.dart';

import 'picture.dart';

List<Report> reportsFromJson(String str) => List<Report>.from(json.decode(str).map((x) => Report.fromJson(x)));
String reportToJson(Report data) => json.encode(data.toJson());


class Report {
  final int? id;
  final String title;
  final DateTime date;
  final Publication? publication;
  final List<Picture> pictures;
  final String? text;

  Report({
    this.id,
    required this.title,
    required this.date,
    this.publication,
    this.pictures = const [],
    this.text,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['publishingDate']),
      publication: json['publication'] != null ? Publication.fromJson(json['publication']) : null,
      pictures: json['pictures'] != null ? List<Picture>.from(json['pictures'].map((x) => Picture.fromJson(x))) : [],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "publishingDate": date.toIso8601String(),
      "publication": publication?.toJson(),
      "pictures": List<Picture>.from(pictures.map((x) => x.toJson())),
      "text": text,
    };
  }

  @override
  String toString() {
    return 'Report{id: $id, title: $title, date: $date, publication: $publication, pictures: $pictures, text: $text}';
  }
}
