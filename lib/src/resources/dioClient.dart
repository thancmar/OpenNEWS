import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../constants.dart';

class ApiClient {
  ///Two clients to share the cookies
  final Dio dioforImages;
  final Dio diofordata;
  final NetworkInfo networkInfo;
  final FlutterSecureStorage secureStorage;
  String? accessToken;
  final GetIt getIt = GetIt.instance;
  CancelToken cancelToken1 = CancelToken();
  CancelToken cancelToken2 = CancelToken();

  /// The base options for all requests with this Dio client.
  final BaseOptions baseOptions = BaseOptions(
    // connectTimeout: 5000,
    // receiveTimeout: 3000,
    // receiveDataWhenStatusError: true,
    followRedirects: true,

    // headers: ,
    headers: {"content-Type": "application/x-www-form-urlencoded"},
    // baseUrl: ApiConstants.baseUrl, // Domain constant (base path).
  );

  ApiClient({
    required this.dioforImages,
    required this.diofordata,
    required this.networkInfo,
    required this.secureStorage,
  }) {
    print("ApiClient initialized");
    var cokkies = CookieJar();
    dioforImages.options = baseOptions;
    diofordata.options = baseOptions;

    dioforImages.interceptors.add(CookieManager(cokkies));
    diofordata.interceptors.add(CookieManager(cokkies));
    //Important line, might have to modify later
    dioforImages.httpClientAdapter = DefaultHttpClientAdapter()..onHttpClientCreate = (httpClient) => httpClient..maxConnectionsPerHost = 30;
    diofordata.httpClientAdapter = DefaultHttpClientAdapter()..onHttpClientCreate = (httpClient) => httpClient..maxConnectionsPerHost = 30;
    dioforImages.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
      print(e.message);
      handler.next(e);
    }, onRequest: (r, handler) {
      // print(r.method);
      // print(r.path);
      handler.next(r);
    }, onResponse: (r, handler) {
      // print(r.data);
      handler.next(r);
    }));
    diofordata.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
      // print(e.message);
      // handler.next(e);
    }, onRequest: (r, handler) {
      // print(r.method);
      // print(r.path);
      handler.next(r);
    }, onResponse: (r, handler) {
      // print(r.data);
      handler.next(r);
    }));
  }
}