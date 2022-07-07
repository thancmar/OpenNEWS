import 'dart:convert';

MagazinePublishedGetLastWithLimit MagazinePublishedGetLastWithLimitFromJson(
        String str) =>
    MagazinePublishedGetLastWithLimit.fromJson(json.decode(str));

class MagazinePublishedGetLastWithLimit {
  List<Response>? response;

  MagazinePublishedGetLastWithLimit({required this.response});

  MagazinePublishedGetLastWithLimit.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(Response.fromJson(v));
      });
    } else {
      " ";
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
  String? name;
  String? idPublisher;
  String? idMagazineType;
  bool? singlePageOnly;
  String? magazineLanguage;
  String? idsMagazineCategory;
  String? idMagazinePublication;
  String? idMagazine;
  String? dateOfPublication;
  String? pageMax;
  bool? advertisement;
  String? coverUrl;

  Response(
      {this.name,
      this.idPublisher,
      this.idMagazineType,
      this.singlePageOnly,
      this.magazineLanguage,
      this.idsMagazineCategory,
      this.idMagazinePublication,
      this.idMagazine,
      this.dateOfPublication,
      this.pageMax,
      this.advertisement,
      this.coverUrl});

  Response.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';

    idPublisher = json['id_publisher'] ?? '';
    idMagazineType = json['id_magazine_type'] ?? '';
    singlePageOnly = json['single_page_only'] ?? true;
    magazineLanguage = json['magazine_language'] ?? '';
    idsMagazineCategory = json['ids_magazine_category'] ?? '';
    idMagazinePublication = json['id_magazine_publication'] ?? '';
    idMagazine = json['id_magazine'] ?? '';
    dateOfPublication = json['date_of_publication'] ?? '';
    pageMax = json['page_max'] ?? '';
    advertisement = json['advertisement'] ?? true;
    coverUrl = json['cover_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id_publisher'] = this.idPublisher;
    data['id_magazine_type'] = this.idMagazineType;
    data['single_page_only'] = this.singlePageOnly;
    data['magazine_language'] = this.magazineLanguage;
    data['ids_magazine_category'] = this.idsMagazineCategory;
    data['id_magazine_publication'] = this.idMagazinePublication;
    data['id_magazine'] = this.idMagazine;
    data['date_of_publication'] = this.dateOfPublication;
    data['page_max'] = this.pageMax;
    data['advertisement'] = this.advertisement;
    data['cover_url'] = this.coverUrl;
    return data;
  }
}
