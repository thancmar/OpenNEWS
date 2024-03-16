
import 'dart:convert';

import 'magazinePublishedGetAllLastByHotspotId_model.dart';


AudioBooksForLocationGetAllActive GetAllActiveAudioBooksForLocationFromJson(String str) =>
    AudioBooksForLocationGetAllActive.fromJson(json.decode(str));

class AudioBooksForLocationGetAllActive extends BaseResponse{
  List<ResponseAudioBook>? _response;

  AudioBooksForLocationGetAllActive({List<ResponseAudioBook>? response}): _response = response;

  @override
  List<ResponseAudioBook>? response() {
    return _response;
  }
  AudioBooksForLocationGetAllActive.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      _response = <ResponseAudioBook>[];
      json['response'].forEach((v) {
        _response!.add(new ResponseAudioBook.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._response != null) {
      data['response'] = this._response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseAudioBook {
  String? id;
  String? ean;
  String? title;
  String? subtitle;
  String? description;
  String? author;
  String? narrator;
  String? idPublisher;
  String? audiobookLanguage;
  String? dateOfPublication;
  String? runtime;
  String? idsAudiobookCategory;

  ResponseAudioBook(
      {this.id,
        this.ean,
        this.title,
        this.subtitle,
        this.description,
        this.author,
        this.narrator,
        this.idPublisher,
        this.audiobookLanguage,
        this.dateOfPublication,
        this.runtime,
        this.idsAudiobookCategory});

  ResponseAudioBook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ean = json['ean'];
    title = json['title'];
    subtitle = json['subtitle'];
    description = json['description'];
    author = json['author'];
    narrator = json['narrator'];
    idPublisher = json['id_publisher'];
    audiobookLanguage = json['audiobook_language'];
    dateOfPublication = json['date_of_publication'];
    runtime = json['runtime'];
    idsAudiobookCategory = json['ids_audiobook_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ean'] = this.ean;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['description'] = this.description;
    data['author'] = this.author;
    data['narrator'] = this.narrator;
    data['id_publisher'] = this.idPublisher;
    data['audiobook_language'] = this.audiobookLanguage;
    data['date_of_publication'] = this.dateOfPublication;
    data['runtime'] = this.runtime;
    data['ids_audiobook_category'] = this.idsAudiobookCategory;
    return data;
  }
}