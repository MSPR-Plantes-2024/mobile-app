import 'Address.dart';
import 'Plant.dart';
import 'User.dart';

class Publication {
  final int? id;
  DateTime date;
  final Address address;
  final User publisher;
  User? gardenkeeper;
  String? description;
  List<Plant> plants;

  Publication({
    this.id,
    required this.date,
    required this.address,
    required this.publisher,
    this.gardenkeeper,
    this.description,
    this.plants = const [],
  });

  static List<Publication> getPublications() {
    return [
      Publication(
        id: 1,
        date: DateTime.now(),
        address: Address.getAddresses()[0],
        publisher: User.getUser(),
        gardenkeeper: null,
        description: "Description 1",
        plants: Plant.getPlants(),
      ),
      Publication(
        id: 2,
        date: DateTime.now(),
        address: Address.getAddresses()[1],
        publisher: User.getUser(),
        gardenkeeper: null,
        description: "Description 2",
        plants: Plant.getPlants(),
      ),
      Publication(
        id: 3,
        date: DateTime.now(),
        address: Address.getAddresses()[2],
        publisher: User.getUser(),
        gardenkeeper: null,
        description: "Description 3",
        plants: Plant.getPlants(),
      ),
      Publication(
        id: 4,
        date: DateTime.now(),
        address: Address.getAddresses()[0],
        publisher: User.getUser(),
        gardenkeeper: null,
        description: "Description 4",
        plants: Plant.getPlants(),
      ),
      Publication(
        id: 5,
        date: DateTime.now(),
        address: Address.getAddresses()[0],
        publisher: User.getUser(),
        plants: Plant.getPlants(),
      )
    ];
  }
}
