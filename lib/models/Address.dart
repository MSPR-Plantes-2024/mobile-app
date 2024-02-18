class Address {
  final int? id;
  final int userId;
  final String postalAddress;
  final String city;
  final String zipCode;
  final String? otherInformations;

  Address({
    this.id,
    required this.userId,
    required this.postalAddress,
    required this.city,
    required this.zipCode,
    this.otherInformations,
  });
  static List<Address> getAddresses() {
    return [
      Address(
        id: 1,
        userId: 1,
        postalAddress: "Adresse 1",
        city: "City 1",
        zipCode: "ZipCode 1",
        otherInformations: "Other informations 1",
      ),
      Address(
        id: 2,
        userId: 1,
        postalAddress: "Adresse 2",
        city: "City 2",
        zipCode: "ZipCode 2",
        otherInformations: "Other informations 2",
      ),
      Address(
        id: 3,
        userId: 3,
        postalAddress: "Adresse 3",
        city: "City 3",
        zipCode: "ZipCode 3",
        otherInformations: "Other informations 3",
      ),
    ];
  }
}
