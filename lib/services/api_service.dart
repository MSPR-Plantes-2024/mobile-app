import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../models/address.dart';
import '../models/use_type.dart';
import '../models/user.dart';
import 'constants.dart';

class ApiService {

  //#region User
  static Future<List<User>?> getUsers() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<User> users = usersFromJson(response.body);
        return users;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static Future<void> createUser(User user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: userToJson(user));
      if (response.statusCode == 200) {
        log('User created');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> updateUser(User user) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/${user.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: userToJson(user));
      if (response.statusCode == 200) {
        log('User updated');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> deleteUser(User user) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/${user.id}');
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        log('User deleted');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<User?> getUser(int id) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/$id');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        User user = User.fromJson(json.decode(response.body));
        return user;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
  //#endregion
  //#region UserType
  static Future<UserType?> getUserType(int id) async {
    try {
      var url = Uri.parse(
          '${ ApiConstants.baseUrl}${ApiConstants.userTypesEndpoint}/$id');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        UserType userType = UserType.fromJson(json.decode(response.body));
        return userType;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
  //#endregion

  //#region Address
  static Future<Address?> getAddress(int id) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.addressesEndpoint}/$id');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Address address = Address.fromJson(json.decode(response.body));
        return address;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
  static Future<List<Address>?> getAddresses() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.addressesEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<Address> addresses = addressesFromJson(response.body);
        return addresses;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
  static Future<List<Address>?> getAddressesByUser(User user) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.addressesEndpoint}/user/${user.id}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<Address> addresses = addressesFromJson(response.body);
        return addresses;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
  static Future<void> createAddress(Address address) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.addressesEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: addressToJson(address));
      if (response.statusCode == 200) {
        log('Address created');
      }
    } catch (e) {
      log(e.toString());
    }
  }
  static Future<void> updateAddress(Address address) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.addressesEndpoint}/${address.id}');
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: addressToJson(address));
      if (response.statusCode == 200) {
        log('Address updated');
      }
    } catch (e) {
      log(e.toString());
    }
  }
  static Future<void> deleteAddress(Address address) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.addressesEndpoint}/${address.id}');
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        log('Address deleted');
      }
    } catch (e) {
      log(e.toString());
    }
  }
  //#endregion

}