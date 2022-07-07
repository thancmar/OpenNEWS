import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:sharemagazines_flutter/src/blocs/map_bloc.dart';
import 'package:sharemagazines_flutter/src/models/hotspots_model.dart';
import 'package:sharemagazines_flutter/src/resources/auth_repository.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/place_map.dart';

class MapsBlocWidget extends StatelessWidget {
  MapBloc _bloc = MapBloc(
    hotspotRepository: HotspotRepository(),
  );
  @override
  Widget build(BuildContext context) {
    // Future<HotspotsGetAllActive>hp = RepositoryProvider.of<HotspotRepository>(context);
    return BlocProvider.value(
      value: _bloc,
      child: Maps(),
    );
  }
}

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late GoogleMapController mapController;
  var repo = HotspotRepository();
  late Future<HotspotsGetAllActive> hp;
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late List<Place>? hpList = [];
  Set<Marker> markers = Set(); //markers for google map
  List<Marker> myMarkers = <Marker>[];
  late ClusterManager manager;
  Completer<GoogleMapController> _controller = Completer();
  String location = "Search Location";
  late bool showlocationdetail = false;
  late Place locationmarker;

  final LatLng _center = const LatLng(51.1657, 10.4515);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // var markerIdVal = MyWayToGenerateId();
    // final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER

    // final Marker marker = Marker(
    //   markerId: MarkerId('place_name'),
    //   position: LatLng(
    //     53.5511,
    //     9.9937,
    //   ),
    //   infoWindow: InfoWindow(title: "markerIdVal", snippet: '*'),
    //   // onTap: () {
    //   //   _onMarkerTapped(markerId);
    //   // },
    // );

    // hp.then((data) {
    //   print("hp");
    //   var len = data.response?.length;
    //   for (int i = 0; i < len!; i++) {
    //     // final temp = HotspotforMap(
    //     //   data.response![i].id!,
    //     //   data.response![i].nameApp!,
    //     //   data.response![i].type!,
    //     //   data.response![i].addressCity!,
    //     //   data.response![i].addressHouseNr!,
    //     //   data.response![i].addressZip!,
    //     //   data.response![i].addressZip!,
    //     //   data.response![i].latitude!,
    //     //   data.response![i].longitude!,
    //     // );
    //     final temp = Place(
    //         id: data.response![i].id!,
    //         nameApp: data.response![i].nameApp!,
    //         type: data.response![i].type!,
    //         addressStreet: data.response![i].addressCity!,
    //         addressHouseNr: data.response![i].addressHouseNr!,
    //         addressZip: data.response![i].addressZip!,
    //         addressCity: data.response![i].addressCity!,
    //         latitude: data.response![i].latitude!,
    //         longitude: data.response![i].longitude!);
    //     hpList?.add(temp);
    //
    //     print("mark");
    //   }
    //   print("something");
    //   // adding a new marker to map
    //   // markers[MarkerId('place_name')] = marker;
    //   hpList?.forEach((element) {
    //     myMarkers.add(Marker(
    //         markerId: MarkerId(element.nameApp),
    //         position: LatLng(element.latitude, element.longitude),
    //         infoWindow: InfoWindow(title: element.nameApp)));
    //     print("finished");
    //   });
    //   print("done");
    //
    //   setState(() {});
    //
    //   // print(markers);
    //   // print(hpList);
    // }, onError: (e) {
    //   print("fsadfs");
    //   print(e);
    // });
  }

  @override
  void initState() {
    // TODO: implement initState

    // _bloc = BlocProvider.of<MapBloc>(context);
    BlocProvider.of<MapBloc>(context).add(Initialize());
    hp = RepositoryProvider.of<HotspotRepository>(context)
        .GetAllActiveHotspots();

    hp.then((data) {
      print("hp");
      var len = data.response?.length;
      for (int i = 0; i < len!; i++) {
        // final temp = HotspotforMap(
        //   data.response![i].id!,
        //   data.response![i].nameApp!,
        //   data.response![i].type!,
        //   data.response![i].addressCity!,
        //   data.response![i].addressHouseNr!,
        //   data.response![i].addressZip!,
        //   data.response![i].addressZip!,
        //   data.response![i].latitude!,
        //   data.response![i].longitude!,
        // );
        final temp = Place(
            id: data.response![i].id!,
            nameApp: data.response![i].nameApp!,
            type: data.response![i].type!,
            addressStreet: data.response![i].addressStreet!,
            addressHouseNr: data.response![i].addressHouseNr!,
            addressZip: data.response![i].addressZip!,
            addressCity: data.response![i].addressCity!,
            latitude: data.response![i].latitude!,
            longitude: data.response![i].longitude!);
        hpList?.add(temp);

        print("mark");
      }
      print("something");
      // adding a new marker to map
      // markers[MarkerId('place_name')] = marker;
      hpList?.forEach((element) {
        myMarkers.add(Marker(
            markerId: MarkerId(element.nameApp),
            position: LatLng(element.latitude, element.longitude),
            infoWindow: InfoWindow(title: element.nameApp)));

        print("finished");
      });
      manager.updateMap.call();

      // manager.addItem(Place(id: id, nameApp: nameApp, type: type, addressStreet: addressStreet, addressHouseNr: addressHouseNr, addressZip: addressZip, addressCity: addressCity, latitude: latitude, longitude: longitude));
      // manager.onCameraMove;

      // setState(() {});

      // print(markers);
      // print(hpList);
    }, onError: (e) {
      print("fsadfs");
      print(e);
    });

    addMarkers() async {
      BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/bike.png",
      );
    }

    manager = _initClusterManager();
    super.initState();
  }

  ClusterManager _initClusterManager() {
    print("something2");
    return ClusterManager<Place>(
      hpList!,
      _updateMarkers,
      markerBuilder: _markerBuilder,
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        GoogleMap(
          // onMapCreated: _onMapCreated,
          zoomGesturesEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            manager.setMapId(controller.mapId);
          },
          onCameraMove: manager.onCameraMove,
          onCameraIdle: manager.updateMap,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 6.0,
          ),
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          // markers: Set<Marker>.from(myMarkers),
          markers: markers,
          onTap: (LatLng point) {
            setState(() {
              showlocationdetail = false;
            });
          },
          zoomControlsEnabled: true,

          // markers: Set<Marker>.of(markers.values),
        ),
        SafeArea(
          child: Align(
              //search input bar
              alignment: Alignment.topCenter,
              child: InkWell(

                  // focusColor: Colors.red,

                  onTap: () async {
                    var place = await PlacesAutocomplete.show(
                        // decoration: BoxDecoration(
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.grey.withOpacity(0.1),
                        //         spreadRadius: 1,
                        //         blurRadius: 0,
                        //         // offset: Offset(0, 3), // changes position of shadow
                        //       ),
                        //     ],
                        //     color: Colors.lightBlue,
                        //     border: Border.all(
                        //       // color: Colors.red,
                        //     ),
                        //     borderRadius: BorderRadius.circular(15)),
                        radius: 10000,
                        context: context,
                        apiKey: "AIzaSyB4CAZ-Q37WtAXEwX_dTMX4nYvKPsMfswY",
                        mode: Mode.overlay,
                        types: [],
                        strictbounds: false,
                        components: [Component(Component.country, 'de')],
                        //google_map_webservice package
                        onError: (err) {
                          print("error");
                          print(err);
                        });
                    print("place");
                    if (place != null) {
                      setState(() {
                        location = place.description.toString();
                      });

                      //form google_maps_webservice package
                      final plist = GoogleMapsPlaces(
                        apiKey: "AIzaSyB4CAZ-Q37WtAXEwX_dTMX4nYvKPsMfswY",
                        apiHeaders: await GoogleApiHeaders().getHeaders(),
                        //from google_api_headers package
                      );
                      String placeid = place.placeId ?? "0";
                      final detail = await plist.getDetailsByPlaceId(placeid);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lang = geometry.location.lng;
                      var newlatlang = LatLng(lat, lang);
                      // var newlatlang = LatLng(51.00, 10.00);

                      //move map camera to selected place with animation
                      mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: newlatlang, zoom: 17)));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              // spreadRadius: 7,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width - 40,
                        child: ListTile(
                          title: Text(
                            location,
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: Icon(Icons.location_searching),
                          dense: true,
                        )),
                  ))),
        ),
        // showlocationdetail == true
        //     ? Positioned(bottom: 90, child: _buildlocationcard())
        //     : Container()
        showlocationdetail == true
            ? Align(
                alignment: Alignment.bottomCenter,
                child: _buildlocationcard(),
              )
            : Container()
      ]),
    );
  }

  _buildlocationcard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 110),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            // leading: Icon(Icons.album),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
              child: Text(
                locationmarker.nameApp,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(locationmarker.addressStreet +
                  " " +
                  locationmarker.addressHouseNr +
                  ",\n" +
                  locationmarker.addressZip +
                  " " +
                  locationmarker.addressCity),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    // gradient: LinearGradient(
                    //   colors: <Color>[
                    //     Color(0xFF0D47A1),
                    //     Color(0xFF1976D2),
                    //     Color(0xFF42A5F5),
                    //   ],
                    // ),
                  ),
                  child: TextButton(
                    child: const Text('Angebote'),
                    onPressed: () {/* ... */},
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    // gradient: LinearGradient(
                    //   colors: <Color>[
                    //     Color(0xFF0D47A1),
                    //     Color(0xFF1976D2),
                    //     Color(0xFF42A5F5),
                    //   ],
                    // ),
                  ),
                  child: TextButton(
                    child: Icon(Icons.directions),
                    onPressed: () {/* ... */},
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> animateTo(double lat, double lng) async {
    print("Future");
    final c = await _controller.future;
    double zoomlevel = await mapController.getZoomLevel() * 1.2;
    print(zoomlevel);
    final p = CameraPosition(target: LatLng(lat, lng), zoom: zoomlevel);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        mapController = await _controller.future;
        Completer<GoogleMapController> completer = Completer();

        return Marker(
            markerId: MarkerId(cluster.getId()),
            position: cluster.location,
            onTap: () {
              if (cluster.isMultiple == true) {
                print("len");
                setState(() {
                  print(cluster.location);
                  animateTo(
                      cluster.location.latitude, cluster.location.longitude);
                  showlocationdetail = false;
                });
              } else {
                print("len2");
                // setState(() {
                //   print(cluster.location);
                //   animateTo(cluster.items.first.location.latitude,
                //       cluster.items.first.location.longitude);
                // });
                setState(() {
                  print(cluster.items.first.addressStreet);
                  locationmarker = cluster.items.first;
                  showlocationdetail = true;
                });
              }
            },
            icon: cluster.isMultiple == true
                ? await _getMarkerBitmap(125, text: cluster.count.toString())
                : cluster.items.first.type! == 1
                    ? await getBitmapDescriptorFromSVGAsset(
                        context,
                        "assets/images/pins.svg",
                      )
                    : cluster.items.first.type! == 2
                        ? await getBitmapDescriptorFromSVGAsset(
                            context,
                            "assets/images/pins-2.svg",
                          )
                        : await getBitmapDescriptorFromSVGAsset(
                            context,
                            "assets/images/pins-3.svg",
                          )
            // icon: cluster.isMultiple == true
            //     ? await _getMarkerBitmap(125, text: cluster.count.toString())
            //     : await getBitmapDescriptorFromSVGAsset(
            //         context,
            //         "assets/images/pins.svg",
            //       )

            // icon: await _getMarkerBitmap(q ? 125 : 75,
            //     text: cluster.isMultiple ? cluster.count.toString() : null),
            );
      };
}

