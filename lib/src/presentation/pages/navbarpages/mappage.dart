import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sharemagazines_flutter/src/blocs/map/map_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/splash/splash_bloc.dart';
import 'package:sharemagazines_flutter/src/models/hotspots_model.dart';
import 'package:sharemagazines_flutter/src/resources/auth_repository.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/place_map.dart';

// class MapsBlocWidget extends StatelessWidget {
//   MapBloc _bloc = MapBloc(
//     hotspotRepository: HotspotRepository(),
//   );
//   @override
//   Widget build(BuildContext context) {
//     // Future<HotspotsGetAllActive>hp = RepositoryProvider.of<HotspotRepository>(context);
//     return BlocProvider.value(
//       value: _bloc,
//       child: Maps(),
//     );
//   }
// }

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> with AutomaticKeepAliveClientMixin<Maps> {
  late GoogleMapController mapController;
  // var repo = HotspotRepository();
  late Future<HotspotsGetAllActive> hotspotList;
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  // late List<Place>? hpList = [];
  Set<Marker> markers = Set(); //markers for google map
  List<Marker> myMarkers = <Marker>[];
  late ClusterManager manager;
  Completer<GoogleMapController> _controller = Completer();
  String location = "Search Location";
  late bool showlocationdetail = false;
  late Place locationmarker;

  Timer? _timer;
  late double _progress;
  final LatLng _center = const LatLng(51.1657, 10.4515);

  @override
  bool get wantKeepAlive => true;

  // void _onMapCreated(GoogleMapController controller) {
  //   // mapController = controller;
  //   //
  //   // var markerIdVal = MyWayToGenerateId();
  //   // final MarkerId markerId = MarkerId(markerIdVal);
  //
  //   // creating a new MARKER
  //
  //   // final Marker marker = Marker(
  //   //   markerId: MarkerId('place_name'),
  //   //   position: LatLng(
  //   //     53.5511,
  //   //     9.9937,
  //   //   ),
  //   //   infoWindow: InfoWindow(title: "markerIdVal", snippet: '*'),
  //   //   // onTap: () {
  //   //   //   _onMarkerTapped(markerId);
  //   //   // },
  //   // );
  //
  //   // hp.then((data) {
  //   //   print("hp");
  //   //   var len = data.response?.length;
  //   //   for (int i = 0; i < len!; i++) {
  //   //     // final temp = HotspotforMap(
  //   //     //   data.response![i].id!,
  //   //     //   data.response![i].nameApp!,
  //   //     //   data.response![i].type!,
  //   //     //   data.response![i].addressCity!,
  //   //     //   data.response![i].addressHouseNr!,
  //   //     //   data.response![i].addressZip!,
  //   //     //   data.response![i].addressZip!,
  //   //     //   data.response![i].latitude!,
  //   //     //   data.response![i].longitude!,
  //   //     // );
  //   //     final temp = Place(
  //   //         id: data.response![i].id!,
  //   //         nameApp: data.response![i].nameApp!,
  //   //         type: data.response![i].type!,
  //   //         addressStreet: data.response![i].addressCity!,
  //   //         addressHouseNr: data.response![i].addressHouseNr!,
  //   //         addressZip: data.response![i].addressZip!,
  //   //         addressCity: data.response![i].addressCity!,
  //   //         latitude: data.response![i].latitude!,
  //   //         longitude: data.response![i].longitude!);
  //   //     hpList?.add(temp);
  //   //
  //   //     print("mark");
  //   //   }
  //   //   print("something");
  //   //   // adding a new marker to map
  //   //   // markers[MarkerId('place_name')] = marker;
  //   //   hpList?.forEach((element) {
  //   //     myMarkers.add(Marker(
  //   //         markerId: MarkerId(element.nameApp),
  //   //         position: LatLng(element.latitude, element.longitude),
  //   //         infoWindow: InfoWindow(title: element.nameApp)));
  //   //     print("finished");
  //   //   });
  //   //   print("done");
  //   //
  //   //   setState(() {});
  //   //
  //   //   // print(markers);
  //   //   // print(hpList);
  //   // }, onError: (e) {
  //   //   print("fsadfs");
  //   //   print(e);
  //   // });
  // }

  @override
  void initState() {
    print("_MapsState init");

    super.initState();
    manager = _initClusterManager();
    // manager.updateMap.call();
  }

  ClusterManager _initClusterManager() {
    print("_initClusterManager");
    return ClusterManager<Place>(NavbarState.allMapMarkers, _updateMarkers,
        markerBuilder: _markerBuilder,
        // levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0],
        stopClusteringZoom: 12.0);
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

//Show available maps to show route to the dest.
  openMapsSheet(context, _title, _lat, _lon) async {
    try {
      final coords = Coords(_lat, _lon);
      final title = _title;
      print("Breakpoint");
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showDirections(
                          destinationTitle: title,
                          destination: coords,
                          // coords: coords,
                          // title: title,
                        ),
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Stack(children: [
        GoogleMap(
          // onMapCreated: _onMapCreated,

          zoomGesturesEnabled: true,
          rotateGesturesEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            manager.setMapId(controller.mapId);
          },
          onCameraMove:
              //Could zoom in on the location when click on?

              manager.onCameraMove,
          // showlocationdetail = false,

          onCameraIdle: manager.updateMap,
          initialCameraPosition: CameraPosition(
            target: NavbarState.currentPosition != null ? LatLng(NavbarState.currentPosition!.latitude, NavbarState.currentPosition!.longitude) : _center,
            zoom: NavbarState.currentPosition != null ? 15.0 : 6.0,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          // markers: Set<Marker>.from(myMarkers),
          markers: markers,
          onTap: (LatLng point) {
            setState(() {
              showlocationdetail = false;
            });
          },

          // onCameraMoveStarted: () => {
          //   setState(() {
          //     showlocationdetail = false;
          //   })
          // },
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

                        logo: Text(""),
                        radius: 10000,
                        context: context,
                        apiKey: "AIzaSyB4CAZ-Q37WtAXEwX_dTMX4nYvKPsMfswY",
                        // mode: Mode.values[15],
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
                      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                    }
                  },
                  child: Padding(
                    // padding: EdgeInsets.all(15),
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              // spreadRadius: 7,
                              // blurRadius: 7,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width - 40,
                        child: ListTile(
                          title: Text(
                            location,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                          trailing: GestureDetector(
                              onTap: () {
                                //still need to implement
                                if (NavbarState.currentPosition != null) {
                                  final p = CameraPosition(target: LatLng(NavbarState.currentPosition!.latitude, NavbarState.currentPosition!.longitude), zoom: 15);
                                  mapController.animateCamera(CameraUpdate.newCameraPosition(p));
                                }
                              },
                              child: Icon(
                                Icons.location_searching,
                              )),
                          dense: true,
                        )),
                  ))),
        ),
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
                style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(locationmarker.addressStreet + " " + locationmarker.addressHouseNr + ",\n" + locationmarker.addressZip + " " + locationmarker.addressCity,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    onPressed: () => openMapsSheet(context, locationmarker.nameApp!, locationmarker.latitude, locationmarker.longitude),
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
    // c.animateCamera(CameraUpdate.newCameraPosition(p));
    mapController.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder => (cluster) async {
        mapController = await _controller.future;
        Completer<GoogleMapController> completer = Completer();

        return Marker(
            markerId: MarkerId(cluster.getId()),
            position: cluster.location,
            onTap: () {
              if (cluster.isMultiple == true) {
                setState(() {
                  print(cluster.location);
                  animateTo(cluster.location.latitude, cluster.location.longitude);
                  showlocationdetail = false;
                });
              } else {
                setState(() {
                  print(cluster.items.first.addressStreet);
                  locationmarker = cluster.items.first;
                  showlocationdetail = true;
                });
              }
            },
            icon: cluster.isMultiple == true
                ? await _getMarkerBitmap(125, text: cluster.count.toString())
                : await getBitmapDescriptorFromSVGAsset(
                    context,
                    chooseMapPin(cluster.items.first.type!),
                    // "assets/images/pins/cafe.svg",
                  ));
      };
}

Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
  if (kIsWeb) size = (size / 2).floor();

  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  print("_getMarkerBitmap text");
  print(text);
  final Paint paint1 = Paint()..color = int.parse(text!) < 10 ? Colors.blue.withOpacity(0.4) : Colors.purple.withOpacity(0.4);
  final Paint paint2 = Paint()..color = int.parse(text!) < 10 ? Colors.blue : Colors.purple;

  canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
  canvas.drawCircle(Offset(size / 2, size / 2), size / 2.6, paint2);
  // canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

  if (text != null) {
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(fontSize: size / 3, color: Colors.white, fontWeight: FontWeight.normal),
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

String chooseMapPin(String hp_type) {
  print("hp_type");
  print(hp_type);
  final basePath = "assets/images/pins/";

  switch (int.parse(hp_type)) {
    case 1:
      return basePath + "cafe.svg";
    case 2:
      return basePath + "hotel.svg";
    case 3:
      return basePath + "klinik.svg";
    case 4:
      return basePath + "praxis.svg";
    //Test
    case 5:
      return basePath + "cafe.svg";
    case 6:
      return basePath + "cafe.svg";
    case 7:
      return basePath + "friseur.svg";
    case 8:
      return basePath + "company.svg";
    case 9:
      return basePath + "stromtankstelle.svg";
    case 10:
      return basePath + "autohaus.svg";
    case 11:
      return basePath + "bibliothek.svg";
//no pin
    case 12:
      return basePath + "cafe.svg";
    case 13:
      return basePath + "telekom.svg";
    case 14:
      return basePath + "voigt.svg";
    case 15:
      return basePath + "mercedes.svg";
    case 16:
      return basePath + "swb.svg";
    case 17:
      return basePath + "porsche.svg";
    case 18:
      return basePath + "dg_nexolution_eg.svg";
    case 19:
      return basePath + "tuv.svg";
    case 20:
      return basePath + "bankfiliale.svg";
    case 21:
      return basePath + "kantine.svg";
    case 22:
      return basePath + "kundencenter.svg";
    case 23:
      return basePath + "wellness.svg";
    case 24:
      return basePath + "öpnv.svg";
    case 25:
      return basePath + "fähre.svg";
    case 26:
      return basePath + "fitnessstudio.svg";
    case 27:
      return basePath + "kanzlei.svg";
    case 28:
      return basePath + "modelhaus.svg";
  }
  return basePath + "cafe.svg";
}