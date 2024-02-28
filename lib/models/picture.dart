import 'dart:convert';
import 'dart:developer';

List<Picture> picturesFromJson(String str) => List<Picture>.from(json.decode(str).map((x) => Picture.fromJson(x)));
String pictureToJson(Picture data) => json.encode(data.toJson());


class Picture {
  final int? id;
  final DateTime? date;
  final List<int> data;

  Picture({
    this.id,
    this.date,
    required this.data,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    log(Picture(
      id: json['id'],
      date: DateTime.parse(json['creationDate']),
      data: json['data'],
    ).toString());
    return Picture(
      id: json['id'],
      date: DateTime.parse(json['creationDate']),
      //decode from base64
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data,
    };
  }

  @override
  String toString() {
    return 'Picture{id: $id, date: $date, data: $data}';
  }
}
