import 'dart:developer';

import 'package:mobile_app_arosaje/models/plant_condition.dart';

import 'package:http/http.dart' as http;
import 'constants.dart';

class ApiPlantConditionService {
  static Future<List<PlantCondition>> getPlantConditions() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.plantConditionsEndpoint);
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        List<PlantCondition> plantConditions = plantConditionsFromJson(response.body);
        return plantConditions;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }
}
