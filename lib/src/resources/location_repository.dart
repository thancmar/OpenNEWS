import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/models/location_model.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'dioClient.dart';

class LocationRepository {
  Future<Localization?> checklocation([String? locationID, double? lat, double? long]) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // Map data = {
    //   'f': 'Localization.check',
    //   'json': '{"referrer": "localhost", "token":"","fingerprint":"AABBCC","gps":{ "latitude": "58.5890538", "longitude":"11.0419729"}}',
    // };
    final getIt = GetIt.instance;
    Map<String, dynamic> data;
    if (lat != null && long != null) {
      if (locationID != null) {
        data = {
          'f': 'Localization.check',
          'json': '{"id_location":"$locationID","gps":{"latitude":"$lat","longitude":"$long"}}',
        };
      } else {
        data = {
          'f': 'Localization.check',
          'json': '{"gps":{"latitude":"$lat","longitude":"$long"}}',
        };
      }
    } else {
      if (locationID != null) {
        data = {
          'f': 'Localization.check',
          'json': '{"id_location":"$locationID"}',
        };
      } else {
        data = {
          'f': 'Localization.check',
          'json': '{"": ""}',
        };
      }
    }
    var queryString = Uri(queryParameters: data).query;
    print(data);
    var response = await getIt<ApiClient>().diofordata.post(
          ApiConstants.baseUrl + ApiConstants.localization + '?' + queryString,
          data: data,
        );

    print(response.data);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.data) as Map;
      print(decoded['code']);
      if (decoded['code'] == 511) {
        print("you are in the given location.");
        return LocalizationFromJson(response.data);
      } else if (decoded['code'] == 501) {
        print("you are near a location.");
        return LocalizationFromJson(response.data);
      } else if (decoded['code'] == 500) {
        print("Locaclization failed with error code 500");
        print("you are not near a location");
        return LocalizationFromJson(response.data);
      }
      throw Exception("Locaclization Failed");
    } else {
      throw Exception("Locaclization Failed");
      ;
    }
  }
}