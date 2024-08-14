import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:mobile_app_arosaje/models/jdk_token.dart';
import 'package:mobile_app_arosaje/models/message.dart';
import 'package:mobile_app_arosaje/models/user.dart';
import 'package:http/http.dart' as http;
import 'constants.dart' as constants;

class ApiMessageService {
  static Future<List<List<Message>>> getByUser(User user) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.MESSAGES_ENDPOINT}/user/${user.id}');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
      });
      if (response.statusCode == 200) {
        List<List<Message>> messages = messagesFromJson( response.body);
        return messages;
      }
    } catch (e, s) {
        log('Exception: $e\nStack trace: $s');
    }
    return [];
  }

  static Future<void> create(Message message) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(constants.BASE_URL + constants.MESSAGES_ENDPOINT);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
          },
          body: messageToJson(message));
      if (response.statusCode == 201) {
        log('Message created');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> update(Message message) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.MESSAGES_ENDPOINT}/${message.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
          },
          body: messageToJson(message));
      if (response.statusCode == 200) {
        log('Message updated');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> delete(Message message) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.MESSAGES_ENDPOINT}/${message.id}');
      var response = await http.delete(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
      });
      if (response.statusCode == 200) {
        log('Message deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }
}
