
import 'dart:convert';

AudiobookCategoryGetAllActiveByLocale AudiobookCategoryGetAllActiveByLocaleFromJson(String str) =>
    AudiobookCategoryGetAllActiveByLocale.fromJson(json.decode(str));

class AudiobookCategoryGetAllActiveByLocale {
  List<Response>? response;

  AudiobookCategoryGetAllActiveByLocale({this.response});

  AudiobookCategoryGetAllActiveByLocale.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
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
  String? icon;
  String? name;
  String? sortorder;

  Response({this.id, this.icon, this.name, this.sortorder});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    name = json['name'];
    sortorder = json['sortorder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['sortorder'] = this.sortorder;
    return data;
  }
}