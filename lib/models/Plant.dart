import 'Address.dart';
import 'Picture.dart';
import 'PlantCondition.dart';

class Plant {
  final int? id;
  final Address address;
  final String name;
  final Picture? picture;
  final String? description;
  final PlantCondition plantCondition;

  Plant({
    this.id,
    required this.address,
    required this.name,
    this.picture,
    this.description,
    required this.plantCondition,
  });

  static List<Plant> getPlants() {
    return [
      Plant(
        id: 1,
        address: Address.getAddresses()[1],
        name: "Plante 1",
        picture: Picture.getPictures()[0],
        description: "Description 1",
        plantCondition: PlantCondition.HEALTHY,
      ),
      Plant(
        id: 2,
        address: Address.getAddresses()[1],
        name: "Plante 2",
        picture: Picture.getPictures()[1],
        description: "Description 2",
        plantCondition: PlantCondition.DAMAGED,
      ),
      Plant(
        id: 3,
        address: Address.getAddresses()[1],
        name: "Plante 3",
        picture: Picture.getPictures()[2],
        description: "Description 3",
        plantCondition: PlantCondition.HEALTHY,
      ),
      Plant(
        id: 4,
        address: Address.getAddresses()[1],
        name: "Plante 4",
        picture: Picture.getPictures()[3],
        description: "Description 4",
        plantCondition: PlantCondition.HEALTHY,
      ),
      Plant(
        id: 5,
        address: Address.getAddresses()[1],
        name: "Plante 5",
        picture: Picture.getPictures()[4],
        description: "Description 5",
        plantCondition: PlantCondition.HEALTHY,
      ),
    ];
  }
}
