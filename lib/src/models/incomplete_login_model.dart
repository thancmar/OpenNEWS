import 'dart:convert';

IncompleteLoginModel IncompleteLoginModelFromJson(String str) =>
    IncompleteLoginModel.fromJson(json.decode(str));

class IncompleteLoginModel {
  late Response? response;

  IncompleteLoginModel({required this.response});

  IncompleteLoginModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response?.toJson();
    }
    return data;
  }
}

class Response {
  String? email;
  String? password;

  Response({required this.email, this.password});

  Response.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
