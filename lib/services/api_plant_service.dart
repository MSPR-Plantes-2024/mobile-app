import 'dart:convert';
import 'dart:developer';

import 'package:mobile_app_arosaje/models/address.dart';

import '../models/plant.dart';
import 'constants.dart';

import 'package:http/http.dart' as http;

class ApiPlantService {
  static Future<void> createPlant(Plant plant) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.plantsEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: plantToJson(plant));
      if (response.statusCode == 200) {
        log('Plant created');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> updatePlant(Plant plant) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.plantsEndpoint}/${plant.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: plantToJson(plant));
      if (response.statusCode == 200) {
        log('Plant updated');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> deletePlant(Plant plant) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.plantsEndpoint}/${plant.id}');
      var response = await http.delete(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        log('Plant deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<Plant> getPlantById(int id) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.plantsEndpoint}/$id');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        Plant plant = Plant.fromJson(json.decode(response.body));
        return plant;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    throw Exception('Failed to load plant');
  }

  static Future<List<Plant>> getPlantsByAddress(Address address) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.plantsEndpoint}/address/${address.id}');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        List<Plant> plants = plantsFromJson(response.body);
        return plants;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }
//#endregion
}
