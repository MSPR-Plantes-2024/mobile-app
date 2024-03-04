import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile_app_arosaje/main.dart';

import '../models/address.dart';
import '../models/message.dart';
import '../models/picture.dart';
import '../models/plant.dart';
import '../models/publication.dart';
import '../models/report.dart';
import '../models/user.dart';
import 'constants.dart';

class ApiService {
  //#region Auth
  static Future<void> login(String email, String password) async {
    try {
      var url = Uri.parse('${ApiConstants.baseUrl}/auth/authenticate');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({'email': email, 'password': password}));
      if (response.statusCode == 200) {
        ApiConstants.jdkToken =
            JwtDecoder.decode(jsonDecode(response.body)['access_token']);
        MyApp.currentUser = User.fromJson(jsonDecode(response.body)['user']);
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }
  static Future<void> logon(User user) async {
    try {
      var url = Uri.parse('${ApiConstants.baseUrl}/auth/register');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: userToJson(user));
      if (response.statusCode == 200) {
        ApiConstants.jdkToken =
            JwtDecoder.decode(jsonDecode(response.body)['access_token']);
        MyApp.currentUser = User.fromJson(jsonDecode(response.body)['user']);
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }
  //#endregion

  //#region User
  static Future<void> createUser(User user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: userToJson(user));
      if (response.statusCode == 200) {
        log('User created');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

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
      var response = await http.delete(url,
          headers: <String, String>{
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'});
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
      var response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'});
      if (response.statusCode == 200) {
        User user = User.fromJson(json.decode(response.body));
        return user;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    throw Exception('Failed to load user');
  }

  //#endregion

  //#region Address
  static Future<Address> getAddressById(int id) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.addressesEndpoint}/$id');
      var response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'});
      if (response.statusCode == 200) {
        Address address = Address.fromJson(json.decode(response.body));
        return address;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    throw Exception('Failed to load address');
  }

  static Future<List<Address>> getAddresses() async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.addressesEndpoint);
      var response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'});
      if (response.statusCode == 200) {
        List<Address> addresses = addressesFromJson(response.body);
        return addresses;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }

  static Future<List<Address>> getAddressesByUser(User user) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.addressesEndpoint}/user/${user.id}');
      var response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'});
      if (response.statusCode == 200) {
        List<Address> addresses = addressesFromJson(response.body);
        return addresses;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }

  static Future<void> createAddress(Address address) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.addressesEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: addressToJson(address));
      if (response.statusCode == 200) {
        log('Address created');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> updateAddress(Address address) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.addressesEndpoint}/${address.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: addressToJson(address));
      if (response.statusCode == 200) {
        log('Address updated');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> deleteAddress(Address address) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.addressesEndpoint}/${address.id}');
      var response = await http.delete(url,
          headers: <String, String>{
          'Authorization': 'Bearer ${ApiConstants.jdkToken}'});
      if (response.statusCode == 200) {
        log('Address deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }
  //#endregion

  //#region Picture
  static Future<void> createPicture(Picture picture) async {
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
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<List<Picture>> getPictures() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.picturesEndpoint);
      var response = await http.get(url,
          headers: <String, String>{
          'Authorization': 'Bearer ${ApiConstants.jdkToken}'});
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
      var response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'});
      if (response.statusCode == 200) {
        Picture picture = Picture.fromJson(json.decode(response.body));
        return picture;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    throw Exception('Failed to load plant');
  }
  //#endregion

  //#region Plant
  static Future<void> createPlant(Plant plant) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.plantsEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: plantToJson(plant));
      if (response.statusCode == 200) {
        log('Plant created');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> updatePlant(Plant plant) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.plantsEndpoint}/${plant.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: plantToJson(plant));
      if (response.statusCode == 200) {
        log('Plant updated');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> deletePlant(Plant plant) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.plantsEndpoint}/${plant.id}');
      var response = await http.delete(url,
          headers: <String, String>{
          'Authorization': 'Bearer ${ApiConstants.jdkToken}'});
      if (response.statusCode == 200) {
        log('Plant deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<Plant> getPlantById(int id) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.plantsEndpoint}/$id');
      var response = await http.get(url,
          headers: <String, String>{
          'Authorization': 'Bearer ${ApiConstants.jdkToken}'});
      if (response.statusCode == 200) {
        Plant plant = Plant.fromJson(json.decode(response.body));
        return plant;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    throw Exception('Failed to load plant');
  }

  static Future<List<Plant>> getPlantsByAddress(Address address) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.plantsEndpoint}/address/${address.id}');
      var response = await http.get(url,
          headers: <String, String>{
          'Authorization': 'Bearer ${ApiConstants.jdkToken}'});
      if (response.statusCode == 200) {
        List<Plant> plants = plantsFromJson(response.body);
        return plants;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }
  //#endregion

  //#region Publication
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
      var response = await http.delete(url);
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
      var response = await http.get(url);
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
      var response = await http.get(url);
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
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<Publication> publications = publicationsFromJson(response.body);
        return publications;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }

  //#endregion
  //#region Message
  static Future<List<Message>?> getMessageByUser(User user) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.messagesEndpoint}/user/${user.id}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<Message> messages = messagesFromJson(response.body);
        return messages;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static Future<void> createMessage(Message message) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.messagesEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: messageToJson(message));
      if (response.statusCode == 200) {
        log('Message created');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> updateMessage(Message message) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.messagesEndpoint}/${message.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: messageToJson(message));
      if (response.statusCode == 200) {
        log('Message updated');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> deleteMessage(Message message) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.messagesEndpoint}/${message.id}');
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        log('Message deleted');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  //#region Report
  static Future<void> createReport(Report report) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.reportsEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: reportToJson(report));
      if (response.statusCode == 200) {
        log('Report created');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  //#endregion
  static Future<void> updateReport(Report report) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.reportsEndpoint}/${report.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: reportToJson(report));
      if (response.statusCode == 200) {
        log('Report updated');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> deleteReport(Report report) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.reportsEndpoint}/${report.id}');
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        log('Report deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<Report> getReportById(int id) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.reportsEndpoint}/$id');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Report report = Report.fromJson(json.decode(response.body));
        return report;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    throw Exception('Failed to load report');
  }

  static Future<List<Report>> getReportsByPublication(
      Publication publication) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.reportsEndpoint}/publication/${publication.id}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<Report> reports = reportsFromJson(response.body);
        return reports;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }
  //#endregion
}
