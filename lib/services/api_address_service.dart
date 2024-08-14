import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_arosaje/models/jdk_token.dart';

import '../models/address.dart';
import '../models/user.dart';
import 'constants.dart' as constants;


class ApiAddressService {
  static Future<Address> getById(int id) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.ADDRESSES_ENDPOINT}/$id');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
      });
      if (response.statusCode == 200) {
        Address address = Address.fromJson(json.decode(response.body));
        return address;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    throw Exception('Failed to load address');
  }

  static Future<List<Address>> getAll() async {
    JdkToken.refreshIfNeeded();
    try {
      var url =
      Uri.parse(constants.BASE_URL + constants.ADDRESSES_ENDPOINT);
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
      });
      if (response.statusCode == 200) {
        List<Address> addresses = addressesFromJson(response.body);
        return addresses;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }

  static Future<List<Address>> getByUser(User user) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.ADDRESSES_ENDPOINT}/user/${user.id}');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
      });
      if (response.statusCode == 200) {
        List<Address> addresses = addressesFromJson(response.body);
        return addresses;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }

  static Future<void> create(Address address) async {
    JdkToken.refreshIfNeeded();
    try {
      var url =
      Uri.parse(constants.BASE_URL + constants.ADDRESSES_ENDPOINT);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
          },
          body: addressToJson(address));
      if (response.statusCode == 201) {
        log('Address created');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> update(Address address) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.ADDRESSES_ENDPOINT}/${address.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
          },
          body: addressToJson(address));
      if (response.statusCode == 200) {
        log('Address updated');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }

  static Future<void> delete(Address address) async {
    JdkToken.refreshIfNeeded();
    try {
      var url = Uri.parse(
          '${constants.BASE_URL}${constants.ADDRESSES_ENDPOINT}/${address.id}');
      var response = await http.delete(url, headers: <String, String>{
        'Authorization': 'Bearer ${JdkToken.getCurrent().token}'
      });
      if (response.statusCode == 200) {
        log('Address deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }
}
