import 'dart:convert';
import 'dart:typed_data';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sharemagazines_flutter/src/models/magazine_publication_model.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class MagazineRepository {
  Future<MagazinePublishedGetLastWithLimit> magazinePublishedGetLastWithLimit({
    required String? id_hotspot,
  }) async {
    // print("MagazineRepository");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data = {
      'f': 'magazinePublishedGetAllLastByHotspotId',
      'json': '{"id_hotspot": "$id_hotspot"}'
    };

    String _cookieData = prefs.getString('cookie') ?? ' ';

    Map<String, String> head = {
      'cookie': _cookieData,
    };

    // print(data);
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint),
      body: data,
      headers: head,
    );

    if (response.statusCode == 200) {
      // return jokeModelFromJson(response.body);
      // print(response.body);
      // print("107");
      return MagazinePublishedGetLastWithLimitFromJson(response.body);
      // if (json.decode(response.body)['response']['code'] == 110) {
      //   print("107");
      //   throw Exception("Failed to login");
      // } else {
      //   print("108");
      //   // String rawCookie = response.headers['set-cookie'] ?? _cookieData;
      //   // print("rk");
      //   // print(response.headers['set-cookie']);
      //   // SharedPreferences prefs = await SharedPreferences.getInstance();
      //   // prefs.setString('email', email!);
      //   // prefs.setString('pw', password!);
      //   // prefs.setString('cookie', rawCookie);
      //   return MagazinePublishedGetLastWithLimitFromJson(response.body);
      // }
    } else {
      print("Failed to login");
      throw Exception("Failed to login");
    }
  }

  Future<Uint8List> Getimage(
      {required String? page, required String? id_mag_pub}) async {
    print(id_mag_pub);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Map data = {
    //   'page': id_mag_pub,
    //   'id_mag_pub': id_mag_pub,
    // };

    Map<String, String> queryParame = <String, String>{
      'page': page!,
      'id_mag_pub': id_mag_pub!,
    };

    String _cookieData = prefs.getString('cookie') ?? ' ';

    Map<String, String> head = {
      'cookie': _cookieData,
    };

    var queryString = Uri(queryParameters: queryParame).query;
    var requestUrl =
        ApiConstants.baseUrl + ApiConstants.getimageJPEG + '?' + queryString;

    http.Response response1 = await http.get(
      Uri.parse(requestUrl),
      // Uri.http(ApiConstants.baseUrl, ApiConstants.getimageJPEG, queryString),
      headers: head,
    );
    print("test");

    print(response1.bodyBytes);

    return response1.bodyBytes;
  }
}
