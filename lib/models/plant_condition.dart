class PlantCondition {
  final String value;
  const PlantCondition._(this.value);

  static const PlantCondition HEALTHY = PlantCondition._("HEALTHY");
  static const PlantCondition DAMAGED = PlantCondition._("DAMAGED");
  static const PlantCondition DEAD = PlantCondition._("DEAD");

  static List<PlantCondition> get values => [HEALTHY, DAMAGED, DEAD];

  @override
  String toString() {
    return value;
  }
}
