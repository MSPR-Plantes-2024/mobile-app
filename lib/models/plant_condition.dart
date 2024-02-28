import 'dart:convert';

PlantCondition plantConditionFromJson(String str) => PlantCondition.fromJson(json.decode(str));
String plantConditionToJson(PlantCondition data) => json.encode(data.toJson());

class PlantCondition {
  final int? id;
  final String name;

  PlantCondition({
    this.id,
    required this.name,
  });

  @override
  String toString() {
    return name;
  }

  factory PlantCondition.fromJson(Map<String, dynamic> json) {
    return PlantCondition(
    id: json["id"],
    name: json["name"],
  );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
