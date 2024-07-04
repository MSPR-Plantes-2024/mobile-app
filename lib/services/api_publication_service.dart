import 'dart:convert';
import 'dart:developer';

import 'package:mobile_app_arosaje/models/user.dart';

import '../models/publication.dart';
import 'constants.dart';

import 'package:http/http.dart' as http;

class ApiPublicationService {
  static Future<void> createPublication(Publication publication) async {
    try {
      var url =
      Uri.parse(ApiConstants.baseUrl + ApiConstants.publicationsEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: publicationToJson(publication));
      if (response.statusCode == 200) {
        log('Publication created');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> updatePublication(Publication publication) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.publicationsEndpoint}/${publication.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: publicationToJson(publication));
      if (response.statusCode == 200) {
        log('Publication updated');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> deletePublication(Publication publication) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.publicationsEndpoint}/${publication.id}');
      var response = await http.delete(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        log('Publication deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<List<Publication>> getPublications() async {
    try {
      var url =
      Uri.parse(ApiConstants.baseUrl + ApiConstants.publicationsEndpoint);
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        List<Publication> publications = publicationsFromJson(response.body);
        return publications;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }

  static Future<Publication> getPublicationById(int id) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.publicationsEndpoint}/$id');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        Publication publication =
        Publication.fromJson(json.decode(response.body));
        return publication;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    throw Exception('Failed to load publication');
  }

  static Future<List<Publication>> getPublicationsByUser(User user) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.publicationsEndpoint}/user/${user.id}');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        List<Publication> publications = publicationsFromJson(response.body);
        return publications;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }
}