// Future<BitmapDescriptor> _getMarkerBitmapHotspot(int size,
//     {String? text}) async {
//   if (kIsWeb) size = (size / 2).floor();
//
//   final PictureRecorder pictureRecorder = PictureRecorder();
//   final Canvas canvas = Canvas(pictureRecorder);
//   final Paint paint1 = Paint()..color = Colors.white;
//   final Paint paint2 = Paint()..color = Colors.blue;
//   // print("map");
//   // final Paint paint2 = Paint()..color = size > 10 ? Colors.blue : Colors.red;
//   canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
//   canvas.drawCircle(Offset(size / 2, size / 2), size / 2.4, paint2);
//   // canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);
//
//   if (text != null) {
//     TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
//     painter.text = TextSpan(
//       text: text,
//       style: TextStyle(
//           fontSize: size / 3,
//           color: Colors.white,
//           fontWeight: FontWeight.normal),
//     );
//     painter.layout();
//     painter.paint(
//       canvas,
//       Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
//     );
//   }
//
//   final img = await pictureRecorder.endRecording().toImage(size, size);
//   final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;
//
//   return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
// }

Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
  if (kIsWeb) size = (size / 2).floor();

  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  print(text);
  final Paint paint1 = Paint()
    ..color = int.parse(text!) < 10
        ? Colors.blue.withOpacity(0.4)
        : Colors.purple.withOpacity(0.4);
  final Paint paint2 = Paint()
    ..color = int.parse(text!) < 10 ? Colors.blue : Colors.purple;

  canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
  canvas.drawCircle(Offset(size / 2, size / 2), size / 2.6, paint2);
  // canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

  if (text != null) {
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(
          fontSize: size / 3,
          color: Colors.white,
          fontWeight: FontWeight.normal),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
    );
  }

  final img = await pictureRecorder.endRecording().toImage(size, size);
  final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

  return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
}

Future<BitmapDescriptor> getBitmapDescriptorFromSVGAsset(
  BuildContext context,
  String svgAssetLink, {
  Size size = const Size(60, 60),
}) async {
  String svgString = await DefaultAssetBundle.of(context).loadString(
    svgAssetLink,
  );
  final drawableRoot = await svg.fromSvgString(
    svgString,
    'debug: $svgAssetLink',
  );
  final ratio = window.devicePixelRatio.ceil();
  final width = size.width.ceil() * ratio;
  final height = size.height.ceil() * ratio;
  final picture = drawableRoot.toPicture(
    size: Size(
      width.toDouble(),
      height.toDouble(),
    ),
  );
  final image = await picture.toImage(width, height);
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  final uInt8List = byteData?.buffer.asUint8List();
  return BitmapDescriptor.fromBytes(uInt8List!);
}

// class HotspotforMap {
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
// }
