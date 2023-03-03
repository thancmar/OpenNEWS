import 'dart:convert';

LocationGetHeader LocationGetHeaderFromJson(String str) => LocationGetHeader.fromJson(json.decode(str));

class LocationGetHeader {
  int? id;
  String? welcomeText;
  String? text;
  String? filePath;
  String? creationDate;
  String? lastChange;
  String? titleColor;
  int? titleVisible;
  int? blurVisible;

  LocationGetHeader({this.id, this.welcomeText, this.text, this.filePath, this.creationDate, this.lastChange, this.titleColor, this.titleVisible, this.blurVisible});

  LocationGetHeader.fromJson(Map<dynamic, dynamic> json) {
    // id = int.tryParse(json['id']);
    id = json['id'];
    welcomeText = json['welcomeText'];
    text = json['text'];
    filePath = json['filePath'];
    creationDate = json['creation_date'];
    lastChange = json['last_change'];
    titleColor = json['titleColor'];
    // titleVisible = int.tryParse(json['titleVisible']);
    titleVisible = json['titleVisible'];
    // blurVisible = int.tryParse(json['blurVisible']);
    blurVisible = json['blurVisible'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['welcomeText'] = this.welcomeText;
  //   data['text'] = this.text;
  //   data['filePath'] = this.filePath;
  //   data['creation_date'] = this.creationDate;
  //   data['last_change'] = this.lastChange;
  //   data['titleColor'] = this.titleColor;
  //   data['titleVisible'] = this.titleVisible;
  //   data['blurVisible'] = this.blurVisible;
  //   return data;
  // }
}