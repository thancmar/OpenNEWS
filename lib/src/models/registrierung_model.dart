import 'dart:convert';

Registrierung RegistrierungFromJson(String str) =>
    Registrierung.fromJson(json.decode(str));

class Registrierung {
  bool? response;

  Registrierung({this.response});

  Registrierung.fromJson(Map<String, dynamic> json) {
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    return data;
  }
}
