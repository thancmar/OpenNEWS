import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/models/location_model.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/locationGetHeader_model.dart';
import '../models/locationOffers_model.dart';
import 'dioClient.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

class LocationRepository {
  Future<Localization?> checklocation([String? locationID, double? lat, double? long, String? token]) async {
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
      // if (locationID != null) {
      if (token != null) {
        data = {
          'f': 'Localization.check',
          'json': '{"id_location":"$locationID","token":"$token","fingerprint":"edb1b95f1930da5dbfd3af18630d5680"}',
        };
      } else {
        data = {
          'f': 'Localization.check',
          'json': '{"id_location":"$locationID"}',
        };
      }
      // } else {
      //   data = {
      //     'f': 'Localization.check',
      //     'json': '{"": ""}',
      //   };
      // }
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
        // print("Locaclization failed with error code 500");
        print("you are not near a location");
        return LocalizationFromJson(response.data);
      }
      throw Exception("Locaclization Failed");
    } else {
      throw Exception("Locaclization Failed");
      ;
    }
  }

  Future<LocationGetHeader> GetLocationHeader({required String locationID}) async {
    // print("GetPage $id_mag_pub $page");
    final getIt = GetIt.instance;
    // Map<String, dynamic> queryParame = {
    //   'page': page!,
    //   'id_mag_pub': id_mag_pub!,
    // };
    // var queryString = Uri(queryParameters: queryParame).query;
    // var file = await DefaultCacheManager().getSingleFile(queryString);

    // await DefaultCacheManager().emptyCache();
    var response = await getIt<ApiClient>().diofordata.get(
        ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "location/" + locationID + "/getHeader",
        options: Options(responseType: ResponseType.json));
    print(response.data);
    // await DefaultCacheManager().putFile(id_mag_pub + "_" + date_of_publication!, Uint8List.fromList(response.data), fileExtension: "jpeg", maxAge: Duration(days: 30));
    if (response.statusCode == 200) {
      return LocationGetHeader.fromJson(response.data);
    } else {
      throw Exception("An error occurred while fetching location header");
    }
  }

  Future<Uint8List> GetLocationImage({required String locationID, required String filePath}) async {
    // print("GetPage $id_mag_pub $page");
    final getIt = GetIt.instance;
    // Map<String, dynamic> queryParame = {
    //   'page': page!,
    //   'id_mag_pub': id_mag_pub!,
    // };
    // var queryString = Uri(queryParameters: queryParame).query;
    // var file = await DefaultCacheManager().getSingleFile(queryString);

    // await DefaultCacheManager().emptyCache();
    var response = await getIt<ApiClient>().diofordata.get(
        ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "location/" + locationID + "/getImage?filePath=" + "$filePath",
        options: Options(responseType: ResponseType.bytes));
    // var response = await getIt<ApiClient>().dioforImages.get(
    //     ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "location/" + "4188" + "/getImage?filePath=" + "/uploads/headers/4188_01.12.2020-12-04-02.jpg",
    //     options: Options(responseType: ResponseType.bytes));

    // print("GetLocationImage response  ${response.data}");
    // await DefaultCacheManager().putFile(id_mag_pub + "_" + date_of_publication!, Uint8List.fromList(response.data), fileExtension: "jpeg", maxAge: Duration(days: 30));
    if (response.statusCode == 200) {
      return Uint8List.fromList(response.data);
    } else {
      throw Exception("An error occurred while fetching location header");
    }
  }

  Future<LocationOffers> GetLocationOffers({required String locationID}) async {
    try {
      // print("GetPage $id_mag_pub $page");
      final getIt = GetIt.instance;
      // Map<String, dynamic> queryParame = {
      //   'page': page!,
      //   'id_mag_pub': id_mag_pub!,
      // };
      // var queryString = Uri(queryParameters: queryParame).query;
      // var file = await DefaultCacheManager().getSingleFile(queryString);

      // await DefaultCacheManager().emptyCache();
      var response = await getIt<ApiClient>().diofordata.get(
          ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "offer?locationID=" + locationID,
          options: Options(responseType: ResponseType.json));
      // var response = await getIt<ApiClient>().dioforImages.get(
      //     ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "location/" + "4188" + "/getImage?filePath=" + "/uploads/headers/4188_01.12.2020-12-04-02.jpg",
      //     options: Options(responseType: ResponseType.bytes));

      print("GetLocationOffers response  ${response.data}");
      // await DefaultCacheManager().putFile(id_mag_pub + "_" + date_of_publication!, Uint8List.fromList(response.data), fileExtension: "jpeg", maxAge: Duration(days: 30));
      if (response.statusCode == 200) {
        // print(response.data);
        return LocationOffers.fromJson(response.data);
      } else {
        throw Exception("An error occurred while fetching location offers");
      }
    } catch (error) {
      print("GetLocationOffers $error");
      throw Exception();
    }
  }

  Future<Uint8List> GetLocationOfferImage({required String offerID, required String filePath}) async {
    // print("GetPage $id_mag_pub $page");
    final getIt = GetIt.instance;
    // Map<String, dynamic> queryParame = {
    //   'page': page!,
    //   'id_mag_pub': id_mag_pub!,
    // };
    // var queryString = Uri(queryParameters: queryParame).query;
    // var file = await DefaultCacheManager().getSingleFile(queryString);

    // await DefaultCacheManager().emptyCache();
    var response = await getIt<ApiClient>().diofordata.get(
        ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "offer/" + offerID + "/getImage?filePath=" + "$filePath",
        options: Options(responseType: ResponseType.bytes));
    // var response = await getIt<ApiClient>().dioforImages.get(
    //     ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "location/" + "4188" + "/getImage?filePath=" + "/uploads/headers/4188_01.12.2020-12-04-02.jpg",
    //     options: Options(responseType: ResponseType.bytes));

    // print("GetLocationImage response  ${response.data}");
    // await DefaultCacheManager().putFile(id_mag_pub + "_" + date_of_publication!, Uint8List.fromList(response.data), fileExtension: "jpeg", maxAge: Duration(days: 30));
    if (response.statusCode == 200) {
      return Uint8List.fromList(response.data);
    } else {
      throw Exception("An error occurred while fetching location offer image");
    }
  }

  Future<PdfDocument> GetLocationOfferPDF({required String offerID, required String filePath}) async {
    // print("GetPage $id_mag_pub $page");
    final getIt = GetIt.instance;
    // Map<String, dynamic> queryParame = {
    //   'page': page!,
    //   'id_mag_pub': id_mag_pub!,
    // };
    // var queryString = Uri(queryParameters: queryParame).query;
    // var file = await DefaultCacheManager().getSingleFile(queryString);

    // await DefaultCacheManager().emptyCache();
    var response = await getIt<ApiClient>().diofordata.get(
        ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "offer/" + offerID + "/getData?filePath="
        // +
        // "$filePath"
        ,
        options: Options(responseType: ResponseType.bytes));
    // var response = await getIt<ApiClient>().dioforImages.get(
    //     ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "location/" + "4188" + "/getImage?filePath=" + "/uploads/headers/4188_01.12.2020-12-04-02.jpg",
    //     options: Options(responseType: ResponseType.bytes));

    // print("GetLocationImage response  ${response.data}");
    // await DefaultCacheManager().putFile(id_mag_pub + "_" + date_of_publication!, Uint8List.fromList(response.data), fileExtension: "jpeg", maxAge: Duration(days: 30));
    if (response.statusCode == 200) {
      PdfDocument docFromData = await PdfDocument.openData(response.data);

      return docFromData;
    } else {
      throw Exception("An error occurred while fetching location offer image");
    }
  }

  Future<File> GetLocationOfferVideo({required String offerID, required String filePath}) async {
    // print("GetPage $id_mag_pub $page");
    final getIt = GetIt.instance;
    // Map<String, dynamic> queryParame = {
    //   'page': page!,
    //   'id_mag_pub': id_mag_pub!,
    // };
    // var queryString = Uri(queryParameters: queryParame).query;
    // var file = await DefaultCacheManager().getSingleFile(queryString);

    // await DefaultCacheManager().emptyCache();
    var response = await getIt<ApiClient>().diofordata.get(
        ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "offer/" + offerID + "/getData?filePath=" + "$filePath",
        options: Options(responseType: ResponseType.bytes));
    // var response = await getIt<ApiClient>().dioforImages.get(
    //     ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "location/" + "4188" + "/getImage?filePath=" + "/uploads/headers/4188_01.12.2020-12-04-02.jpg",
    //     options: Options(responseType: ResponseType.bytes));

    // print("GetLocationImage response  ${response.data}");
    // await DefaultCacheManager().putFile(id_mag_pub + "_" + date_of_publication!, Uint8List.fromList(response.data), fileExtension: "jpeg", maxAge: Duration(days: 30));
    if (response.statusCode == 200) {
      // print(response.data);
      final appDir = await syspaths.getTemporaryDirectory();
      File file = File('${appDir.path}/sth.mp4');
      await file.writeAsBytes(response.data);
      return file;
    } else {
      throw Exception("An error occurred while fetching location offer image");
    }
  }
