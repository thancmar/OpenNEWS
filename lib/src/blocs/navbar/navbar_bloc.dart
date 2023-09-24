import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
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
import '../../presentation/widgets/src/easy_loading.dart';
import '../../resources/dioClient.dart';

part 'navbar_event.dart';

part 'navbar_state.dart';

// enum NavbarItems { Home, Menu, Map, Account }

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  final MagazineRepository magazineRepository;
  final LocationRepository locationRepository;
  final HotspotRepository hotspotRepository;
  List<String> navbarData = [];

  // late Future<HotspotsGetAllActive> hotspotList;
  NavbarState? previousState;

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
    // event?.timer?.cancel();xdcvx
    // await EasyLoading.show(
    //   status: 'loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );
    try {
      NavbarState.locationheader = null;
      NavbarState.magazineCategoryGetAllActive = null;
      NavbarState.locationoffers = null;
      NavbarState.locationoffersImages?.clear();
      NavbarState.locationImage = null;

      await magazineRepository.magazineCategoryGetAllActive().then((value) async => {NavbarState.magazineCategoryGetAllActive = value});
      print("GetAllMagazinesCover ${NavbarState.currentPosition?.latitude}");

      await locationRepository
          .checklocation(locationID.toString(), NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude)
          .then((value) async => {
                // SplashState.allNearbyLocations = value!.data!,
                // if (index != 0)
                if (locationID != 0)
                  {
                    NavbarState.appbarlocation = value!.data![0],
                    NavbarState.locationheader = locationRepository.GetLocationHeader(locationID: locationID.toString()),
                    NavbarState.locationheader?.then((value) => {
                          // NavbarState.locationheader = value,

                          if (value.filePath != "")
                            {
                              NavbarState.locationImage =
                                  locationRepository.GetLocationImage(locationID: locationID.toString(), filePath: value.filePath.toString())
                            }
                        }),
                    NavbarState.locationoffers = locationRepository.GetLocationOffers(locationID: locationID.toString()),
                    NavbarState.locationoffers?.then((value) => {
                          // NavbarState.locationheader = value,
                          if (value.locationOffer!.length > 0)
                            {
                              value.locationOffer?.forEach((element) {
                                if (element.shm2Offer![0].type!.contains("MOV")) {
                                  NavbarState.locationoffersVideos!.add(locationRepository.GetLocationOfferVideo(
                                      offerID: element.shm2Offer![0].id.toString(), filePath: element.shm2Offer![0].data!));
                                }
                                // else{
                                NavbarState.locationoffersImages!.add(locationRepository.GetLocationOfferImage(
                                    offerID: element.idOffer.toString(), filePath: element.shm2Offer![0].data!));
                                // }
                              })
                            }
                        }),
                    await magazineRepository
                        .magazinePublishedGetTopLastByRange(id_hotspot: locationID.toString(), cookieJar: cookieJar)
                        .then((value) => {
                              NavbarState.magazinePublishedGetTopLastByRange = value,
                              // magazinePublishedGetLastWithLimitdata_navbarBloc = value,
                              for (var i = 0; i < value.response!.length; i++)
                                {
                                  for (var k = 1; k < int.parse(value.response![i].pageMax!); k++)
                                    {
                                      DefaultCacheManager()
                                          .getFileFromCache(value.response![i].idMagazinePublication! +
                                              "_" +
                                              value.response![i].dateOfPublication! +
                                              "_" +
                                              k.toString())
                                          .then((valueCache) => {
                                                if (valueCache == null)
                                                  {
                                                    magazineRepository.GetPagesforReader(
                                                        page: k,
                                                        id_mag_pub: value.response![i].idMagazinePublication,
                                                        date_of_publication: value.response![i].dateOfPublication,
                                                        readerCancelToken: cancelToken)

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
                    // After every 50 iterations, delay for 1 second
                    if ((i + 1) % 100 == 0) {
                       Future.delayed(Duration(seconds: 1));
                    }
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
                        .getFileFromCache(NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication! +
                            "_" +
                            NavbarState.magazinePublishedGetLastWithLimit!.response![i].dateOfPublication! +
                            "_0")
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
    } on Exception catch (e) {
      // TODO
      emit(NavbarError(e.toString()));
    }
  }

  void checkLocationService() async {
    LocationPermission permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      print('Location service is enabled.');
    } else {
      print('Location service is not enabled.');
      // if (await Permission.speech.isPermanentlyDenied|| permission == LocationPermission.deniedForever) {
      //   // The user opted to never again see the permission request dialog for this
      //   // app. The only way to change the permission's status now is to let the
      //   // user manually enable it in the system settings.
      //   openAppSettings();
      // }
      emit(AskForLocationPermission());
    }
  }

  void qr(String code) async {
    try {
      // emit(Loading());
      // event.timer?.cancel();
      await EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
      // await locationRepository.checklocation(null,null,null,code);
      await Future.delayed(Duration(seconds: 2));
      await EasyLoading.dismiss();
    } catch (e) {
      // statechanged = false;
      await EasyLoading.dismiss();
      emit(NavbarLoaded());
      // emit(NavbarError(e.toString()));
    }
  }

  NavbarBloc({required this.magazineRepository, required this.locationRepository, required this.hotspotRepository}) : super(LoadingNavbar()) {
    on<Initialize123>((event, emit) async {
      try {
        emit(LoadingNavbar());
        // event.timer?.cancel();
        await EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
        Timer.periodic(Duration(seconds: 60), (Timer t) => checkLocationService());
        // Timer.periodic(Duration(seconds: 60), (Timer t) => checkLocation());
        navbarData = ["sad"];
        (await dioClient.secureStorage.read(key: "allmagazines").then((value) => {
              if (value != null) {NavbarState.magazinePublishedGetLastWithLimit = MagazinePublishedGetLastWithLimitFromJson(value)}
            }));
        NavbarState.magazinePublishedGetLastWithLimit = MagazinePublishedGetAllLastByHotspotId(response: []);
        NavbarState.magazinePublishedGetTopLastByRange = null;

        NavbarState.languageResultsALL?.clear();
        NavbarState.languageResultsDE?.clear();
        NavbarState.languageResultsEN?.clear();
        NavbarState.languageResultsFR?.clear();

        String? stringOfItems = await dioClient.secureStorage.read(key: 'bookmarks');
        if (stringOfItems != null && stringOfItems.isNotEmpty) {
          Map<String, dynamic> decodedJson = jsonDecode(stringOfItems);
          MagazinePublishedGetAllLastByHotspotId retrievedBookmarks = MagazinePublishedGetAllLastByHotspotId.fromJson(decodedJson);
          NavbarState.bookmarks.value = retrievedBookmarks;
        }




        // NavbarState.bookmarks =  await dioClient.secureStorage.read(key: "bookmarks");
        // NavbarState.hotspotList = await hotspotRepository.GetAllActiveHotspots();
        // await NavbarState.hotspotList;
        // appbarlocation = Data();

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
                // latitude: data.response![i].latitude!,
                // longitude: data.response![i].longitude!);
                latitude: double.tryParse(data.response![i].latitude!)!,
                longitude: double.tryParse(data.response![i].longitude!)!);
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
        //Have to change this(remove splashstate)
        if (SplashState.allNearbyLocations.length > 1) {
          await EasyLoading.dismiss();
          emit(GoToLocationSelection(SplashState.allNearbyLocations));
        } else if (SplashState.allNearbyLocations.length == 1) {
          // SplashState.appbarlocation = SplashState.allNearbyLocations[0];
          // state.appbarlocation = SplashState.allNearbyLocations[0];
          await GetAllMagazinesCover(int.parse(SplashState.allNearbyLocations[0].idLocation!), event).then((valueGetAllMagazinesCover) async => {
                // add(Menu()),
                // add(Home(event.currentPosition)),
                // event.timer?.cancel(),
                await EasyLoading.dismiss(),
                emit(NavbarLoaded()), //(navbarData)),
                // emit(GoToHome(currentLocation: appbarlocation!)),
                print('EasyLoading dismiss 1 location'),
              });
        } else {
          // NavbarState.currentPosition = event.currentPosition!;
          // state.appbarlocation = event.currentPosition!;
          await GetAllMagazinesCover(int.parse("0"), event).then((valueGetAllMagazinesCover) async => {
                // add(Menu()),
                // add(Home(event.currentPosition)),
                // event.timer?.cancel(),
                await EasyLoading.dismiss(),
                emit(NavbarLoaded()),
                // emit(GoToHome(currentLocation: appbarlocation!)),
                print('EasyLoading dismiss 0 Location'),
              });
        }
      } catch (e) {
        // statechanged = false;
        await EasyLoading.dismiss();
        emit(NavbarError(e.toString()));
      }
    });

    on<BackFromLocationPermission>((event, emit) async {
      try {
        await EasyLoading.dismiss();
        emit(NavbarLoaded());
      } catch (error) {
        print("GetMapOffer error - $error");
        emit(NavbarError(error.toString()));
      }
    });

    on<OpenSystemSettings>((event, emit) async {
      try {
        // await EasyLoading.dismiss();
        LocationPermission permission = await Geolocator.checkPermission();
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
          print('Location service is enabled.');
        } else {
          print('Location service is not enabled.');
          if (await Permission.speech.isPermanentlyDenied || permission == LocationPermission.deniedForever) {
            // The user opted to never again see the permission request dialog for this
            // app. The only way to change the permission's status now is to let the
            // user manually enable it in the system settings.
            openAppSettings();
          }
          emit(AskForLocationPermission());
        }
      } catch (error) {
        print("GetMapOffer error - $error");
        emit(NavbarError(error.toString()));
      }
    });

    on<OpenLanguageSelection>((event, emit) async {
      try {
        // await EasyLoading.dismiss();
        // await EasyLocalization.
        // if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        //   print('Location service is enabled.');
        // } else {
        //   print('Location service is not enabled.');
        //   if (await Permission.speech.isPermanentlyDenied || permission == LocationPermission.deniedForever) {
        //     // The user opted to never again see the permission request dialog for this
        //     // app. The only way to change the permission's status now is to let the
        //     // user manually enable it in the system settings.
        //     openAppSettings();
        //   }
        emit(GoToLanguageSelection(languageOptions: event.languageOptions));
        // }
      } catch (error) {
        print("GetMapOffer error - $error");
        emit(NavbarError(error.toString()));
      }
    });

    on<LanguageSelected>((event, emit) async {
      try {
        await EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
        emit(LoadingNavbar());
        // if (NavbarState.appbarlocation.idLocation != event.location!.idLocation) {
        //   await GetAllMagazinesCover(int.parse(event.location!.idLocation!), event).then((valueGetAllMagazinesCover) async => {
        //     await EasyLoading.dismiss(),
        //     emit(NavbarLoaded()),
        //   });
        // } else {
        await EasyLoading.dismiss();
        emit(NavbarLoaded());
        // }
      } on Exception catch (e) {
        await EasyLoading.dismiss();
        emit(NavbarError(e.toString()));
        print(e);
      }
    });

    on<GetMapOffer>((event, emit) async {
      try {
        print("GetMapOffer ${event.loc.id.toString()}");
        NavbarState.maplocationoffers = null;
        NavbarState.maplocationoffers = locationRepository.GetLocationOffers(locationID: event.loc.id);
      } catch (error) {
        print("GetMapOffer error - $error");
        emit(NavbarError(error.toString()));
      }
      ;
    });

    on<LocationSelected>((event, emit) async {
      try {
        await EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
        emit(LoadingNavbar());
        if (NavbarState.appbarlocation.idLocation != event.location!.idLocation) {
          await GetAllMagazinesCover(int.parse(event.location!.idLocation!), event).then((valueGetAllMagazinesCover) async => {
                await EasyLoading.dismiss(),
                emit(NavbarLoaded()),
              });
        } else {
          await EasyLoading.dismiss();
          emit(NavbarLoaded());
        }
      } on Exception catch (e) {
        await EasyLoading.dismiss();
        emit(NavbarError(e.toString()));
        print(e);
      }
    });

    on<Bookmark>((event, emit) async {
      try {
        String serializedBookmarks = jsonEncode(NavbarState.bookmarks.value.toJson());
        await dioClient.secureStorage.write(key: "bookmarks", value: serializedBookmarks);

      } catch (error) {
        print("error - $error");
        emit(NavbarError(error.toString()));
      }
      ;
    });
  }

  Future<void> checkLocation() async {
    bool updateLocation = false;
    await locationRepository
        .checklocation(null, NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude)
        .then((value) async => {
              // print("bloc LocationRefresh ${appbarlocation!.idLocation}"),
              // print("bloc LocationRefresh ${appbarlocation.idLocation} ${value!.data!}"),
              // updateLocation = value!.data!.length == 0 ? false : true,
              if (value!.data!.length == 0)
                {
                  if (NavbarState.appbarlocation!.idLocation == null) {updateLocation = false} else {updateLocation = true}
                }
              else if (value!.data!.length == 1)
                {
                  if (NavbarState.appbarlocation.idLocation != value.data![0].idLocation)
                    {
                      // state.appbarlocation = Data(),
                      print(NavbarState.appbarlocation.idLocation),
                      SplashState.allNearbyLocations = value.data!,
                      add(Initialize123(currentPosition: NavbarState.appbarlocation)),
                    }
                }
              else
                {updateLocation = true},

              if (updateLocation == true)
                {
                  if (value!.data!.length == 0)
                    {
                      NavbarState.appbarlocation = Data(),
                      SplashState.allNearbyLocations = value.data!,
                      add(Initialize123(currentPosition: Data())),
                    }
                  else if (value!.data!.length == 1)
                    {
                      // NavbarState.appbarlocation = value?.data?[0],
                      SplashState.allNearbyLocations = value.data!,
                      add(Initialize123(currentPosition: value!.data![0])),
                    }
                  else if (value!.data!.length > 1)
                    {
                      //       {
                      //         SplashState.appbarlocation = Data(),
                      SplashState.allNearbyLocations = value.data!,
                      // await EasyLoading.dismiss(),
                      emit(GoToLocationSelection(SplashState.allNearbyLocations)),
                      // add(Initialize123(currentPosition: Data())),
                      // },
                      // await EasyLoading.dismiss(),
                      // emit(GoToLocationSelection(SplashState.allNearbyLocations)),
                    },
                },
            });
  }
}