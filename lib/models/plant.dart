import 'dart:convert';

import 'package:mobile_app_arosaje/models/user.dart';

import 'address.dart';
import 'picture.dart';
import 'plant_condition.dart';

List<Plant> plantsFromJson(String str) => List<Plant>.from(json.decode(str).map((x) => Plant.fromJson(x)));
String plantToJson(Plant data) => json.encode(data.toJson());


class Plant {
  final int? id;
  final Address? address;
  final String name;
  final Picture? picture;
  final String? description;
  final User? user;
  final PlantCondition plantCondition;

  Plant({
    this.id,
    this.address,
    required this.name,
    this.picture,
    this.description,
    this.user,
    required this.plantCondition,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      name: json['name'],
      picture: json['picture'] != null ? Picture.fromJson(json['picture']) : null,
      description: json['description'],
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
      plantCondition: PlantCondition.fromJson(json['plantCondition']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "address": address?.toJson(),
      "name": name,
      "picture": picture?.toJson(),
      "description": description,
      "user": user?.toJson(),
      "plantCondition": plantCondition.toJson(),
    };
  }

  @override
  String toString() {
    return 'Plant{id: $id, address: $address, name: $name, picture: $picture, description: $description, user: $user, plantCondition: $plantCondition}';
  }
}
