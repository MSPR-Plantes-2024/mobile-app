import 'dart:convert';
import 'dart:developer';

import 'package:mobile_app_arosaje/models/picture.dart';

import 'package:http/http.dart' as http;

import 'constants.dart';

class ApiPictureService {
  static Future<Picture?> createPicture(Picture picture) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.picturesEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
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

  static Future<List<Picture>> getPictures() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.picturesEndpoint);
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
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

  static Future<Picture> getPictureById(int id) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.picturesEndpoint}/$id');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
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
}
