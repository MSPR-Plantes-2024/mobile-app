import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:mobile_app_arosaje/models/jdk_token.dart';
import 'package:mobile_app_arosaje/models/plant_condition.dart';

import 'package:http/http.dart' as http;
import 'constants.dart' as constants;

class ApiPlantConditionService {
  static Future<List<PlantCondition>> getAll() async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(constants.BASE_URL + constants.PLANT_CONDITIONS_ENDPOINT);
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
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
