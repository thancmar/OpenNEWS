import 'dart:async';

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:sharemagazines_flutter/src/blocs/splash/splash_bloc.dart';
import 'package:sharemagazines_flutter/src/models/location_model.dart';
import 'package:sharemagazines_flutter/src/models/magazineCategoryGetAllActive.dart';
import 'package:sharemagazines_flutter/src/models/magazinePublishedGetAllLastByHotspotId_model.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';
import 'package:sharemagazines_flutter/src/resources/location_repository.dart';
import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';
import 'package:cookie_jar/cookie_jar.dart';

import '../../models/hotspots_model.dart';
import '../../models/locationGetHeader_model.dart';
import '../../models/locationOffers_model.dart';
import '../../models/place_map.dart';
import '../../resources/dioClient.dart';

part 'navbar_event.dart';
part 'navbar_state.dart';

// enum NavbarItems { Home, Menu, Map, Account }

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  final MagazineRepository magazineRepository;
  final LocationRepository locationRepository;
  final HotspotRepository hotspotRepository;

  // late Future<HotspotsGetAllActive> hotspotList;
  late Localization? locationResponse;
  static late Data appbarlocation;
  bool statechanged = false;
  late List<Future<Uint8List>> getTop = List.empty(growable: true);
  // Position? position = null;
  final GetIt getIt = GetIt.instance;
  // static late Future<LocationOffers>? maplocationoffers;
  var cookieJar = CookieJar();
  // GetIt getIt = GetIt.instance;
  CancelToken cancelToken = CancelToken();
  ApiClient dioClient = ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());

  Future<void> GetAllMagazinesCover(int locationID, NavbarEvent? event) async {
    // await DefaultCacheManager().emptyCache();
    // event?.timer?.cancel();xdcvx
    // await EasyLoading.show(
    //   status: 'loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );

    magazineRepository.magazineCategoryGetAllActive().then((value) async => {NavbarState.magazineCategoryGetAllActive = value});
    print("GetAllMagazinesCover ${NavbarState.currentPosition?.latitude}");

    await locationRepository.checklocation(locationID.toString(), NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude).then((value) async => {
          // if (index != 0)
          if (locationID != 0)
            {
              NavbarState.locationheader = locationRepository.GetLocationHeader(locationID: locationID.toString()),
              NavbarState.locationheader?.then((value) => {
                    // NavbarState.locationheader = value,

                    if (value.filePath != "") {NavbarState.locationImage = locationRepository.GetLocationImage(locationID: locationID.toString(), filePath: value.filePath.toString())}
                  }),
              NavbarState.locationoffers = locationRepository.GetLocationOffers(locationID: locationID.toString()),
              NavbarState.locationoffers?.then((value) => {
                    // NavbarState.locationheader = value,
                    if (value.locationOffer!.length > 0)
                      {
                        value.locationOffer?.forEach((element) {
                          NavbarState.locationoffersImages!.add(locationRepository.GetLocationOfferImage(offerID: element.idOffer.toString(), filePath: element.shm2Offer![0].data!));
                        })
                      }
                  }),
              await magazineRepository.magazinePublishedGetTopLastByRange(id_hotspot: locationID.toString(), cookieJar: cookieJar).then((value) => {
                    NavbarState.magazinePublishedGetTopLastByRange = value,
                    // magazinePublishedGetLastWithLimitdata_navbarBloc = value,
                    for (var i = 0; i < value.response!.length; i++)
                      {
                        for (var k = 1; k < int.parse(value.response![i].pageMax!); k++)
                          {
                            DefaultCacheManager().getFileFromCache(value.response![i].idMagazinePublication! + "_" + value.response![i].dateOfPublication! + "_" + k.toString()).then((valueCache) => {
                                  if (valueCache == null)
                                    {
                                      magazineRepository.GetPagesforReader(
                                          page: k, id_mag_pub: value.response![i].idMagazinePublication, date_of_publication: value.response![i].dateOfPublication, readerCancelToken: cancelToken)

                                      // for (var i = 0; i < int.parse(value. .magazine.pageMax!); i++) {},
                                      // NavbarState.getTopMagazines?.add(magazineRepository.GetPage(
                                      //     page: '0',
                                      //     id_mag_pub: NavbarState.magazinePublishedGetTopLastByRange?.response![i].idMagazinePublication!,
                                      //     date_of_publication: NavbarState.magazinePublishedGetTopLastByRange?.response![i].dateOfPublication!)),
                                      // print("magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication! = ${futureFunc[i].toString()}");
                                    },
                                }),
                            // magazineRepository.GetPagesforReader(
                            //     page: k, id_mag_pub: value.response![i].idMagazinePublication, date_of_publication: value.response![i].dateOfPublication, readerCancelToken: cancelToken)
                          }
                        // await DefaultCacheManager()
                        //     .getFileFromCache(value.response![i].idMagazinePublication! + "_" + value.response![i].dateOfPublication! + "_" + i.toString())
                        //     .then((value) async => {
                        //           if (value == null)
                        //             {
                        //               print("empty")
                        //               // for (var i = 0; i < int.parse(value. .magazine.pageMax!); i++) {},
                        //               // NavbarState.getTopMagazines?.add(magazineRepository.GetPage(
                        //               //     page: '0',
                        //               //     id_mag_pub: NavbarState.magazinePublishedGetTopLastByRange?.response![i].idMagazinePublication!,
                        //               //     date_of_publication: NavbarState.magazinePublishedGetTopLastByRange?.response![i].dateOfPublication!)),
                        //               // print("magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication! = ${futureFunc[i].toString()}");
                        //             },
                        //         }),
                      },
                    // event?.timer?.cancel(),
                    // EasyLoading.dismiss(),
                  })
            },
          await magazineRepository.magazinePublishedGetAllLastByHotspotId(id_hotspot: locationID.toString(), cookieJar: cookieJar).then((data) {
            NavbarState.magazinePublishedGetLastWithLimit = data;
            // dioClient.secureStorage.write(key: "allmagazines", value: data);

            for (var i = 0; i < NavbarState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
              //To show on the searchpage
              switch (NavbarState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage) {
                case "de":
                  NavbarState.counterDE = NavbarState.counterDE + 1;
                  break;
                case "en":
                  NavbarState.counterEN++;
                  break;
                case "fr":
                  NavbarState.counterFR++;
                  break;
                case "es":
                  NavbarState.counterES++;
                  break;
              }
              DefaultCacheManager()
                  .getFileFromCache(
                      NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication! + "_" + NavbarState.magazinePublishedGetLastWithLimit!.response![i].dateOfPublication! + "_0")
                  .then((value) => {
                        if (value?.file.lengthSync() == null)
                          {
                            // print("page does not exist1 ${NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!} ${value?.file.lengthSync()}"),
                            magazineRepository.GetPage(
                                page: '0',
                                id_mag_pub: NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!,
                                date_of_publication: NavbarState.magazinePublishedGetLastWithLimit!.response![i].dateOfPublication!)
                          }
                      });
            }
            // event?.timer?.cancel();
            // await EasyLoading.dismiss();
          }),
        });
  }

  NavbarBloc({required this.magazineRepository, required this.locationRepository, required this.hotspotRepository}) : super(Loading()) {
    on<Initialize123>((event, emit) async {
      try {
        emit(Loading());
        // event.timer?.cancel();
        await EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
        NavbarState.magazinePublishedGetLastWithLimit = MagazinePublishedGetLastWithLimitFromJson(await dioClient.secureStorage.read(key: "allmagazines") ?? '');
        // NavbarState.magazinePublishedGetTopLastByRange = MagazinePublishedGetLastWithLimitFromJson(await dioClient.secureStorage.read(key: "allmagazinesbyrange") ?? '');

        NavbarState.languageResultsALL?.clear();
        NavbarState.languageResultsDE?.clear();
        NavbarState.languageResultsEN?.clear();
        NavbarState.languageResultsFR?.clear();
        // NavbarState.hotspotList = await hotspotRepository.GetAllActiveHotspots();
        // await NavbarState.hotspotList;
        appbarlocation = Data();
        NavbarState.locationheader = null;
        NavbarState.magazineCategoryGetAllActive = null;
        NavbarState.locationoffers = null;
        NavbarState.locationoffersImages?.clear();
        NavbarState.locationImage = null;
        NavbarState.hotspotList = HotspotsGetAllActive();
        NavbarState.allMapMarkers = <Place>[];

        hotspotRepository.GetAllActiveHotspots().then((data) {
          NavbarState.hotspotList = data;
          List<Place>? hpList = [];
          var len = data.response?.length;
          for (int i = 0; i < len!; i++) {
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
            NavbarState.allMapMarkers.add(temp);
          }
        });
        print("Position lat");
        LocationPermission? permission = await Geolocator.checkPermission();
        print("Position lat");
        if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
          NavbarState.currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium).catchError(() => {
                // throw Exception("Failed to localize")
                emit(NavbarError("Geolocator error"))
              });
        }

        print("Position lat");
        // if (SplashState.appbarlocation != null) {
        appbarlocation = event.currentPosition!;
        print("appbarlocation = Data(),");
        // add(Home(value.data![0])),
        //await
        GetAllMagazinesCover(int.parse(event.currentPosition?.idLocation ?? "0"), event).then((valueGetAllMagazinesCover) async => {
              // add(Menu()),
              add(Home(event.currentPosition)),
              // event.timer?.cancel(),
              await EasyLoading.dismiss(),
              // emit(GoToHome(currentLocation: appbarlocation!)),
              print('EasyLoading dismiss 1'),
            });
        // } else {
        //   appbarlocation = Data();
        //   GetAllMagazinesCover(0, event).then((valueGetAllMagazinesCover) async => {
        //         // add(Menu()),
        //         add(Home(appbarlocation)),
        //         // event.timer?.cancel(),
        //         await EasyLoading.dismiss(),
        //         // emit(GoToHome(currentLocation: appbarlocation!)),
        //         print('EasyLoading dismiss 1'),
        //       });
        // }
        // if (event.currentPosition != null) {}
        // await locationRepository.checklocation(null, NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude).then((value) async => {
        //       // print("value!.data!.length! ${value!.data!.length}"),
        //       // print("value!.data!.length! }"),
        //       if (value!.data!.length > 1)
        //         {
        //           add(LocationSelection(locations: value.data!)),
        //           // event.timer?.cancel(),
        //           // await EasyLoading.dismiss(),
        //           print('EasyLoading dismiss 3'),
        //         }
        //       else if (value?.data!.length == 1)
        //         {
        //           appbarlocation = value!.data![0],
        //           print("appbarlocation = Data(),"),
        //           // add(Home(value.data![0])),
        //           //await
        //           GetAllMagazinesCover(int.parse(value.data![0].idLocation!), event).then((valueGetAllMagazinesCover) async => {
        //                 // add(Menu()),
        //                 add(Home(value.data![0])),
        //                 // event.timer?.cancel(),
        //                 await EasyLoading.dismiss(),
        //                 // emit(GoToHome(currentLocation: appbarlocation!)),
        //                 print('EasyLoading dismiss 1'),
        //               }),
        //         }
        //       else
        //         {
        //           await GetAllMagazinesCover(int.parse("0"), null).then((value) async => {
        //                 add(Home()),
        //                 // event.timer?.cancel(),
        //                 await EasyLoading.dismiss(),
        //                 print('EasyLoading dismiss 2'),
        //               }),
        //         },
        //     });
      } catch (e) {
        // statechanged = false;
        emit(NavbarError(e.toString()));
      }
    });

    on<Home>((event, emit) async {
      try {
        emit(GoToHome(currentLocation: appbarlocation!));
        // event.timer?.cancel();
        await EasyLoading.dismiss();
        print("Navbarbloc home event emitted123");
        statechanged = false;
        // statsechanged = true;
      } catch (e) {
        // statechanged = false;
        emit(NavbarError(e.toString()));
        print(e);
      }
    });

    on<Menu>((event, emit) async {
      try {
        statechanged = true;
        emit(GoToMenu());
        statechanged = false;
      } on Exception catch (e) {
        emit(NavbarError(e.toString()));
        print(e);
      }
    });

    on<Map>((event, emit) async {
      try {
        statechanged = true;
        emit(GoToMap());
        statechanged = false;
      } on Exception catch (e) {
        emit(NavbarError(e.toString()));
        print(e);
      }
    });

    on<GetMapOffer>((event, emit) async {
      //   statechanged = true;
      //
      try {
        print("GetMapOffer ${event.loc.id.toString()}");
        NavbarState.maplocationoffers = null;
        NavbarState.maplocationoffers = locationRepository.GetLocationOffers(locationID: event.loc.id);
      } catch (error) {
        print("GetMapOffer error - $error");
        emit(NavbarError(error.toString()));
      }

      //   emit(GoToMapOffer(loc: event.loc, offers: maplocationoffers));
      //   statechanged = false;
    });

    on<AccountEvent>((event, emit) async {
      try {
        statechanged = true;
        emit(GoToAccount(null, null, null));
        statechanged = false;
      } on Exception catch (e) {
        emit(NavbarError(e.toString()));
        print(e);
      }
    });

    // on<LocationSelection>((event, emit) async {
    //   // print("emit(GoToLocationSelection(null, null, locationResponse)); ${event.location?.idLocation},");
    //   // statechanged = true;
    //   // if (event.location?.idLocation != null) {
    //   //   event.timer?.cancel();
    //   //   await EasyLoading.show(
    //   //     status: 'loading...',
    //   //     maskType: EasyLoadingMaskType.black,
    //   //   );
    //   //   appbarlocation = event.location!;
    //   //   await GetAllMagazinesCover(int.parse(event.location!.idLocation!), event).then((valueGetAllMagazinesCover) async => {
    //   //         add(Home(event.location!)),
    //   //         event.timer?.cancel(),
    //   //         await EasyLoading.dismiss(),
    //   //       });
    //   // } else {
    //   try {
    //     await EasyLoading.dismiss();
    //     emit(GoToLocationSelection(event.locations));
    //     // }
    //     statechanged = false;
    //   } on Exception catch (e) {
    //     emit(NavbarError(e.toString()));
    //     print(e);
    //   }
    // });

    on<LocationSelected>((event, emit) async {
      try {
        await EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
        appbarlocation = event.location!;
        print("appbarlocation = Data(),");
        await GetAllMagazinesCover(int.parse(event.location!.idLocation!), event).then((valueGetAllMagazinesCover) async => {
              add(Home(event.location!)),
              // event.timer?.cancel(),
              await EasyLoading.dismiss(),
              print('EasyLoading dismiss 112'),
            });
        statechanged = false;
      } on Exception catch (e) {
        await EasyLoading.dismiss();
        emit(NavbarError(e.toString()));
        print(e);
      }
    });
  }

  Future<void> checkLocation() async {
    statechanged = true;
    // await EasyLoading.show(
    //   status: 'loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );
    bool updateLocation = true;
    print("bloc LocationRefresh ${appbarlocation != Data()}");
    await locationRepository.checklocation(null, NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude).then((value) async => {
          // print("bloc LocationRefresh ${appbarlocation!.idLocation}"),
          // print("bloc LocationRefresh ${appbarlocation.idLocation} ${value!.data!}"),
          updateLocation = value!.data!.length == 0 ? false : true,
          for (int i = 0; i < value!.data!.length; i++)
            {
              if (appbarlocation!.idLocation == value.data![i].idLocation)
                {
                  updateLocation = false,
                  await EasyLoading.dismiss(),
                }
            },
          if (updateLocation == true)
            {
              add(Initialize123(currentPosition: value!.data![0])),
            },
          // else {add(Initialize123())},
          // if (appbarlocation!.idLocation == null)
          //   {
          //     if (value!.data!.length > 0) {add(Initialize123())}
          //   }
          // else
          //   {
          //     // nearbyLocationIDs = [],
          //     // for (int i = 0; i < value!.data!.length; i++) {},
          //     if (
          //     // timer?.isActive == true ||
          //     value!.data!.length == 0)
          //       {
          //         add(Initialize123()),
          //       },
          //     for (int i = 0; i < value!.data!.length; i++)
          //       {
          //         if (appbarlocation!.idLocation == value.data![i].idLocation)
          //           {
          //             await EasyLoading.dismiss(),
          //
          //           }
          //       },

          // if (value!.data!.length == 0)
          //   {
          //     add(Initialize123(event.timer)),
          //   },

          // if (value!.data!.contains("appbarlocation") == false)
          //   {
          //     add(Initialize123(event.timer)),
          //   }
          // else
          //   {
          //     // event.timer?.cancel(),
          //     // await EasyLoading.dismiss(),
          //   }
          // },
          // {add(Initialize123(event.timer))},
          statechanged = false,
          // timer?.cancel(),
          await EasyLoading.dismiss(),
        });
  }
}