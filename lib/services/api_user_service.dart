import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/user.dart';
import 'constants.dart';

class ApiUserService {
  static Future<void> updateUser(User user) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/${user.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: userToJson(user));
      if (response.statusCode == 200) {
        MyApp.currentUser = user;
        log('User updated');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> deleteUser(User user) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/${user.id}');
      var response = await http.delete(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        log('User deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<User> getUser(int id) async {
    try {
      var url =
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/$id');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
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
