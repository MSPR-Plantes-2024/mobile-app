import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:mobile_app_arosaje/models/comment.dart';
import 'package:mobile_app_arosaje/models/jdk_token.dart';
import 'package:mobile_app_arosaje/services/constants.dart' as constants;
import 'package:http/http.dart' as http;

class ApiCommentService {
  static Future<void> update(Comment comment) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.COMMENTS_ENDPOINT}/${comment.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
          },
          body: commentToJson(comment));
      if (response.statusCode == 200) {
        log('Comment updated');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> delete(Comment comment) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.COMMENTS_ENDPOINT}/${comment.id}');
      var response = await http.delete(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
      });
      if (response.statusCode == 200) {
        log('Comment deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<Comment> getById(int id) async {
    JdkToken.refreshIfNeeded();
    try {
      var url =
      Uri.parse('${constants.BASE_URL}${constants.COMMENTS_ENDPOINT}/$id');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
      });
      if (response.statusCode == 200) {
        Comment comment = Comment.fromJson(json.decode(response.body));
        return comment;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    throw Exception('Failed to load comment');
  }
}
