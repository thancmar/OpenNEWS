import 'dart:convert';

LocationOffers LocationOffersFromJson(String str) => LocationOffers.fromJson(json.decode(str));

class LocationOffers {
  List<LocationOffer>? locationOffer;

  LocationOffers({required this.locationOffer});

  // LocationOffers.fromJson(Map<String, dynamic> json) {
  LocationOffers.fromJson(List<dynamic> json) {
    if (json != null) {
      locationOffer = <LocationOffer>[];
      json!.forEach((v) {
        locationOffer!.add(LocationOffer.fromJson(v));
      });
    } else {
      null;
      // "fdgsbfsdbv ";
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //
  //   if (this.response != null) {
  //     data['response'] = this.response!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class LocationOffer {
  int? id;
  int? order;
  int? idLocation;
  int? idOffer;
  int? status;
  List<Shm2Offer>? shm2Offer;

  LocationOffer({this.id, this.order, this.idLocation, this.idOffer, this.status, this.shm2Offer});

  LocationOffer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    order = json['order'];
    idLocation = int.parse(json['id_location'].toString());
    idOffer = json['id_offer'];
    status = json['status'];
    if (json['shm2_offer'] != null) {
      shm2Offer = <Shm2Offer>[];
      json['shm2_offer'].forEach((v) {
        shm2Offer!.add(new Shm2Offer.fromJson(v));
      });
    } else {
      null;
      // "fdgsbfsdbv ";
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['order'] = this.order;
  //   data['id_location'] = this.idLocation;
  //   data['id_offer'] = this.idOffer;
  //   data['status'] = this.status;
  //   if (this.shm2Offer != null) {
  //     data['shm2_offer'] = this.shm2Offer!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Shm2Offer {
  int? id;
  String? title;
  String? longDesc;
  String? shortDesc;
  String? type;
  String? data;
  String? url;
  String? urlTitle;
  int? orientation;
  String? publicationBegin;
  String? publicationEnd;
  String? creationDate;
  String? lastChange;

  Shm2Offer(
      {this.id,
      this.title,
      this.longDesc,
      this.shortDesc,
      this.type,
      this.data,
      this.url,
      this.urlTitle,
      this.orientation,
      this.publicationBegin,
      this.publicationEnd,
      this.creationDate,
      this.lastChange});

  Shm2Offer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    longDesc = json['longDesc'];
    shortDesc = json['shortDesc'];
    type = json['type'];
    data = json['data'];
    url = json['url'];
    urlTitle = json['urlTitle'];
    orientation = json['orientation'];
    publicationBegin = json['publication_begin'];
    publicationEnd = json['publication_end'];
    creationDate = json['creation_date'];
    lastChange = json['last_change'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['title'] = this.title;
  //   data['longDesc'] = this.longDesc;
  //   data['shortDesc'] = this.shortDesc;
  //   data['type'] = this.type;
  //   data['data'] = this.data;
  //   data['url'] = this.url;
  //   data['urlTitle'] = this.urlTitle;
  //   data['orientation'] = this.orientation;
  //   data['publication_begin'] = this.publicationBegin;
  //   data['publication_end'] = this.publicationEnd;
  //   data['creation_date'] = this.creationDate;
  //   data['last_change'] = this.lastChange;
  //   return data;
  // }
}