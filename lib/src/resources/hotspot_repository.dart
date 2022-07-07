import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sharemagazines_flutter/src/models/hotspots_model.dart';
import 'package:sharemagazines_flutter/src/models/login_model.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class HotspotRepository {
  Future<HotspotsGetAllActive> GetAllActiveHotspots() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data = {
      'f': 'hotspotGetAllActive',
    };
    String _cookieData = prefs.getString('cookie') ?? ' ';
    // print(_cookieData);
    Map<String, String> head = {
      'cookie': _cookieData,
    };
    print(data);
    final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint),
        body: data,
        headers: head);
    // print(json.decode(response.body)['response']['code']);
    // print("00");
    if (response.statusCode == 200) {
      // return jokeModelFromJson(response.body);
      // print("200");
      // print(response.body);
      var status = response.body.contains('session: you are not logged in.');
      if (status) {
        throw Exception("Failed to login asdasdasdasd");
      } else {
        // print("dccs");
        // print(response.body);
        // print(HotspotsGetAllActiveFromJson(response.body));
        // return null;
        return HotspotsGetAllActiveFromJson(response.body);
      }
    } else {
      throw Exception("Failed to login");
    }
  }
}
