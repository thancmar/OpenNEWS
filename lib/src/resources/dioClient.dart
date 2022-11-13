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

  /// The base options for all requests with this Dio client.
  final BaseOptions baseOptions = BaseOptions(
    // connectTimeout: 5000,
    // receiveTimeout: 3000,
    // receiveDataWhenStatusError: true,
    followRedirects: true,
    // headers: ,
    headers: {"content-Type": "application/x-www-form-urlencoded"},
    baseUrl: ApiConstants.baseUrl, // Domain constant (base path).
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
    dioforImages.httpClientAdapter = DefaultHttpClientAdapter()..onHttpClientCreate = (httpClient) => httpClient..maxConnectionsPerHost = 40;
    diofordata.httpClientAdapter = DefaultHttpClientAdapter()..onHttpClientCreate = (httpClient) => httpClient..maxConnectionsPerHost = 40;
    dioforImages.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
      print(e.message);
      handler.next(e);
    }, onRequest: (r, handler) {
      print(r.method);
      print(r.path);
      handler.next(r);
    }, onResponse: (r, handler) {
      // print(r.data);
      handler.next(r);
    }));
    diofordata.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
      print(e.message);
      handler.next(e);
    }, onRequest: (r, handler) {
      print(r.method);
      print(r.path);
      handler.next(r);
    }, onResponse: (r, handler) {
      // print(r.data);
      handler.next(r);
    }));
  }

  /// Is the current access token valid? Checks if it's null, empty, or expired.
// bool get validToken {
//   if (accessToken == null || accessToken!.isEmpty || JwtDecoder.isExpired(accessToken!)) return false;
//   return true;
// }
  /// Sets the current [accessToken] to request header.
  // void setHeader(RequestOptions options) => options.headers["cookie"] = "$accessToken";

  /// Refreshes access token, sets it to header, and resolves cloned request of the original.
  // Future<void> refreshAndRedoRequest(DioError error, ErrorInterceptorHandler handler) async {
  //   await getAndSetAccessTokenVariable(dio);
  //   setHeader(error.requestOptions);
  //   handler.resolve(await dio.post(error.requestOptions.path, data: error.requestOptions.data, options: Options(method: error.requestOptions.method)));
  // }

  /// Gets new access token using the device's refresh token and sets it to [accessToken] class field.
  ///
  /// If the refresh token from the device's storage is null or empty, an [EmptyTokenException] is thrown.
  /// This should be handled with care. This means the user has somehow been logged out!
  // Future<void> getAndSetAccessTokenVariable(Dio dio) async {
  //   final refreshToken = await secureStorage.read(key: "cookie");
  //   if (refreshToken == null || refreshToken.isEmpty) {
  //     // User is no longer logged in!
  //     // throw EmptyTokenException();
  //   } else {
  //     // New DIO instance so it doesn't get blocked by QueuedInterceptorsWrapper.
  //     // Refreshes token from endpoint.
  //     try {
  //       final response = await Dio(baseOptions).post(
  //         ApiConstants.baseUrl,
  //         data: {"cookie": refreshToken},
  //       );
  //       // If refresh fails, throw a custom exception.
  //       if (!validStatusCode(response)) {
  //         // throw ServerException();
  //       }
  //       accessToken = response.data["cookie"];
  //     } on DioError catch (e) {
  //       // Based on the different dio errors, throw custom exception classes.
  //       switch (e.type) {
  //         case DioErrorType.sendTimeout:
  //           // throw ConnectionException();
  //           print("ConnectionException()");
  //           break;
  //         case DioErrorType.connectTimeout:
  //           // throw ConnectionException();
  //           print("ConnectionException()");
  //           break;
  //         case DioErrorType.receiveTimeout:
  //           // throw ConnectionException();
  //           print("ConnectionException()");
  //           break;
  //         case DioErrorType.response:
  //           // throw ServerException();
  //           print("ConnectionException()");
  //           break;
  //         default:
  //           // throw ServerException();
  //           print("ConnectionException()");
  //       }
  //     }
  //   }
  // }

  // bool tokenInvalidResponse(DioError error) => error.response?.statusCode == 403 || error.response?.statusCode == 401;
  //
  // bool validStatusCode(Response response) => response.statusCode == 200 || response.statusCode == 201;
}
//
// import 'dart:async';
// import 'package:http/http.dart' show Client;
// import 'package:sharemagazines_flutter/src/models/Startup_model.dart';
// import 'dart:convert';
// import '../models/login_model.dart';
//
// class ApiProvider {
//   Client client = Client();
//   final _apiKey =
//       'https://app.sharemagazines.de/sharemagazines/interface/json_main.php';
//
//   Future<LoginModel> fetchLogin() async {
//     print("entered");
//     final response = await client.post(Uri.parse(_apiKey));
//     print(response.body.toString());
//     if (response.statusCode == 200) {
//       // If the call to the server was successful, parse the JSON
//       return LoginModel.fromJson(json.decode(response.body));
//     } else {
//       // If that call was not successful, throw an error.
//       throw Exception('Failed to load post');
//     }
//   }
//
//   Future<StartupModel> fetchStartup() async {
//     print("entered");
//     final response = await client.post(Uri.parse(_apiKey));
//     print(response.body.toString());
//     if (response.statusCode == 200) {
//       // If the call to the server was successful, parse the JSON
//       return 0;
//     } else {
//       // If that call was not successful, throw an error.
//       throw Exception('Failed to load post');
//     }
//   }
// }