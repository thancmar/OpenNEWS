import 'dart:convert';


//@immutable
//@JsonSerializable()
// class LoginModel {
//   final int id;
//   final String email;
//   final String mode;
//   final int version_android;
//   final int version_api;
//   final int version_ios;
//   final String lang;
//   final bool is_token_valid;
//
//   LoginModel(
//       {required this.id,
//       required this.email,
//       required this.mode,
//       required this.version_android,
//       required this.version_api,
//       required this.version_ios,
//       required this.lang,
//       required this.is_token_valid});
//
//   factory LoginModel.fromJson(Map<String, dynamic> json) {
//     return LoginModel(
//       id: json['id'],
//       email: json['email'],
//       mode: json['mode'],
//       version_android: json['version_android'],
//       version_api: json['version_api'],
//       version_ios: json['version_ios'],
//       lang: json['lang'],
//       is_token_valid: json['is_token_valid'],
//     );
//   }
// }

LoginModel LoginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

class LoginModel {
  Response? response;

  LoginModel({required this.response});

  LoginModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : throw Exception("Login Failed");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  String? id;
  String? email;
  String? mode;
  String? versionAndroid;
  String? versionApi;
  String? versionIos;
  String? lang;
  bool? isTokenValid;

  Response(
      {this.id,
      this.email,
      this.mode,
      this.versionAndroid,
      this.versionApi,
      this.versionIos,
      this.lang,
      this.isTokenValid});

  Response.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('id') ? json['id'] : throw Exception('Login response missing id field');
    email = json['email'];
    mode = json['mode'];
    versionAndroid = json['version_android'];
    versionApi = json['version_api'];
    versionIos = json['version_ios'];
    lang = json['lang'];
    isTokenValid = json['is_token_valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['mode'] = this.mode;
    data['version_android'] = this.versionAndroid;
    data['version_api'] = this.versionApi;
    data['version_ios'] = this.versionIos;
    data['lang'] = this.lang;
    data['is_token_valid'] = this.isTokenValid;
    return data;
  }
}