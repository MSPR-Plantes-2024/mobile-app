import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/user.dart';
import 'constants.dart' as constants;

class ApiAuthService {
  static Future<bool> login(String email, String password) async {
    try {
      var url = Uri.parse('${constants.BASE_URL}/auth/authenticate');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({'email': email, 'password': password}));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        GetStorage().write('jdkToken', jsonDecode(response.body)['access_token']);
        User userToLogon = User.fromJson(jsonDecode(response.body)['user']);
        userToLogon.email = email;
        User.setCurrent(userToLogon);
        return true;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return false;
  }

  static Future<bool> logon(User user) async {
    try {
      var url = Uri.parse('${constants.BASE_URL}/auth/register');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: userToJson(user));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        GetStorage().write('jdkToken', jsonDecode(response.body)['access_token']);
        User userToLogon = User.fromJson(jsonDecode(response.body)['user']);
        userToLogon.email = user.email;
        User.setCurrent(userToLogon);
        return true;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return false;
  }
}
