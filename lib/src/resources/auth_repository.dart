import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sharemagazines_flutter/src/models/incomplete_login_model.dart';
import 'package:sharemagazines_flutter/src/models/login_model.dart';
import 'package:sharemagazines_flutter/src/models/registrierung_model.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/registrationpage.dart';
import 'package:sharemagazines_flutter/src/resources/dioClient.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it/get_it.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  Future<Registrierung> signUp(
      {required String email,
      required String password,
      required String firstname,
      required String lastname,
      required String date_of_birth,
      required String sex,
      String? address_street,
      required String address_house_nr,
      required String address_zip,
      required String address_city,
      required String phone,
      required String iban,
      required String account_owner,
      required String creation_date,
      required String origin}) async {
    Map data = {
      'f': 'readerAdd',
      'json':
          '{"email": "$email", "password":"$password", "firstname":"$firstname", "lastname":"$lastname", "date_of_birth":"$date_of_birth", "sex":"$sex","address_street":"$address_street" ,"address_house_nr":"$address_house_nr","address_zip":"$address_zip","address_city":"$address_city","phone":"$phone","iban":"$iban","account_owner":"$account_owner","creation_date":"","origin":"$origin"}'
    };
    print(data);

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint),
      body: data,
      // headers: head,
    );
    print("login response: ${response.body}");
    if (response.statusCode == 200) {
      // return jokeModelFromJson(response.body);
      // print(response.body);
      if (json.decode(response.body)['response']['code'] == 1062) {
        print("1062");
        throw Exception("Failed to signup");
      } else {
        // String rawCookie = response.headers['set-cookie'] ?? _cookieData;
        print("rk");
        print(response.headers['set-cookie']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setString('pw', password);
        prefs.setString('cookie', response.headers['set-cookie']!);
        return RegistrierungFromJson(response.body);
      }
    } else {
      throw Exception("Failed to login");
    }
    // print("AuthRepository Signup");
    // final getIt = GetIt.instance;
    // Map data = {
    //   'f': 'readerAdd',
    //   'json':
    //       '{"email": "$email", "password":"$password", "firstname":"$firstname", "lastname":"$lastname", "date_of_birth":"$date_of_birth", "sex":"$sex","address_street":"$address_street" ,"address_house_nr":"$address_house_nr","address_zip":"$address_zip","address_city":"$address_city","phone":"$phone","iban":"$iban","account_owner":"$account_owner","creation_date":"","origin":"$origin"}'
    // };
    // // String _cookieData = prefs.getString('cookie') ?? ' ';
    // //
    // // Map<String, String> head = {
    // //   'cookie': _cookieData,
    // // };
    //
    // // final response = await http.post(Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint), body: data, headers: head);
    //
    // // print(json.decode(response.body)['response']['code']);
    // var response = await getIt<ApiClient>().dioforImages.post(
    //       ApiConstants.usersEndpoint,
    //       data: data,
    //     );
    // // print(response!.data);
    // print("User Incomplete login response: ${response.data}");
    // if (response.statusCode == 200) {
    //   // return jokeModelFromJson(response.body);
    //   if (json.decode(response.data)['response']['code'] == 103) {
    //     throw Exception("Failed to login with code 103");
    //   } else {
    //     return IncompleteLoginModelFromJson(response.data);
    //   }
    // } else {
    //   throw Exception("Failed to login");
    // }
  }

  Future<LoginModel> signIn({
    required String? email,
    required String? password,
    // required ApiClient client,
  }) async {
    print("Complete signIn");
    final getIt = GetIt.instance;
    // SharedPreferences prefs = await SharedPreferences.getInstance();¢®
    Map<String, dynamic> data = {'f': 'readerLogin', 'json': '{"email": "$email", "password":"$password", "version":"5", "client":"ios", "lang":"en", "token":"","fingerprint":"AABBCC"}'};

    // String _cookieData = prefs.getString('cookie') ?? ' '; //Dont need it i guess
    // Map<String, String> head = {
    //   'cookie': _cookieData,
    // };$

    // final response = await http.post(
    //   Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint),
    //   body: data,
    //   // headers: head,
    // );

    // print(data);
    final response = await getIt<ApiClient>().dioforImages.post(ApiConstants.usersEndpoint, data: data, options: Options(responseType: ResponseType.plain));
    print("User login response: ${response.data}");
    // print(response!.headers);
//COde 103 cannot add reader
    if (response!.statusCode == 200) {
      // return jokeModelFromJson(response.body);
      print(response!.realUri);
      if (json.decode(response!.data)['response']['code'] == 107) {
        print("107");
        throw Exception("Failed to signin with code 107");
      } else {
        // String rawCookie = response.headers['set-cookie'] ?? _cookieData;
        print("rl Login");
        print(response!.data);
        print(response.headers['set-cookie']);
        // client.accessToken = response.headers['set-cookie'].toString();
        print("rl Login");
        // print(client.accessToken);
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('email', email!);
        // await prefs.setString('pw', password!);
        // await prefs.setString('cookie', response!.headers['set-cookie']! as String);
        // print(prefs.getString('email'));
        return LoginModelFromJson(response!.data);
      }
    } else {
      throw Exception("Failed to login");
    }
  }

  Future<IncompleteLoginModel?> signInIncomplete({
    required ApiClient client,
  }) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Incomplete signIn");
    final getIt = GetIt.instance;
    Map data = {
      'f': 'incompleteReaderAdd',
    };
    // String _cookieData = prefs.getString('cookie') ?? ' ';
    //
    // Map<String, String> head = {
    //   'cookie': _cookieData,
    // };

    // final response = await http.post(Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint), body: data, headers: head);

    // print(json.decode(response.body)['response']['code']);
    var response = await getIt<ApiClient>().dioforImages.post(
          ApiConstants.usersEndpoint,
          data: data,
        );
    // print(response!.data);
    print("User Incomplete login response: ${response.data}");
    if (response.statusCode == 200) {
      // return jokeModelFromJson(response.body);
      if (json.decode(response.data)['response']['code'] == 103) {
        throw Exception("Failed to login with code 103");
      } else {
        return IncompleteLoginModelFromJson(response.data);
      }
    } else {
      throw Exception("Failed to login");
    }
  }

  Future<void> signOut() async {
    Map data = {'f': 'readerLogin'};
    final response = await http.post(Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint), body: data);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', '');
      prefs.setString('pw', '');
      prefs.setString('cookie', '');
      return;
    } else {
      throw Exception("Failed to logout");
    }
  }
}