import 'dart:convert';

import 'magazinePublishedGetAllLastByHotspotId_model.dart';


EbooksForLocationGetAllActive EbooksForLocationGetAllActiveFromJson(String str) =>
    EbooksForLocationGetAllActive.fromJson(json.decode(str));

class EbooksForLocationGetAllActive extends BaseResponse {
  List<ResponseEbook>? _response;


  EbooksForLocationGetAllActive({List<ResponseEbook>? response})
      : _response = response;

  @override
  List<ResponseEbook>? response() {
    return _response;
  }

  EbooksForLocationGetAllActive.fromJson(Map<String, dynamic> json) {
    // if (json['response'] != null) {
    //   response = new List<Response>();
    //   json['response'].forEach((v) {
    //     response.add(new Response.fromJson(v));
    //   });
    // }
    if (json['response'] != null) {
      // response = (json['response'] as List)
      //     .map((v) => Response.fromJson(v as Map<String, dynamic>))
      //     .toList();
      _response = <ResponseEbook>[];
      json['response'].forEach((v) {
        _response!.add(ResponseEbook.fromJson(v));
      });
    } else {
      null;
      // "fdgsbfsdbv ";
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.response != null) {
  //     data['response'] = this.response.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this._response != null) {
      data['response'] = this._response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseEbook {
  String? id;
  String? title;
  String? description;
  String? author;
  String? idPublisher;
  String? ebookLanguage;
  String? filepath;
  String? idsEbookCategory;
  String? dateOfPublication;
  String? pageMax;

  ResponseEbook(
      {this.id,
        this.title,
        this.description,
        this.author,
        this.idPublisher,
        this.ebookLanguage,
        this.filepath,
        this.idsEbookCategory,
        this.dateOfPublication,
        this.pageMax});

  ResponseEbook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    author = json['author'];
    idPublisher = json['id_publisher'];
    ebookLanguage = json['ebook_language'];
    filepath = json['filepath'];
    idsEbookCategory = json['ids_ebook_category'];
    dateOfPublication = json['date_of_publication'];
    pageMax = json['page_max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['author'] = this.author;
    data['id_publisher'] = this.idPublisher;
    data['ebook_language'] = this.ebookLanguage;
    data['filepath'] = this.filepath;
    data['ids_ebook_category'] = this.idsEbookCategory;
    data['date_of_publication'] = this.dateOfPublication;
    data['page_max'] = this.pageMax;
    return data;
  }
}