import 'dart:convert';

GetUserDetails GetUserDetailsFromJson(String str) => GetUserDetails.fromJson(json.decode(str));

class GetUserDetails {
  Response? response;

  GetUserDetails({this.response});

  GetUserDetails.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null ? new Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  String? id;
  String? email;
  String? firstname;
  String? lastname;
  String? dateOfBirth;
  String? sex;
  String? addressStreet;
  String? addressHouseNr;
  String? addressZip;
  String? addressCity;
  String? phone;
  String? iban;
  String? accountOwner;
  String? creationDate;
  String? lastLogin;
  String? status;

  Response(
      {this.id,
      this.email,
      this.firstname,
      this.lastname,
      this.dateOfBirth,
      this.sex,
      this.addressStreet,
      this.addressHouseNr,
      this.addressZip,
      this.addressCity,
      this.phone,
      this.iban,
      this.accountOwner,
      this.creationDate,
      this.lastLogin,
      this.status});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    dateOfBirth = json['date_of_birth'];
    sex = json['sex'];
    addressStreet = json['address_street'];
    addressHouseNr = json['address_house_nr'];
    addressZip = json['address_zip'];
    addressCity = json['address_city'];
    phone = json['phone'];
    iban = json['iban'];
    accountOwner = json['account_owner'];
    creationDate = json['creation_date'];
    lastLogin = json['last_login'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['date_of_birth'] = this.dateOfBirth;
    data['sex'] = this.sex;
    data['address_street'] = this.addressStreet;
    data['address_house_nr'] = this.addressHouseNr;
    data['address_zip'] = this.addressZip;
    data['address_city'] = this.addressCity;
    data['phone'] = this.phone;
    data['iban'] = this.iban;
    data['account_owner'] = this.accountOwner;
    data['creation_date'] = this.creationDate;
    data['last_login'] = this.lastLogin;
    data['status'] = this.status;
    return data;
  }
}