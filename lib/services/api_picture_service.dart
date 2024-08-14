import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:mobile_app_arosaje/models/jdk_token.dart';
import 'package:mobile_app_arosaje/models/picture.dart';

import 'package:http/http.dart' as http;

import 'constants.dart' as constants;

class ApiPictureService {
  static Future<Picture?> create(Picture picture) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(constants.BASE_URL + constants.PICTURES_ENDPOINT);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
          },
          body: pictureToJson(picture));
      if (response.statusCode == 200) {
        log('Picture created');
        return Picture.fromJson(json.decode(response.body));
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return null;
  }

  static Future<List<Picture>> getAll() async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(constants.BASE_URL + constants.PICTURES_ENDPOINT);
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
      });
      if (response.statusCode == 200) {
        List<Picture> pictures = picturesFromJson(response.body);
        return pictures;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }

  static Future<Picture> getById(int id) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.PICTURES_ENDPOINT}/$id');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
      });
      if (response.statusCode == 200) {
        Picture picture = Picture.fromJson(json.decode(response.body));
        return picture;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    throw Exception('Failed to load plant');
  }

  static Future<void> delete(Picture picture) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.PICTURES_ENDPOINT}/${picture.id}');
      var response = await http.delete(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
      });
      if (response.statusCode == 200) {
        log('Picture deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }
}
