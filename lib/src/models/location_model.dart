import 'dart:convert';

Localization LocalizationFromJson(String str) =>
    Localization.fromJson(json.decode(str));
// Data DataFromJson(String str) => Data.fromJson(json.decode(str));

class Localization {
  int? code;
  String? msg;
  List<LocationData>? data = <LocationData>[];

  Localization({this.code, this.msg, this.data});

  // Localization.fromJson(Map<String, dynamic> json) {
  //   code = json['code'];
  //   msg = json['msg'];
  //
  //   if (json['data'] != null) {
  //     // data = <Data>[];
  //
  //     json['data'].forEach((v) {
  //       data!.add(new Data.fromJson(v));
  //     });
  //     print("123456789");
  //   }
  // }
  Localization.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    // if (json['data'] != null) {
    //   data = <Data>[];
    //   json['data'].forEach((v) {
    //     data!.add(new Data.fromJson(v));
    //   });
    // } else {
    //   null;
    // }
    json['data'].forEach((v) {
      data!.add(new LocationData.fromJson(v));
    });
  }

}

class LocationData {
  String? idLocation;
  String? nameApp;
  String? device;
  String? hasEbooksAudiobooks;
  String? token;
  String? applied_at;
  String? expiration;



  LocationData({this.idLocation, this.nameApp, this.device, this.hasEbooksAudiobooks, this.token, this.applied_at, this.expiration});

  // Data.fromJson(Map<String, dynamic> json) {
  //   idLocation = json['id_location'];
  //   nameApp = json['name_app'];
  //   device = json['device'];
  //   hasEbooksAudiobooks = json['has_ebooks_audiobooks'];
  // }

  // factory Data.fromJson(Map<String, dynamic> json) => new Data(
  //       idLocation: json['id_location'],
  //       nameApp: json['name_app'],
  //       device: json['device'],
  //       hasEbooksAudiobooks: json['has_ebooks_audiobooks'],
  //     );
  LocationData.fromJson(Map<String, dynamic> json) {
    idLocation = json['id_location'] ?? '';
    nameApp = json['name_app'] ?? '';
    device = json['device'] ?? '';
    hasEbooksAudiobooks = json['has_ebooks_audiobooks'] ?? '';
    token = json['token'] ?? '';
    applied_at = json['applied_at'] ?? '';
    expiration = json['expiration'] ?? '';


  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id_location'] = this.idLocation;
  //   data['name_app'] = this.nameApp;
  //   data['device'] = this.device;
  //   data['has_ebooks_audiobooks'] = this.hasEbooksAudiobooks;
  //   return data;
  // }
}