import 'dart:convert';

Registrierung RegistrierungFromJson(String str) {
  try {
    // Decoding the JSON string. If 'str' is empty or invalid, it won't throw an exception here.
    return Registrierung.fromJson(json.decode(str));
  } catch (e) {
    // If an exception occurs (like badly formed JSON), you'll just return a default Registrierung object.
    return Registrierung();
  }
}

class Registrierung {
  String? response;

  Registrierung({this.response});

  factory Registrierung.fromJson(Map<String, dynamic> json) {
    // Checking if 'response' is in the JSON map and is not empty, otherwise providing a default value.
    return Registrierung(
      response: (json['response'] is String && json['response'].isNotEmpty) ? json['response'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (response != null) {
      // Only include 'response' in the map if it's not null.
      data['response'] = this.response;
    }
    return data;
  }
}