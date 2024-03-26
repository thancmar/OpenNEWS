

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';

import '../constants.dart';
import '../models/ebookCategoryGetAllActiveByLocale.dart';
import '../models/ebooksForLocationGetAllActive.dart';
import 'dioClient.dart';

class EbookRepository {
  Future<EbookCategoryGetAllActiveByLocale> ebooksCategoryGetAllActive() async {
    final getIt = GetIt.instance;
    Map<String, dynamic> data = {'f': 'ebookCategoryGetAllActiveByLocale','json':'{"locale":"de"}'};
    print(data);
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
      print("ebookCategoryGetAllActiveByLocale sucess");
      // for (int i = 0; i < MagazineCategoryGetAllActiveFromJson(response.data).response!.length; i++) {
      //   await DefaultCacheManager().putFile(
      //       MagazineCategoryGetAllActiveFromJson(response.data).response![i].id! + "_" + MagazineCategoryGetAllActiveFromJson(response.data).response![i].name!,
      //       Uint8List.fromList(
      //         base64Decode(MagazineCategoryGetAllActiveFromJson(response.data).response![i].image!),
      //       ),
      //       fileExtension: "jpeg");
      // }
      // print(response.data);
      // print(response.data);
      return EbookCategoryGetAllActiveByLocaleFromJson(response.data);
    } else {
      print("Failed ebookCategoryGetAllActiveByLocale");
      throw Exception("Failed ebookCategoryGetAllActiveByLocale");
    }
  }

  Future<EbooksForLocationGetAllActive> ebooksForLocationGetAllActive({required String? id_hotspot}) async {
    final getIt = GetIt.instance;
    Map<String, dynamic> data = {
      'f': 'getAllActiveEbooksForLocation',
      'json': '{"id_location": "$id_hotspot"}'
    };

    print(data);
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
      // print("getAllActiveEbooksForLocation sucess ${response.data}");
      // for (int i = 0; i < MagazineCategoryGetAllActiveFromJson(response.data).response!.length; i++) {
      //   await DefaultCacheManager().putFile(
      //       MagazineCategoryGetAllActiveFromJson(response.data).response![i].id! + "_" + MagazineCategoryGetAllActiveFromJson(response.data).response![i].name!,
      //       Uint8List.fromList(
      //         base64Decode(MagazineCategoryGetAllActiveFromJson(response.data).response![i].image!),
      //       ),
      //       fileExtension: "jpeg");
      // }
      // print(response.data);
      // print(response.data);
      return EbooksForLocationGetAllActiveFromJson(response.data);
    } else {
      print("Failed magazineCategoryGetAllActive");
      throw Exception("Failed magazineCategoryGetAllActive");
    }
  }

  Future<Uint8List> GetEbookCover(
      {required String? id_ebook,
        required String? dateOfPublication,
        // required CancelToken? readerCancelToken
      }) async {
    // print("GetPagesAsPDFforReader $id_mag_pub $id_mag_pub");
    final getIt = GetIt.instance;
    Map<String, dynamic> queryParame = {
      'id_ebook': id_ebook,
      'cover': "",
    };
    var queryString = Uri(queryParameters: queryParame).query;

    var response = await getIt<ApiClient>().diofordata.get(
        ApiConstants.baseUrl + ApiConstants.getebook + '?' + queryString,
        options: Options(responseType: ResponseType.bytes),
        // cancelToken: readerCancelToken
    );

    switch (response.statusCode) {
      case 200:
        await DefaultCacheManager().putFile(
            id_ebook! +
                "_" +
                dateOfPublication!+"ebook"
               ,
            Uint8List.fromList(response.data),
            fileExtension: "jpeg",
            maxAge: Duration(days: 7));
        return Uint8List.fromList(response.data);
      default:
        throw Exception(response.data);
    }
  }

  Future<Uint8List> GetEbookPages(
      {required String? id_ebook,
        required String? dateOfPublication,
        // required CancelToken? readerCancelToken
      }) async {
    // print("GetPagesAsPDFforReader $id_mag_pub $id_mag_pub");
    final getIt = GetIt.instance;
    Map<String, dynamic> queryParame = {
      'id_ebook': id_ebook,
      'file': "",
    };
    var queryString = Uri(queryParameters: queryParame).query;

    var response = await getIt<ApiClient>().diofordata.get(
      ApiConstants.baseUrl + ApiConstants.getebook + '?' + queryString,
      options: Options(responseType: ResponseType.bytes),
      // cancelToken: readerCancelToken
    );

    switch (response.statusCode) {
      case 200:
        await DefaultCacheManager().putFile(
            id_ebook! +
                "_" +
                dateOfPublication!+"file"
            ,
            Uint8List.fromList(response.data),
            fileExtension: "epub",
            maxAge: Duration(days: 7));
        return Uint8List.fromList(response.data);
      default:
        throw Exception(response.data);
    }
  }
}