import 'dart:convert';

import 'user.dart';

List<Address> addressesFromJson(String str) => List<Address>.from(json.decode(str).map((x) => Address.fromJson(x)));

String addressToJson(Address data) => json.encode(data.toJson());


class Address {
  final int? id;
  final User? user;
  final String postalAddress;
  final String city;
  final String zipCode;
  final String? otherInformations;

  Address({
    this.id,
    this.user,
    required this.postalAddress,
    required this.city,
    required this.zipCode,
    this.otherInformations,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json["id"],
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
      postalAddress: json["postalAddress"],
      city: json["city"],
      zipCode: json["zipCode"],
      otherInformations: json["otherInfo"],
    );
  }

    Map<String, dynamic> toJson() => {
      "id": id,
      "user": user?.toJson(),
      "postalAddress": postalAddress,
      "city": city,
      "zipCode": zipCode,
      "otherInfo": otherInformations,
    };

  @override
  String toString() {
    return 'Address{id: $id, user: $user, postalAddress: $postalAddress, city: $city, zipCode: $zipCode, otherInformations: $otherInformations}';
  }}
