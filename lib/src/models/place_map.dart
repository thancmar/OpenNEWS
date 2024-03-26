import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place with ClusterItem {
  final String id;
  final String nameApp;
  final String type;
  final String addressStreet;
  final String addressHouseNr;
  final String addressZip;
  final String addressCity;
  final double latitude;
  final double longitude;

  Place(
      {required this.id,
      required this.nameApp,
      required this.type,
      required this.addressStreet,
      required this.addressHouseNr,
      required this.addressZip,
      required this.addressCity,
      required this.latitude,
      required this.longitude});

  @override
  LatLng get location => LatLng(latitude, longitude);

}