import 'dart:convert';

HotspotsGetAllActive HotspotsGetAllActiveFromJson(String str) =>
    HotspotsGetAllActive.fromJson(json.decode(str));

class HotspotsGetAllActive {
  List<Response>? response;

  HotspotsGetAllActive({this.response});

  HotspotsGetAllActive.fromJson(Map<String, dynamic> json) {
    // print(json['response']);
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(Response.fromJson(v));
      });
      // if (json['response'] != null) {
      //   response = [Response.fromJson(json['response'])];
      // }
    }
    // else {
    //   null;
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? id;
  String? nameApp;
  String? type;
  String? addressStreet;
  String? addressHouseNr;
  String? addressZip;
  String? addressCity;
  String? latitude;
  String? longitude;
  String? radius;
  String? bssids;
  String? beacons;

  Response(
      {this.id,
      this.nameApp,
      this.type,
      this.addressStreet,
      this.addressHouseNr,
      this.addressZip,
      this.addressCity,
      required this.latitude,
      required this.longitude,
      this.radius,
      this.bssids,
      this.beacons});

  Response.fromJson(Map<String, dynamic> json) {
    // id = json['id'] ?? '';
    // nameApp = json['name_app'] ?? '';
    // type = json['type'] ?? '';
    // addressStreet = json['address_street'] ?? '';
    // addressHouseNr = json['address_house_nr'] ?? '';
    // addressZip = json['address_zip'] ?? '';
    // addressCity = json['address_city'] ?? '';
    // latitude = double.tryParse(json['latitude']);
    // longitude = double.tryParse(json['longitude']);
    // radius = json['radius'] ?? '';
    // bssids = json['bssids'] ?? '';
    // beacons = json['beacons'] ?? '';
    id = json['id'];
    nameApp = json['name_app'];
    type = json['type'];
    addressStreet = json['address_street'];
    addressHouseNr = json['address_house_nr'];
    addressZip = json['address_zip'];
    addressCity = json['address_city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
    bssids = json['bssids'];
    beacons = json['beacons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_app'] = this.nameApp;
    data['type'] = this.type;
    data['address_street'] = this.addressStreet;
    data['address_house_nr'] = this.addressHouseNr;
    data['address_zip'] = this.addressZip;
    data['address_city'] = this.addressCity;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['radius'] = this.radius;
    data['bssids'] = this.bssids;
    data['beacons'] = this.beacons;
    return data;
  }
}