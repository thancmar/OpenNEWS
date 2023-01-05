import 'dart:typed_data';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:sharemagazines_flutter/src/constants.dart';
import 'package:sharemagazines_flutter/src/models/magazinePublishedGetAllLastByHotspotId_model.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:get_it/get_it.dart';

import 'dioClient.dart';

class MagazineRepository {
  Future<MagazinePublishedGetAllLastByHotspotId> magazinePublishedGetAllLastByHotspotId({required String? id_hotspot, required CookieJar cookieJar}) async {
    print("magazinePublishedGetAllLastByHotspotId $id_hotspot");
    final getIt = GetIt.instance;
    Map<String, dynamic> data = {'f': 'magazinePublishedGetAllLastByHotspotId', 'json': '{"id_hotspot": "$id_hotspot"}'};

    var queryString = Uri(queryParameters: data).query;

    // var response = await getIt<ApiClient>().dio.post(
    //       ApiConstants.baseUrl + ApiConstants.usersEndpoint + '?' + queryString,
    //       data: data,
    //     );
    var response = await getIt<ApiClient>().diofordata.post(
          ApiConstants.baseUrl + ApiConstants.usersEndpoint + '?' + queryString,
          data: data,
        );
    if (response.statusCode == 200) {
      print("magazinePublishedGetLastWithLimit sucess");
      // print(response.data);
      // print(response!.data);
      return MagazinePublishedGetLastWithLimitFromJson(response.data);
    } else {
      print("Failed magazinePublishedGetLastWithLimit");
      throw Exception("Failed magazinePublishedGetLastWithLimit");
    }
  }

  Future<MagazinePublishedGetAllLastByHotspotId> magazinePublishedGetTopLastByRange({required String? id_hotspot, required CookieJar cookieJar}) async {
    print("magazinePublishedGetTopLastByRange $id_hotspot");
    final getIt = GetIt.instance;
    Map<String, dynamic> data = {'f': 'magazinePublishedGetTopLastByRange', 'json': '{"id_hotspot": "$id_hotspot"}'};

    var queryString = Uri(queryParameters: data).query;

    // var response = await getIt<ApiClient>().dio.post(
    //       ApiConstants.baseUrl + ApiConstants.usersEndpoint + '?' + queryString,
    //       data: data,
    //     );
    var response = await getIt<ApiClient>().diofordata.post(
          ApiConstants.baseUrl + ApiConstants.usersEndpoint + '?' + queryString,
          data: data,
        );
    if (response.statusCode == 200) {
      print("magazinePublishedGetTopLastByRange sucess");
      // print(response.data);
      // print(response!.data);
      return MagazinePublishedGetLastWithLimitFromJson(response.data);
    } else {
      print("Failed magazinePublishedGetTopLastByRange");
      throw Exception("Failed magazinePublishedGetTopLastByRange");
    }
  }

  Future<Uint8List> GetPage({required String? page, required String? id_mag_pub}) async {
    // print("GetPage $id_mag_pub $page");
    final getIt = GetIt.instance;
    Map<String, dynamic> queryParame = {
      'page': page!,
      'id_mag_pub': id_mag_pub!,
    };
    var queryString = Uri(queryParameters: queryParame).query;

    var response = await getIt<ApiClient>().dioforImages.get(ApiConstants.getPageJPEG + '?' + queryString, options: Options(responseType: ResponseType.bytes));

    return Uint8List.fromList(response.data);
  }

  Future<Uint8List> GetPagesforReader({required String? page, required String? id_mag_pub, required CancelToken? readerCancelToken}) async {
    // print("GetPage $id_mag_pub $page");
    final getIt = GetIt.instance;
    Map<String, dynamic> queryParame = {
      'page': page!,
      'id_mag_pub': id_mag_pub!,
    };
    var queryString = Uri(queryParameters: queryParame).query;

    var response = await getIt<ApiClient>().diofordata.get(ApiConstants.getPageJPEG + '?' + queryString, options: Options(responseType: ResponseType.bytes), cancelToken: readerCancelToken);

    return Uint8List.fromList(response.data);
  }

  Future<Uint8List> GetPagesAsPDFforReader({required String? id_mag_pub, required CancelToken? readerCancelToken}) async {
    print("GetPagesAsPDFforReader $id_mag_pub $id_mag_pub");
    final getIt = GetIt.instance;
    Map<String, dynamic> queryParame = {
      'type': "pdf",
      'id_mag_pub': id_mag_pub!,
      'page': "all",
    };
    var queryString = Uri(queryParameters: queryParame).query;

    var response = await getIt<ApiClient>().diofordata.get(ApiConstants.getPageJPEG + '?' + queryString, options: Options(responseType: ResponseType.bytes), cancelToken: readerCancelToken);

    return Uint8List.fromList(response.data);
  }
}

// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:core';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sharemagazines_flutter/src/constants.dart';
// import 'package:http/http.dart' as http;
// import 'package:sharemagazines_flutter/src/models/magazinePublishedGetAllLastByHotspotId_model.dart';
// import 'package:cookie_jar/cookie_jar.dart';
// import 'package:get_it/get_it.dart';
//
// import 'dioClient.dart';
// //import 'package:google_sign_in/google_sign_in.dart';
//
// class MagazineRepository {
//   Future<MagazinePublishedGetLastWithLimit> magazinePublishedGetLastWithLimit({required String? id_hotspot, required ApiClient client, required CookieJar cookieJar}) async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     final getIt = GetIt.instance;
//     Map<String, dynamic> data = {'f': 'magazinePublishedGetAllLastByHotspotId', 'json': '{"id_hotspot": "$id_hotspot"}'};
//
//     // String _cookieData = await prefs.getString('cookie') ?? ' ';
//     //
//     // Map<String, String> head = {
//     //   'cookie': _cookieData,
//     // };
//     var queryString = Uri(queryParameters: data!).query;
//     var requestUrl = ApiConstants.baseUrl + ApiConstants.usersEndpoint + '?' + queryString;
//     // Options options = Options(headers: head);
//     // print(data);
//     // final response123 = await http.post(
//     //   Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint),
//     //   body: data,
//     //   // headers: head,
//     // );
//     // print(getIt<ApiClient>().accessToken);
//     // final dioClient = getIt<ApiClient>();
//     var response123 = await getIt<ApiClient>().dio.post(
//           requestUrl,
//           data: data,
//           // data: data,
//           // queryParameters: head,
//
//           // options: options,
//         );
//     // print(cookieJar.loadForRequest(Uri.parse("https://baidu.com/")));
//     // .then((value) => {print(value)});
//     // return Null;
//     // print(getIt.isRegistered());
//     if (response123!.statusCode == 200) {
//       // return jokeModelFromJson(response.body);
//       print("magazinePublishedGetLastWithLimit sucess");
//       // final decoded = jsonDecode(response123.data) as Map;
//       print(response123!.data);
//
//       print("107");
//       // print(getIt<ApiClient>()?.accessToken);
//       // print(response123.headers['set-cookie']);
//       // print(_cookieData);
//       // client?.accessToken = response123.headers['set-cookie'].toString();
//       return MagazinePublishedGetLastWithLimitFromJson(response123!.data);
//
//       // if (json.decode(response.body)['response']['code'] == 110) {
//       //   print("107");
//       //   throw Exception("Failed to login");
//       // } else {
//       //   print("108");
//       //   // String rawCookie = response.headers['set-cookie'] ?? _cookieData;
//       //   // print("rk");
//       //   // print(response.headers['set-cookie']);
//       //   // SharedPreferences prefs = await SharedPreferences.getInstance();
//       //   // prefs.setString('email', email!);
//       //   // prefs.setString('pw', password!);
//       //   // prefs.setString('cookie', rawCookie);
//       //   return MagazinePublishedGetLastWithLimitFromJson(response.body);
//       // }
//     } else {
//       print("Failed to login");
//       throw Exception("Failed to login");
//     }
//   }
//
//   // Future<Uint8List> GetCover({required String? page, required String? id_mag_pub}) async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   // Map data = {
//   //   //   'page': id_mag_pub,
//   //   //   'id_mag_pub': id_mag_pub,
//   //   // };
//   //
//   //   Map<String, String> queryParame = <String, String>{
//   //     'page': page!,
//   //     'id_mag_pub': id_mag_pub!,
//   //   };
//   //
//   //   String _cookieData = prefs.getString('cookie') ?? ' ';
//   //
//   //   Map<String, String> head = {
//   //     'cookie': _cookieData,
//   //   };
//   //
//   //   var queryString = Uri(queryParameters: queryParame).query;
//   //   var requestUrl = ApiConstants.baseUrl + ApiConstants.getCoverJPEG + '?' + queryString;
//   //
//   //   http.Response response1 = await http.get(
//   //     Uri.parse(requestUrl),
//   //     // Uri.http(ApiConstants.baseUrl, ApiConstants.getimageJPEG, queryString),
//   //     headers: head,
//   //   );
//   //
//   //   print(response1.bodyBytes);
//   //
//   //   return response1.bodyBytes;
//   // }
//
//   Future<Uint8List> GetPage({required String? page, required String? id_mag_pub}) async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // Map data = {
//     //   'page': id_mag_pub,
//     //   'id_mag_pub': id_mag_pub,
//     // };
//     print("GetPage $id_mag_pub $page");
//     final getIt = GetIt.instance;
//     Map<String, dynamic> queryParame = {
//       'page': page!,
//       'id_mag_pub': id_mag_pub!,
//     };
//
//     // String _cookieData = prefs.getString('cookie') ?? ' ';
//
//     // Map<String, String> head = {
//     //   'cookie': _cookieData,
//     // };
//
//     var queryString = Uri(queryParameters: queryParame!).query;
//
//     // var requestUrl = ApiConstants.baseUrl + ApiConstants.getPageJPEG + '?' + queryString;
//     var requestUrl = ApiConstants.getPageJPEG + '?' + queryString;
//
//     // http.Response request = await http.get(
//     //   Uri.parse(requestUrl),
//     //   // Uri.http(ApiConstants.baseUrl, ApiConstants.getimageJPEG, queryString),
//     //   headers: head,
//     // );
//     // var dio = Dio();
//     Options options = Options(responseType: ResponseType.bytes);
//     // client?.lock();
//     // var response = await client?.get(requestUrl, queryParameters: head, options: options);
//     var response = await getIt<ApiClient>().dio.get(requestUrl, options: options);
//
//     // var response = await request.close();
//     // var body = await response?.transform(utf8.decoder).join();
//     // Uint8List bytes = (await NetworkAssetBundle(Uri.parse(requestUrl)).load(requestUrl)).buffer.asUint8List();
//     // print("test");
//     // bytes.clear();
//     // print("api response");
//     // print(Uint8List.fromList(response?.data));
//
//     // request
//     // return null;
//     return Uint8List.fromList(response?.data);
//   }
// }