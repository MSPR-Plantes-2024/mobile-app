import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:mobile_app_arosaje/models/address.dart';
import 'package:mobile_app_arosaje/models/jdk_token.dart';

import '../models/plant.dart';
import 'constants.dart' as constants;

import 'package:http/http.dart' as http;

class ApiPlantService {
  static Future<void> create(Plant plant) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(constants.BASE_URL + constants.PLANTS_ENDPOINT);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
          },
          body: plantToJson(plant));
      if (response.statusCode == 200) {
        log('Plant created');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> update(Plant plant) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.PLANTS_ENDPOINT}/${plant.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
          },
          body: plantToJson(plant));
      if (response.statusCode == 200) {
        log('Plant updated');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> delete(Plant plant) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.PLANTS_ENDPOINT}/${plant.id}');
      var response = await http.delete(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
      });
      if (response.statusCode == 200) {
        log('Plant deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<Plant> getById(int id) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.PLANTS_ENDPOINT}/$id');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
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

  static Future<List<Plant>> getByAddress(Address address) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.PLANTS_ENDPOINT}/address/${address.id}');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
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
}
