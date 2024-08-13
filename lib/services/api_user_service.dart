import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/user.dart';
import 'constants.dart' as constants;

class ApiUserService {
  static Future<void> update(User user) async {
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.USERS_ENDPOINT}/${user.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${GetStorage().read('jdkToken')}'
          },
          body: userToJson(user));
      if (response.statusCode == 200) {
        User.setCurrent(user);
        log('User updated');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> delete(User user) async {
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.USERS_ENDPOINT}/${user.id}');
      var response = await http.delete(url, headers: <String, String>{
        'Authorization': 'Bearer ${GetStorage().read('jdkToken')}'
      });
      if (response.statusCode == 200) {
        log('User deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<User> getById(int id) async {
    try {
      var url =
      Uri.parse('${constants.BASE_URL}${constants.USERS_ENDPOINT}/$id');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${GetStorage().read('jdkToken')}'
      });
      if (response.statusCode == 200) {
        User user = User.fromJson(json.decode(response.body));
        return user;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    throw Exception('Failed to load user');
  }
}
