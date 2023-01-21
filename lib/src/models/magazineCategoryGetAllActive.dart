import 'dart:convert';
import 'dart:typed_data';

MagazineCategoryGetAllActive MagazineCategoryGetAllActiveFromJson(String str) => MagazineCategoryGetAllActive.fromJson(json.decode(str));

class MagazineCategoryGetAllActive {
  List<Response>? response;

  MagazineCategoryGetAllActive({required this.response});

  MagazineCategoryGetAllActive.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(Response.fromJson(v));
      });
    } else {
      null;
      // "fdgsbfsdbv ";
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
  String? name;
  String? image;

  Response({
    this.id,
    this.name,
    this.image,
  });

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.name;
    data['name'] = this.name;
    data['image'] = this.image;

    return data;
  }
}