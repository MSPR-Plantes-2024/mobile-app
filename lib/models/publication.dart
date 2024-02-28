import 'dart:convert';

import 'package:mobile_app_arosaje/models/report.dart';

import 'address.dart';
import 'plant.dart';
import 'user.dart';

List<Publication> publicationsFromJson(String str) => List<Publication>.from(json.decode(str).map((x) {
  return Publication.fromJson(x);
}));
String publicationToJson(Publication data) => json.encode(data.toJson());


class Publication {
  final int? id;
  DateTime date;
  final Address address;
  final User publisher;
  User? gardenkeeper;
  String? description;
  List<Plant> plants;
  List<Report> reports;

  Publication({
    this.id,
    required this.date,
    required this.address,
    required this.publisher,
    this.gardenkeeper,
    this.description,
    this.plants = const [],
    this.reports = const [],
  });

  factory Publication.fromJson(Map<String, dynamic> json) {
    return Publication(
      id: json['id'],
      date: DateTime.parse(json['creationDate']),
      address: Address.fromJson(json['address']),
      publisher: User.fromJson(json['publisher']),
      gardenkeeper: json['gardenKeeper'] != null ? User.fromJson(json['gardenKeeper']) : null,
      description: json['description'],
      plants: json['plants'] != null ? List<Plant>.from(json['plants'].map((x) => Plant.fromJson(x))) : [],
      reports: json['reports'] != null ? List<Report>.from(json['reports'].map((x) => Report.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "creationDate": date.toIso8601String(),
      "address": address.toJson(),
      "publisher": publisher.toJson(),
      "gardenKeeper": gardenkeeper?.toJson(),
      "description": description,
      "plants": plants.map((x) => x.toJson()).toList(),
      "reports": reports.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Publication{id: $id, creationDate: $date, address: $address, publisher: $publisher, gardenKeeper: $gardenkeeper, description: $description, plants: $plants, reports: $reports}';
  }
}
