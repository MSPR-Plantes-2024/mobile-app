import 'dart:convert';
import 'dart:developer';

import 'package:mobile_app_arosaje/models/message.dart';
import 'package:mobile_app_arosaje/models/user.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';

class ApiMessageService {
  static Future<List<Message>> getMessageByUser(User user) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.messagesEndpoint}/user/${user.id}');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        List<Message> messages = messagesFromJson( response.body);
        return messages;
      }
    } catch (e, s) {
        log('Exception: $e\nStack trace: $s');
    }
    return [];
  }

  static Future<void> createMessage(Message message) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.messagesEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: messageToJson(message));
      if (response.statusCode == 201) {
        log('Message created');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> updateMessage(Message message) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.messagesEndpoint}/${message.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: messageToJson(message));
      if (response.statusCode == 200) {
        log('Message updated');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> deleteMessage(Message message) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.messagesEndpoint}/${message.id}');
      var response = await http.delete(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        log('Message deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }
}
