import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
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

// class HotspotforMap with ClusterItem {
//   final String id;
//   final String nameApp;
//   final String type;
//   final String addressStreet;
//   final String addressHouseNr;
//   final String addressZip;
//   final String addressCity;
//   final double latitude;
//   final double longitude;
//
//   HotspotforMap(
//     this.id,
//     this.nameApp,
//     this.type,
//     this.addressStreet,
//     this.addressHouseNr,
//     this.addressZip,
//     this.addressCity,
//     this.latitude,
//     this.longitude,
//   );
//
//   @override
//   LatLng get location => LatLng(latitude, longitude);
// }
