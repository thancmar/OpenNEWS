import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/models/location_model.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class LocationRepository {
  Future<Localization?> checklocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data = {
      'f': 'Localization.check',
      'json': '{"referrer": "localhost", "token":"","fingerprint":"AABBCC","gps":{ "latitude": "58.5890538", "longitude":"11.0419729"}}',
    };
    // String _cookieData = prefs.getString('cookie') ?? ' ';
    // // print(_cookieData);
    // Map<String, String> head = {
    //   'cookie': _cookieData,
    // };
    print(data);
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.localization),
      body: data,
      // headers: head,
    );
    print(response.body);
    if (response.statusCode == 200) {
      // return jokeModelFromJson(response.body);
      // print("200");
      final decoded = jsonDecode(response.body) as Map;
      print(decoded['code']);

      // if (decoded['code'] == 501) {
      if (decoded['code'] == 501) {
        //print(response)
        // throw Exception("Failed to login asdasdasdasd");
        print("Locaclization succees");
        // print(response.headers['set-cookie'] ?? "ds");
        // print(prefs.getString('cookie'));
        // var something = response.headers['set-cookie']!;
        // prefs.setString('cookie', something ?? "sas");
        // List<Localization> users = JsonData.map((e) => User.fromJson(e)).toList();
        //await prefs.setString('cookie', response.headers['set-cookie']!);
        return LocalizationFromJson(response.body);
      } else if (decoded['code'] == 500) {
        print("Locaclization failed with error code 501");
        print("you are not near a location");
        // return LocalizationFromJson(null);
        //throw Exception("Locaclization Failed12");
        return null;
        // print(response.body);
        // print(HotspotsGetAllActiveFromJson(response.body));
        // return null;
        // return LocalizationFromJson(response.body);
      }
      // return LocalizationFromJson(response.body);
      throw Exception("Locaclization Failed");
    } else {
      throw Exception("Locaclization Failed");
      // throw Exception("Failed to login");
    }
  }
}