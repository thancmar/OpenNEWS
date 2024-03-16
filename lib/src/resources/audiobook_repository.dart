
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';

import '../constants.dart';
import '../models/audioBooksForLocationGetAllActive.dart';
import '../models/audiobookCategoryGetAllActiveByLocale.dart';
import '../models/magazineCategoryGetAllActive.dart';
import 'dioClient.dart';

class AudioBookRepository {
  Future<AudiobookCategoryGetAllActiveByLocale> audioBooksCategoryGetAllActive() async {
    final getIt = GetIt.instance;
    Map<String, dynamic> data = {'f': 'audiobookCategoryGetAllActiveByLocale','json':'{"locale":"de"}'};
    var queryString = Uri(queryParameters: data).query;
    var response = await getIt<ApiClient>().diofordata.post(
      ApiConstants.baseUrl + ApiConstants.usersEndpoint + '?' + queryString,
      data: data,
    );
    if (response.statusCode == 200) {
      print("audiobookCategoryGetAllActiveByLocale sucess");
      return AudiobookCategoryGetAllActiveByLocaleFromJson(response.data);
    } else {
      print("Failed audiobookCategoryGetAllActiveByLocale");
      throw Exception("Failed audiobookCategoryGetAllActiveByLocale");
    }
  }

  Future<AudioBooksForLocationGetAllActive> audioBooksForLocationGetAllActive({required String? id_hotspot}) async {
    final getIt = GetIt.instance;
    Map<String, dynamic> data = {
      'f': 'getAllActiveAudioBooksForLocation',
      'json': '{"id_location": "$id_hotspot"}'
    };
    var queryString = Uri(queryParameters: data).query;
    var response = await getIt<ApiClient>().diofordata.post(
      ApiConstants.baseUrl + ApiConstants.usersEndpoint + '?' + queryString,
      data: data,
    );

    if (response.statusCode == 200) {
      // print("GetAllActiveAudioBooksForLocation sucess ${response.data}");
      return GetAllActiveAudioBooksForLocationFromJson(response.data);
    } else {
      print("Failed GetAllActiveAudioBooksForLocation");
      throw Exception("Failed GetAllActiveAudioBooksForLocation");
    }
  }

  Future<Uint8List> GetAudioBookCover(
      {required String? id_audiobook,
        required String? dateOfPublication,
        // required CancelToken? readerCancelToken
      }) async {
    // print("GetPagesAsPDFforReader $id_mag_pub $id_mag_pub");
    final getIt = GetIt.instance;
    Map<String, dynamic> queryParame = {
      'id_audiobook': id_audiobook,
      'cover': "",
    };
    var queryString = Uri(queryParameters: queryParame).query;
print(ApiConstants.baseUrl + ApiConstants.getaudiobook + '?' + queryString);
    var response = await getIt<ApiClient>().diofordata.get(
        ApiConstants.baseUrl + ApiConstants.getaudiobook + '?' + queryString,
        options: Options(responseType: ResponseType.bytes),
        // cancelToken: readerCancelToken
    );

    switch (response.statusCode) {
      case 200:
        await DefaultCacheManager().putFile(
            id_audiobook! +
                "_" +
                dateOfPublication!+"audiobook"
               ,
            Uint8List.fromList(response.data),
            fileExtension: "jpeg",
            maxAge: Duration(days: 7));
        return Uint8List.fromList(response.data);
      default:
        throw Exception(response.data);
    }
  }
  //
  // Future<Uint8List> GetEbookPages(
  //     {required String? id_ebook,
  //       required String? dateOfPublication,
  //       // required CancelToken? readerCancelToken
  //     }) async {
  //   // print("GetPagesAsPDFforReader $id_mag_pub $id_mag_pub");
  //   final getIt = GetIt.instance;
  //   Map<String, dynamic> queryParame = {
  //     'id_ebook': id_ebook,
  //     'file': "",
  //   };
  //   var queryString = Uri(queryParameters: queryParame).query;
  //
  //   var response = await getIt<ApiClient>().diofordata.get(
  //     ApiConstants.baseUrl + ApiConstants.getebook + '?' + queryString,
  //     options: Options(responseType: ResponseType.bytes),
  //     // cancelToken: readerCancelToken
  //   );
  //
  //   switch (response.statusCode) {
  //     case 200:
  //       await DefaultCacheManager().putFile(
  //           id_ebook! +
  //               "_" +
  //               dateOfPublication!+"file"
  //           ,
  //           Uint8List.fromList(response.data),
  //           fileExtension: "epub",
  //           maxAge: Duration(days: 7));
  //       return Uint8List.fromList(response.data);
  //     default:
  //       throw Exception(response.data);
  //   }
  // }
}