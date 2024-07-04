import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../models/address.dart';
import '../models/user.dart';
import 'constants.dart';


class ApiAddressService {
  static Future<Address> getAddressById(int id) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.addressesEndpoint}/$id');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
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

  static Future<List<Address>> getAddresses() async {
    try {
      var url =
      Uri.parse(ApiConstants.baseUrl + ApiConstants.addressesEndpoint);
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
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

  static Future<List<Address>> getAddressesByUser(User user) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.addressesEndpoint}/user/${user.id}');
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
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
      if (response.statusCode == 201) {
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
      var response = await http.delete(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        log('Address deleted');
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
  }
}
