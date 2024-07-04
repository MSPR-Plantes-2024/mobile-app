import 'dart:convert';
import 'dart:developer';

import 'package:mobile_app_arosaje/models/publication.dart';
import 'package:mobile_app_arosaje/models/report.dart';
import 'package:mobile_app_arosaje/services/constants.dart';
import 'package:http/http.dart' as http;

class ApiReportService {
  static Future<void> createReport(Report report) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.reportsEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
          },
          body: reportToJson(report));
      print(response.statusCode);
      print(response.body);
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
            'Authorization': 'Bearer ${ApiConstants.jdkToken}'
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
      var response = await http.delete(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
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
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
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
      var response = await http.get(url, headers: <String, String>{
        'Authorization': 'Bearer ${ApiConstants.jdkToken}'
      });
      if (response.statusCode == 200) {
        List<Report> reports = reportsFromJson(response.body);
        return reports;
      }
    } catch (e, s) {
      log('Exception: $e\nStack trace: $s');
    }
    return [];
  }
}
