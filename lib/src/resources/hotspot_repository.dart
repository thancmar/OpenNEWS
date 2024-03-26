import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharemagazines/src/constants.dart';
import 'package:sharemagazines/src/models/hotspots_model.dart';
import 'package:get_it/get_it.dart';

import 'dioClient.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class HotspotRepository {
  Future<HotspotsGetAllActive> GetAllActiveHotspots() async {
    try {
      final getIt = GetIt.instance;
      Map<String, dynamic> data = {
        'f': 'hotspotGetAllActive',
      };
      var queryString = Uri(queryParameters: data).query;
      var response = await getIt<ApiClient>().diofordata.post(
            ApiConstants.baseUrl +
                ApiConstants.usersEndpoint +
                '?' +
                queryString,
            data: data,
          );
      switch (response.statusCode) {
        case 200:
          return HotspotsGetAllActiveFromJson(response.data);
        default:
          throw Exception(response.data);
      }
    } on TypeError catch (e) {
      print('An Error Occurred $e');
      throw Exception("Failed to parse the response");
    } on SocketException {
      rethrow;
    } catch (e) {
      print('An Error Occurred $e');
      throw Exception("Failed to login. Code ${e}");
    }
  }
}

// import 'dart:convert';
//
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sharemagazines_flutter/src/constants.dart';
// import 'package:http/http.dart' as http;
// import 'package:sharemagazines_flutter/src/models/hotspots_model.dart';
// import 'package:sharemagazines_flutter/src/models/login_model.dart';
// import 'package:get_it/get_it.dart';
//
// import 'dioClient.dart';
// //import 'package:google_sign_in/google_sign_in.dart';
//
// class HotspotRepository {
//   Future<HotspotsGetAllActive> GetAllActiveHotspots() async {
//     print(" hot repo hotspotGetAllActive");
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     Map<String, dynamic> data = {
//       'f': 'hotspotGetAllActive',
//     };
//     // String _cookieData = prefs.getString('cookie') ?? ' ';
//     // print(_cookieData);
//     // Map<String, String> head = {
//     //   'cookie': _cookieData,
//     // };
//     print(data);
//     var queryString = Uri(queryParameters: data!).query;
//     var requestUrl = ApiConstants.usersEndpoint + '?' + queryString;
//     // final response = await http.post(Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint), body: data, headers: head);
//     final getIt = GetIt.instance;
//     final response = await getIt<ApiClient>().dio.get(ApiConstants.usersEndpoint, queryParameters: data, options: Options(responseType: ResponseType.plain));
//     // print(json.decode(response.data)['response']['code']);
//     // print((response.data));
//     // print("00");
//     if (response.statusCode == 200) {
//       // return jokeModelFromJson(response.body);
//       // print("200");
//       // print(response.data);
//       var status = response.data.contains('session: you are not logged in.');
//       // print(response.data);
//       if (status) {
//         throw Exception("Failed to login asdasdasdasd");
//       } else {
//         // print("dccs");
//         // print(response.body);
//         // print(HotspotsGetAllActiveFromJson(response.body));
//         // return null;
//         return HotspotsGetAllActiveFromJson(response.data);
//       }
//     } else {
//       throw Exception("Failed to login");
//     }
//   }
// }