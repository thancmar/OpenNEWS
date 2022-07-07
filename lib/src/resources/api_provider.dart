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
