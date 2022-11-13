import 'dart:convert';

Localization LocalizationFromJson(String str) => Localization.fromJson(json.decode(str));
// Data DataFromJson(String str) => Data.fromJson(json.decode(str));

class Localization {
  int? code;
  String? msg;
  late List<Data> data = <Data>[];

  Localization({this.code, this.msg, required this.data});

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
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    } else {
      null;
    }
  }
  // factory Localization.fromJson(Map<String, dynamic> json) => new Localization(
  //       code: json['code'],
  //       msg: json['msg'],
  //       data: Data.fromJson(json['data']),
  //     );
  // factory Localization.fromJson(Map<String, dynamic> json) {
  //   var list = json['data'] as List;
  //   print(list.runtimeType);
  //   List<Data> imagesList = list.map((i) => Data.fromJson(i)).toList();
  //   print("imagesList");
  //   print(imagesList[0]);
  //
  //   return Localization(code: json['code'], msg: json['msg'], data: imagesList);
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['code'] = this.code;
  //   data['msg'] = this.msg;
  //   if (this.data != null) {
  //     data['data'] = this.data!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Data {
  String? idLocation;
  String? nameApp;
  String? device;
  String? hasEbooksAudiobooks;

  Data({this.idLocation, this.nameApp, this.device, this.hasEbooksAudiobooks});

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
  Data.fromJson(Map<String, dynamic> json) {
    idLocation = json['id_location'] ?? '';
    nameApp = json['name_app'] ?? '';
    device = json['device'] ?? '';
    hasEbooksAudiobooks = json['has_ebooks_audiobooks'] ?? '';
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