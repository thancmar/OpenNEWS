import 'dart:convert';

MagazinePublishedGetAllLastByHotspotId
    MagazinePublishedGetLastWithLimitFromJson(String str) =>
        MagazinePublishedGetAllLastByHotspotId.fromJson(json.decode(str));

class MagazinePublishedGetAllLastByHotspotId {
  List<ResponseMagazine>? response;

  MagazinePublishedGetAllLastByHotspotId({required this.response});

  MagazinePublishedGetAllLastByHotspotId.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <ResponseMagazine>[];
      json!['response'].forEach((v) {
        response!.add(ResponseMagazine.fromJson(v));
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

  class ResponseMagazine {
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

  ResponseMagazine(
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

  ResponseMagazine.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    idPublisher = json['id_publisher'];
    idMagazineType = json['id_magazine_type'];
    singlePageOnly = json['single_page_only'];
    magazineLanguage = json['magazine_language'];
    idsMagazineCategory = json['ids_magazine_category'];
    // idMagazinePublication = (int.parse(json['id_magazine_publication'] ?? 0));
    idMagazinePublication = json['id_magazine_publication'];
    idMagazine = json['id_magazine'];
    dateOfPublication = json['date_of_publication'];
    // pageMax = (int.parse(json['page_max'] ?? 0));
    pageMax = json['page_max'];
    advertisement = json['advertisement'];
    coverUrl = json['cover_url'];
    // name = json['name'] ?? '';
    // idPublisher = json['id_publisher'] ?? '';
    // idMagazineType = json['id_magazine_type'] ?? '';
    // singlePageOnly = json['single_page_only'] ?? true;
    // magazineLanguage = json['magazine_language'] ?? '';
    // idsMagazineCategory = json['ids_magazine_category'] ?? '';
    // // idMagazinePublication = (int.parse(json['id_magazine_publication'] ?? 0));
    // idMagazinePublication = json['id_magazine_publication'] ?? '';
    // idMagazine = json['id_magazine'] ?? '';
    // dateOfPublication = json['date_of_publication'] ?? '';
    // // pageMax = (int.parse(json['page_max'] ?? 0));
    // pageMax = json['page_max'] ?? '';
    // advertisement = json['advertisement'] ?? true;
    // coverUrl = json['cover_url'] ?? '';
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