// Future<File> GetLocationOfferVideo({required String offerID, required String filePath}) async {
//   // print("GetPage $id_mag_pub $page");
//   final getIt = GetIt.instance;
//   // Map<String, dynamic> queryParame = {
//   //   'page': page!,
//   //   'id_mag_pub': id_mag_pub!,
//   // };
//   // var queryString = Uri(queryParameters: queryParame).query;
//   // var file = await DefaultCacheManager().getSingleFile(queryString);
//
//   // await DefaultCacheManager().emptyCache();
//   var response = await getIt<ApiClient>()
//       .dioforImages
//       .get(ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "offer/" + offerID + "/getData?filePath=" + "$filePath", options: Options(responseType: ResponseType.bytes));
//   // var response = await getIt<ApiClient>().dioforImages.get(
//   //     ApiConstants.baseUrlLocations + ApiConstants.locationsMobileAPI + "location/" + "4188" + "/getImage?filePath=" + "/uploads/headers/4188_01.12.2020-12-04-02.jpg",
//   //     options: Options(responseType: ResponseType.bytes));
//
//   // print("GetLocationImage response  ${response.data}");
//   // await DefaultCacheManager().putFile(id_mag_pub + "_" + date_of_publication!, Uint8List.fromList(response.data), fileExtension: "jpeg", maxAge: Duration(days: 30));
//   if (response.statusCode == 200) {
//     // print(response.data);
//     final appDir = await syspaths.getTemporaryDirectory();
//     File file = File('${appDir.path}/sth.mp4');
//     await file.writeAsBytes(response.data);
//     return file;
//   } else {
//     throw Exception("An error occurred while fetching location offer image");
//   }
// }
}