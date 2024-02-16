import 'dart:convert';


EbooksForLocationGetAllActive EbooksForLocationGetAllActiveFromJson(String str) =>
    EbooksForLocationGetAllActive.fromJson(json.decode(str));

class EbooksForLocationGetAllActive {
  List<Response>? response;

  EbooksForLocationGetAllActive({required this.response});

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
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(Response.fromJson(v));
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

    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
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

  Response(
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

  Response.fromJson(Map<String, dynamic> json) {
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