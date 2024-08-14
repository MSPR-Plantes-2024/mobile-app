import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:mobile_app_arosaje/services/api_auth_service.dart';

class JdkToken {

  final String token;
  final String refreshToken;
  final DateTime expireDateTime;

  JdkToken({
    required this.token,
    required this.refreshToken,
    required this.expireDateTime,
  });

  factory JdkToken.fromJson(Map<String, dynamic> json) {
    return JdkToken(
      token: json['access_token'],
      refreshToken: json['refresh_token'],
      expireDateTime: DateTime.fromMillisecondsSinceEpoch(
          jsonDecode(
              utf8.decode(
                  base64Url.decode(
                      base64Url.normalize(
                          json['access_token'].split('.')[1]))))['exp'] * 1000),
    );
  }

  @override
  String toString() {
    return 'JdkToken{token: $token, refreshToken: $refreshToken, expireDateTime: $expireDateTime}';
  }

  bool checkExpired() {
    return DateTime.now().isAfter(expireDateTime);
  }
  static JdkToken getCurrent() {
    if (GetStorage().read('jdkToken') is JdkToken) {
      return GetStorage().read('jdkToken');
    }
    return JdkToken.fromJson(GetStorage().read('jdkToken'));
  }
  static void setCurrent(JdkToken jdkToken) {
    GetStorage().write('jdkToken', jdkToken);
  }
  static void removeCurrent() {
    GetStorage().remove('jdkToken');
  }
  static void refreshIfNeeded() {
    JdkToken.getCurrent().checkExpired() ? ApiAuthService.refreshToken(JdkToken.getCurrent()) : null;
  }
}
