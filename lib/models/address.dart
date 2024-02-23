import 'dart:convert';

import 'user.dart';

List<Address> addressesFromJson(String str) => List<Address>.from(json.decode(str).map((x) => Address.fromJson(x)));

String addressToJson(Address data) => json.encode(data.toJson());


class Address {
  final int? id;
  final User user;
  final String postalAddress;
  final String city;
  final String zipCode;
  final String? otherInformations;

  Address({
    this.id,
    required this.user,
    required this.postalAddress,
    required this.city,
    required this.zipCode,
    this.otherInformations,
  });
  static List<Address> getAddresses() {
    return [
      Address(
        id: 1,
        user: User.getUser(),
        postalAddress: "Adresse 1",
        city: "City 1",
        zipCode: "ZipCode 1",
        otherInformations: "Other informations 1"
      ),
      Address(
        id: 2,
        user: User.getUser(),
        postalAddress: "Adresse 2",
        city: "City 2",
        zipCode: "ZipCode 2",
        otherInformations: "Other informations 2",
      ),
      Address(
        id: 3,
        user: User.getUser(),
        postalAddress: "Adresse 3",
        city: "City 3",
        zipCode: "ZipCode 3",
        otherInformations: "Other informations 3",
      ),
    ];
  }
  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    user: User.fromJson(json["user"]),
    postalAddress: json["postalAddress"],
    city: json["city"],
    zipCode: json["zipCode"],
    otherInformations: json["otherInfo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user.toJson(),
    "postalAddress": postalAddress,
    "city": city,
    "zipCode": zipCode,
    "otherInfo": otherInformations,
  };
}
