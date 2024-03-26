import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'package:dio/dio.dart';
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
import 'package:sharemagazines/src/models/location_model.dart';
import 'package:sharemagazines/src/models/magazineCategoryGetAllActive.dart';
import 'package:sharemagazines/src/models/magazinePublishedGetAllLastByHotspotId_model.dart';
import 'package:sharemagazines/src/resources/audiobook_repository.dart';
import 'package:sharemagazines/src/resources/ebook_repository.dart';
import 'package:sharemagazines/src/resources/hotspot_repository.dart';
import 'package:sharemagazines/src/resources/location_repository.dart';
import 'package:sharemagazines/src/resources/magazine_repository.dart';
import 'package:cookie_jar/cookie_jar.dart';

import '../../models/audioBooksForLocationGetAllActive.dart';
import '../../models/audiobookCategoryGetAllActiveByLocale.dart';
import '../../models/ebookCategoryGetAllActiveByLocale.dart';
import '../../models/ebooksForLocationGetAllActive.dart';
import '../../models/hotspots_model.dart';
import '../../models/locationGetHeader_model.dart';
import '../../models/locationOffers_model.dart';
import '../../models/place_map.dart';
import '../../presentation/widgets/src/easyloading/easy_loading.dart';
import '../../resources/dioClient.dart';

part 'navbar_event.dart';

part 'navbar_state.dart';

enum OfferType {
  image,
  video,
}

// enum NavbarItems { Home, Menu, Map, Account }

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  final MagazineRepository magazineRepository;
  final EbookRepository ebookRepository;
  final LocationRepository locationRepository;
  final HotspotRepository hotspotRepository;
  final AudioBookRepository audioBookRepository;
  List<String> navbarData = [];

  // late Future<HotspotsGetAllActive> hotspotList;
  NavbarState? previousState;

  late List<Future<Uint8List>> getTop = List.empty(growable: true);

  // Position? position = null;
  final GetIt getIt = GetIt.instance;

  // static late Future<LocationOffers>? maplocationoffers;
  var cookieJar = CookieJar();

  // GetIt getIt = GetIt.instance;
  CancelToken cancelToken = CancelToken();
  ApiClient dioClient = ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());

  NavbarBloc({required this.magazineRepository, required this.locationRepository, required this.hotspotRepository, required this.ebookRepository, required this.audioBookRepository})
      : super(LoadingNavbar(LocationData())) {
    on<InitializeNavbar>((event, emit) async {
      try {
        emit(LoadingNavbar(LocationData()));
        // event.timer?.cancel();
        await EasyLoading.show(
          status: 'Scanning locations nearby...',
          maskType: EasyLoadingMaskType.black,
        );
        Timer.periodic(Duration(seconds: 100), (Timer t) => checkLocationService());
        // Timer.periodic(Duration(seconds: 100), (Timer t) => checkLocation(state.appbarlocation));

        (await dioClient.secureStorage.read(key: "allmagazines").then((value) => {
          if (value != null) {NavbarState.magazinePublishedGetLastWithLimit = MagazinePublishedGetLastWithLimitFromJson(value)}
        }));
        // NavbarState.magazinePublishedGetLastWithLimit = MagazinePublishedGetAllLastByHotspotId(response: []);
        // NavbarState.magazinePublishedGetTopLastByRange = null;
        //
        // NavbarState.counterDE = 0;
        // NavbarState.counterEN = 0;
        // NavbarState.counterFR = 0;
        // NavbarState.counterES = 0;

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
        NavbarState.magazinePublishedGetLastWithLimit =MagazinePublishedGetAllLastByHotspotId(response: []);
        NavbarState.ebooks = EbooksForLocationGetAllActive(response: []);
        NavbarState.audiobooks = AudioBooksForLocationGetAllActive(response: []);
        NavbarState. magazineCategoryGetAllActive= MagazineCategoryGetAllActive(response: []);
        NavbarState.ebookCategoryGetAllActiveByLocale = EbookCategoryGetAllActiveByLocale(response: []);
        NavbarState.audioBooksCategoryGetAllActiveByLocale = AudiobookCategoryGetAllActiveByLocale(response: []);

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
        // print("Position lat");
        LocationPermission? permission = await Geolocator.checkPermission();
        print("Position lat");
        if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
          NavbarState.currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium).catchError(() => {
            // throw Exception("Failed to localize")
            emit(NavbarError("Geolocator error"))
          });
        }
        //Have to change this(remove splashstate)
        if (NavbarState.allNearbyLocations.length > 1) {
          await EasyLoading.dismiss();
          emit(GoToLocationSelection(NavbarState.allNearbyLocations, LocationData()));
        } else if (NavbarState.allNearbyLocations.length == 1) {
          // SplashState.appbarlocation = SplashState.allNearbyLocations[0];
          // state.appbarlocation = SplashState.allNearbyLocations[0];
          await EasyLoading.show(
            status: 'Entering ${NavbarState.allNearbyLocations[0].nameApp}',
            maskType: EasyLoadingMaskType.black,
          );
          print("ebooks2 counter ${NavbarState.allNearbyLocations[0].hasEbooksAudiobooks}");
          await GetAllMagazinesCover(int.parse(NavbarState.allNearbyLocations[0].idLocation!)).then((valueGetAllMagazinesCover) async => {
            if (NavbarState.allNearbyLocations[0].hasEbooksAudiobooks == "1")
              {
                await GetAllEbookAudiobooks(int.parse(NavbarState.allNearbyLocations[0].idLocation!))
              },
            // add(Menu()),
            // add(Home(event.currentPosition)),
            // event.timer?.cancel(),
            await EasyLoading.dismiss(),
            emit(NavbarLoaded(NavbarState.allNearbyLocations[0])), //(navbarData)),
            // emit(GoToHome(currentLocation: appbarlocation!)),
            print('EasyLoading dismiss 1 location'),
          });
        } else {
          // NavbarState.currentPosition = event.currentPosition!;
          // state.appbarlocation = event.currentPosition!;
          await GetAllMagazinesCover(int.parse("0")).then((valueGetAllMagazinesCover) async => {
            // add(Menu()),
            // add(Home(event.currentPosition)),
            // event.timer?.cancel(),
            await EasyLoading.dismiss(),
            emit(NavbarLoaded(LocationData())),
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
        emit(NavbarLoaded(state.appbarlocation));
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
          emit(AskForLocationPermission(state.appbarlocation));
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
        emit(GoToLanguageSelection(appbarlocation: event.currentLocation, languageOptions: event.languageOptions));
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

        emit(LoadingNavbar(event.currentLocation));
        // if (NavbarState.appbarlocation.idLocation != event.location!.idLocation) {
        //   await GetAllMagazinesCover(int.parse(event.location!.idLocation!), event).then((valueGetAllMagazinesCover) async => {
        //     await EasyLoading.dismiss(),
        //     emit(NavbarLoaded()),
        //   });
        // } else {
        // await Future.delayed(Duration(milliseconds: 700), () {});

        await EasyLoading.dismiss();
        emit(NavbarLoaded(event.currentLocation));
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
          status: 'Entering ${event.selectedLocation!.nameApp}...',
          maskType: EasyLoadingMaskType.black,
        );
        emit(LoadingNavbar(event.currentLocation!));
        print("ebooks counter ${state.appbarlocation}");
        if (event.currentLocation!.idLocation != event.selectedLocation!.idLocation) {
          // NavbarState.locationheader = null;
          // NavbarState.locationoffers = null;
          // NavbarState.locationoffers123 = null;
          // NavbarState.locationoffersImages =[] ;
          // NavbarState.locationoffersVideos = List.empty(growable: true);
          // NavbarState.locationImage = null;
          //
          // NavbarState.magazinePublishedGetLastWithLimit =MagazinePublishedGetAllLastByHotspotId(response: []);
          // NavbarState.ebooks = EbooksForLocationGetAllActive(response: []);
          // NavbarState.audiobooks = AudioBooksForLocationGetAllActive(response: []);
          // NavbarState. magazineCategoryGetAllActive= MagazineCategoryGetAllActive(response: []);
          // NavbarState.ebookCategoryGetAllActiveByLocale = EbookCategoryGetAllActiveByLocale(response: []);
          // NavbarState.audioBooksCategoryGetAllActiveByLocale = AudiobookCategoryGetAllActiveByLocale(response: []);

          await GetAllMagazinesCover(int.parse(event.selectedLocation!.idLocation ?? "0")).then((valueGetAllMagazinesCover) async => {
            await EasyLoading.dismiss(),
            {GetAllEbookAudiobooks(int.parse(NavbarState.allNearbyLocations[0].idLocation!))},
            emit(NavbarLoaded(event.selectedLocation!)),
          });

        } else {
          await EasyLoading.dismiss();
          emit(NavbarLoaded(event.currentLocation!));
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

    on<SelectCategory>((event, emit) async {
      try {
        NavbarState.categoryStatus.value = event.catStatus;
        // emit(NavbarLoaded(event.currentLocation!));
      } catch (error) {
        print("error - $error");
        emit(NavbarError(error.toString()));
      }
      ;
    });

    // on<GetCover>((event, emit) async {
    //   try {
    //
    //     DefaultCacheManager()
    //         .getFileFromCache(event.idMagazinePublication +
    //         "_" +
    //         event.dateOfPublication +
    //         "_0")
    //         .then((value) => {
    //       if (value?.file.lengthSync() == null)
    //         {
    //         print("get c ${event.idMagazinePublication}_${event.dateOfPublication}"),
    //           // print("page does not exist1 ${NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!} ${value?.file.lengthSync()}"),
    //           magazineRepository.GetPage(
    //               page: '0',
    //               id_mag_pub: event.idMagazinePublication,
    //               date_of_publication: event.dateOfPublication)
    //         }
    //     });
    //   } catch (e) {
    //     // statechanged = false;
    //     await EasyLoading.dismiss();
    //     emit(NavbarLoaded());
    //     // emit(NavbarError(e.toString()));
    //   }
    // });
  }

  Future<void> GetAllMagazinesCover(int locationID) async {
    // event?.timer?.cancel();xdcvx
    // await EasyLoading.show(
    //   status: 'loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );
    try {
      ///Clear everything for loading Information for the new location and
      ///go back to magazines Category, since the new location could possibly has no ebooks
      NavbarState.categoryStatus.value=CategoryStatus.presse;
      NavbarState.locationheader = null;
      NavbarState.locationoffers = null;
      // NavbarState.locationoffersImages;
      NavbarState.locationImage = null;
      NavbarState.locationoffersImages = [];

      NavbarState.magazinePublishedGetLastWithLimit = MagazinePublishedGetAllLastByHotspotId(response: []);
      NavbarState.magazinePublishedGetTopLastByRange = null;
      NavbarState.ebooks = EbooksForLocationGetAllActive(response: []);
      NavbarState.audiobooks = AudioBooksForLocationGetAllActive(response: []);
      NavbarState. magazineCategoryGetAllActive= MagazineCategoryGetAllActive(response: []);
      NavbarState.ebookCategoryGetAllActiveByLocale = EbookCategoryGetAllActiveByLocale(response: []);
      NavbarState.audioBooksCategoryGetAllActiveByLocale = AudiobookCategoryGetAllActiveByLocale(response: []);


      await magazineRepository.magazineCategoryGetAllActive().then((value) async => {NavbarState.magazineCategoryGetAllActive = value});
      print("GetAllMagazinesCover ${NavbarState.currentPosition?.latitude}");

      await locationRepository
          .checklocation(locationID.toString(), NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude, NavbarState.token,
              NavbarState.fingerprint)
          .then((value) async => {
                // SplashState.allNearbyLocations = value!.data!,
                // if (index != 0)

                // print(NavbarState.appbarlocation.idLocation),
                if (locationID == 0)
                  {
                    NavbarState.locationheader = locationRepository.GetLocationHeader(locationID: "1"),
                    await NavbarState.locationheader?.then((value) => {
                          // NavbarStaprint('filepath ${value.filePath}'),
                          if (value.filePath != "")
                            { NavbarState.locationImage = locationRepository.GetLocationImage(locationID: '1', filePath: value.filePath.toString())}
                        }),
                    // NavbarState.locationoffers = locationRepository.GetLocationOffers(locationID: locationID.toString()),
                    // NavbarState.locationoffers?.then((value) => {
                    //       // NavbarState.locationheader = value,
                    //       if (value.locationOffer!.length > 0)
                    //         {
                    //           value.locationOffer?.forEach((element) {
                    //             if (element.shm2Offer![0].type!.contains("MOV")) {
                    //               NavbarState.locationoffersVideos!.add(locationRepository.GetLocationOfferVideo(
                    //                   offerID: element.shm2Offer![0].id.toString(), filePath: element.shm2Offer![0].data!));
                    //             }
                    //             // else{
                    //             NavbarState.locationoffersImages!.add(locationRepository.GetLocationOfferImage(
                    //                 offerID: element.idOffer.toString(), filePath: element.shm2Offer![0].data!));
                    //             // }
                    //           })
                    //         }
                    //     }),
                  }
                else
                  { print( "NavbarState.locationheader.toString()"),
                    // print( NavbarState.locationheader.),
                    // NavbarState.appbarlocation = value!.data![0],
                     NavbarState.locationheader = locationRepository.GetLocationHeader(locationID: locationID.toString()),
                    await NavbarState.locationheader?.then((value) => {
                          // NavbarState.locationheader = value,

                          if (value.filePath != "")
                            {
                                NavbarState.locationImage =
                                  locationRepository.GetLocationImage(locationID: locationID.toString(), filePath: value.filePath.toString())
                            }else{
                            NavbarState.locationImage=null
                          }
                        }),
                    // NavbarState.locationoffers = locationRepository.GetLocationOffers(locationID: locationID.toString()),
                    // NavbarState.locationoffers?.then((value) => {
                    //       // NavbarState.locationheader = value,
                    //       if (value.locationOffer!.length > 0)
                    //         {
                    //           value.locationOffer?.forEach((element) {
                    //             if (element.shm2Offer![0].type!.contains("MOV")) {
                    //               NavbarState.locationoffersVideos!.add(locationRepository.GetLocationOfferVideo(
                    //                   offerID: element.shm2Offer![0].id.toString(), filePath: element.shm2Offer![0].data!));
                    //             }
                    //             // else{
                    //             NavbarState.locationoffersImages!.add(locationRepository.GetLocationOfferImage(
                    //                 offerID: element.idOffer.toString(), filePath: element.shm2Offer![0].data!));
                    //             // }
                    //           })
                    //         }
                    //     }),
                    await magazineRepository
                        .magazinePublishedGetTopLastByRange(id_hotspot: locationID.toString(), cookieJar: cookieJar)
                        .then((value) async => {
                              NavbarState.magazinePublishedGetTopLastByRange = value,
                              // magazinePublishedGetLastWithLimitdata_navbarBloc = value,
                              for (var i = 0; i < value.response()!.length; i++)
                                {
                                  // for (var k = 1; k < int.parse(value.response![i].pageMax!); k++)
                                  //   {
                                  //     DefaultCacheManager()
                                  //         .getFileFromCache(value.response![i].idMagazinePublication! +
                                  //             "_" +
                                  //             value.response![i].dateOfPublication! +
                                  //             "_" +
                                  //             k.toString())
                                  //         .then((valueCache) => {
                                  //               if (valueCache == null)
                                  //                 {
                                  //                   magazineRepository.GetPagesforReader(
                                  //                       page: k,
                                  //                       id_mag_pub: value.response![i].idMagazinePublication,
                                  //                       date_of_publication: value.response![i].dateOfPublication,
                                  //                       readerCancelToken: cancelToken)
                                  //
                                  //                   // for (var i = 0; i < int.parse(value. .magazine.pageMax!); i++) {},
                                  //                   // NavbarState.getTopMagazines?.add(magazineRepository.GetPage(
                                  //                   //     page: '0',
                                  //                   //     id_mag_pub: NavbarState.magazinePublishedGetTopLastByRange?.response![i].idMagazinePublication!,
                                  //                   //     date_of_publication: NavbarState.magazinePublishedGetTopLastByRange?.response![i].dateOfPublication!)),
                                  //                   // print("magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication! = ${futureFunc[i].toString()}");
                                  //                 },
                                  //             }),
                                  //     // magazineRepository.GetPagesforReader(
                                  //     //     page: k, id_mag_pub: value.response![i].idMagazinePublication, date_of_publication: value.response![i].dateOfPublication, readerCancelToken: cancelToken)
                                  //   },
                                  DefaultCacheManager()
                                      .getFileFromCache(
                                          value.response()![i].idMagazinePublication! + "_" + value.response()![i].dateOfPublication! + "_" + "0")
                                      .then((valueCache) async => {
                                            if (valueCache?.file.lengthSync() == null)
                                              {
                                                // print("page does not exist1 ${NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!} ${value?.file.lengthSync()}"),
                                                magazineRepository.GetPage(
                                                    page: '0',
                                                    id_mag_pub: value.response()![i].idMagazinePublication!,
                                                    date_of_publication: value.response()![i].dateOfPublication!)
                                              }
                                          }),
                                },
                              // event?.timer?.cancel(),
                              // EasyLoading.dismiss(),
                            }),
                  },

                NavbarState.locationoffers = locationRepository.GetLocationOffers(locationID: locationID != 0 ? locationID.toString() : "1"),
                // NavbarState.locationoffers = locationRepository.GetLocationOffers(locationID: locationID != 0 ? locationID.toString() : "1");
                await NavbarState.locationoffers!.then((value) async {
                  if (value.locationOffer!.isNotEmpty) {
                    List<Future<Uint8List>> imageLoadFutures = [];

                    for (var element in value.locationOffer!) {
                      if (!element.shm2Offer![0].type!.contains("MOV")) {
                        // Collect futures for loading images

                            locationRepository.GetLocationOfferImage(offerID: element.idOffer.toString(), filePath: element.shm2Offer![0].data!)
                                .then((Uint8List image)  {
                          NavbarState.locationoffersImages.add(OfferImage(image, element));
                        });

                      } else {
                        // Collect futures for loading videos

                            locationRepository.GetLocationOfferVideo(offerID: element.idOffer.toString(), filePath: element.shm2Offer![0].data!)
                                .then((File video) {
                          NavbarState.locationoffersImages.add(OfferImage(video, element));
                        });
                        // imageLoadFutures.add(future);
                      }
                    }

                    // Wait for all futures to complete
                    // await Future.wait(imageLoadFutures);
                  }
                  // Now, NavbarState.locationoffersImages is fully populated
                }),

                // NavbarState.locationoffers!.then((value) {
                //   // NavbarState.locationheader = value,
                //   if (value.locationOffer!.length > 0) {
                //     value.locationOffer?.forEach((element) async {
                //       if (!element.shm2Offer![0].type!.contains("MOV")) {
                //         Uint8List image = await locationRepository.GetLocationOfferImage(
                //             offerID: element.idOffer.toString(),
                //             filePath: element.shm2Offer![0].data!
                //         );
                //         NavbarState.locationoffersImages!.add(OfferImage(image, element));
                //         // NavbarState.locationoffers123=(OfferImage(image, element));
                //
                //       } else {
                //         File video = await locationRepository.GetLocationOfferVideo(offerID: element.idOffer.toString(),
                //             filePath: element.shm2Offer![0].data!);
                //         NavbarState.locationoffersImages!.add(OfferImage(video, element));
                //       }
                //       // if (element.shm2Offer![0].type!.contains("MOV")) {
                //       //   NavbarState.locationoffersVideos!.add(locationRepository.GetLocationOfferVideo(
                //       //       offerID: element.shm2Offer![0].id.toString(), filePath: element.shm2Offer![0].data!));
                //       // }
                //       // else{
                //       // if (element.shm2Offer![0].type!.contains("PIC") || element.shm2Offer![0].type!.contains("PDF")) {
                //       //   NavbarState.locationoffersImages!.add(
                //       //        await locationRepository.GetLocationOfferImage(offerID: element.idOffer.toString(), filePath: element.shm2Offer![0].data!));
                //       // NavbarState.locationoffersImages!.add(OfferImage(image, element));
                //
                //       // }
                //       // else if (element.shm2Offer![0].type!.contains("MOV")) {
                //       //   NavbarState.locationoffersImages!.add(
                //       //      await locationRepository.GetLocationOfferImage(offerID: element.idOffer.toString(), filePath: element.shm2Offer![0].data!));
                //       // }
                //     });
                //   }
                // }),
                print(NavbarState.locationoffersImages),

                await magazineRepository
                    .magazinePublishedGetAllLastByHotspotId(id_hotspot: locationID.toString(), cookieJar: cookieJar)
                    .then((data) async {
                  NavbarState.magazinePublishedGetLastWithLimit = data;
                  // dioClient.secureStorage.write(key: "allmagazines", value: data);

                  for (var i = 0; i < NavbarState.magazinePublishedGetLastWithLimit.response()!.length; i++) {
                    // if (NavbarState.magazinePublishedGetLastWithLimit!.response![i].idsMagazineCategory!.contains('35')==true)
                    //   DefaultCacheManager()
                    //     .getFileFromCache(NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication! +
                    //         "_" +
                    //         NavbarState.magazinePublishedGetLastWithLimit!.response![i].dateOfPublication! +
                    //         "_0")
                    //     .then((value) => {
                    //           if (value?.file.lengthSync() == null)
                    //             {
                    //               // print("page does not exist1 ${NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!} ${value?.file.lengthSync()}"),
                    //               magazineRepository.GetPage(
                    //                   page: '0',
                    //                   id_mag_pub: NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!,
                    //                   date_of_publication: NavbarState.magazinePublishedGetLastWithLimit!.response![i].dateOfPublication!)
                    //             }
                    //         });
                  }
                  // event?.timer?.cancel();
                  // await EasyLoading.dismiss();
                }),
              });
    } on Exception catch (e) {
      // TODO
      emit(NavbarError(e.toString()));
    } on TypeError catch (e) {
      print('An Error Occurred $e');
      emit(NavbarError(e.toString()));
    } on SocketException {
      rethrow;
    } catch (e) {
      print('An Error Occurred $e');
      throw Exception("Failed to login. Code ${e}");
    }
  }

  Future<void> GetAllEbookAudiobooks(int locationID) async {
    try {
      print("GetAllEbookAudiobooks");
       await ebookRepository.ebooksCategoryGetAllActive().then((value) async => {NavbarState.ebookCategoryGetAllActiveByLocale = value});
      print("ebooksCategoryGetAllActive ${NavbarState.currentPosition?.latitude}");
      await ebookRepository.ebooksForLocationGetAllActive(id_hotspot: locationID.toString()).then((value) => NavbarState.ebooks = value);
      // print("audioBooksCategoryGetAllActive ${NavbarState.currentPosition?.latitude}");
      await  audioBookRepository.audioBooksCategoryGetAllActive().then((value) => NavbarState.audioBooksCategoryGetAllActiveByLocale = value);
       // print("audioBooksForLocationGetAllActive");
      await  audioBookRepository.audioBooksForLocationGetAllActive(id_hotspot: locationID.toString()).then((value) async => {NavbarState.audiobooks = value});

    } on Exception {
      // TODO
      // emit(NavbarError(e.toString()));
    } on TypeError catch (e) {
      print('An Error Occurred $e');
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
      emit(AskForLocationPermission(state.appbarlocation));
    }
  }

  Future<bool> qr(String code, String fingerprint) async {
    try {
      // emit(Loading());
      // event.timer?.cancel();
      await EasyLoading.show(
        status: 'Verifying QR Code...',
        maskType: EasyLoadingMaskType.black,
      );
      await locationRepository.checklocation(null, null, null, code, fingerprint).then((value) async => {
            if (value?.code == 501)
              {
                NavbarState.token = code,
                NavbarState.fingerprint = fingerprint,
                await GetAllMagazinesCover(int.parse(value!.data![0].idLocation!)).then((valueGetAllMagazinesCover) async => {
                      emit(NavbarLoaded(value.data![0])),
                    })
              }
          });
      await EasyLoading.dismiss();
      return true;
    } catch (e) {
      await EasyLoading.dismiss();
      // emit(NavbarError(e.toString()));
      return false;
    }
  }


  Future<Uint8List> getAudioBookCover(String idEbook, String dateOfPublication, String pageNo) async {
    FileInfo? cacheFile = await DefaultCacheManager().getFileFromCache(idEbook + "_" + dateOfPublication+"audiobook" );
    if (cacheFile?.file.lengthSync() == null) {
      return await audioBookRepository.GetAudioBookCover(id_audiobook: idEbook,dateOfPublication: dateOfPublication
        // , readerCancelToken: readerCancelToken
      );
    }else{
      return cacheFile!.file.readAsBytes();
    }
  }

  Future<Uint8List> getEbookCover(String idEbook, String dateOfPublication, String pageNo) async {
    FileInfo? cacheFile = await DefaultCacheManager().getFileFromCache(idEbook + "_" + dateOfPublication +"ebook");
    if (cacheFile?.file.lengthSync() == null) {
      return await ebookRepository.GetEbookCover(id_ebook: idEbook,dateOfPublication: dateOfPublication
          // , readerCancelToken: readerCancelToken
          );
    }else{
      return cacheFile!.file.readAsBytes();
    }
  }
  Future<Uint8List> getEbookFile(String idEbook, String dateOfPublication) async {
    FileInfo? cacheFile = await DefaultCacheManager().getFileFromCache(idEbook + "_" + dateOfPublication+"file" );
    if (cacheFile?.file.lengthSync() == null) {
      return await ebookRepository.GetEbookPages(id_ebook: idEbook,dateOfPublication: dateOfPublication
        // , readerCancelToken: readerCancelToken
      );
    }else{
      return cacheFile!.file.readAsBytes();
    }
  }

  Future<Uint8List> getCover(String idMagazinePublication, String? dateOfPublication, String pageNo, bool thumbNail, bool preloadneigbor) async {
    // print("getcover " +idMagazinePublication);
    FileInfo? cacheFile = await DefaultCacheManager().getFileFromCache(
        idMagazinePublication + "_" + (dateOfPublication ?? "puzzle.dart") + "_" + pageNo + (thumbNail == true ? '_thumbnail' : ''));
    // if(preloadneigbor){
    //   if(pageNo == "0"){
    //     final FileInfo? cache1 = await DefaultCacheManager()
    //         .getFileFromCache(idMagazinePublication + "_" + dateOfPublication + "_" +" ${int.parse(pageNo)+1}" + '');
    //     if (cache1?.file.lengthSync() == null) {
    //         await magazineRepository.GetThumbnailforReader(
    //           page: int.parse(pageNo) + 1, id_mag_pub: idMagazinePublication, date_of_publication: dateOfPublication
    //           // , readerCancelToken: readerCancelToken
    //           );
    //     }
    //   }
    //
    // }
    // print("get cover ${idMagazinePublication}_${dateOfPublication}_$pageNo $thumbNail");
    // print("getcover 1" +idMagazinePublication);
    if (cacheFile?.file.lengthSync() == null) {
      // print("get thumbnail $thumbNail ${idMagazinePublication}_${dateOfPublication}_$pageNo");
      // If the file is not in the cache, fetch it from the repository
      if (thumbNail) {
        return await magazineRepository.GetThumbnailforReader(
            page: int.parse(pageNo), id_mag_pub: idMagazinePublication, date_of_publication: dateOfPublication
            // , readerCancelToken: readerCancelToken
            );
      }
      // print("getcover 2" +idMagazinePublication);
      // if(int.parse(pageNo) < )
      if (preloadneigbor) {
        final FileInfo? cacheFile2 = await DefaultCacheManager()
            .getFileFromCache(idMagazinePublication + "_" + (dateOfPublication ?? "puzzle.dart") + "_" + "${int.parse(pageNo) + 1}");
        if (cacheFile2?.file.lengthSync() == null) {
          magazineRepository.GetPage(
            page: "${int.parse(pageNo) + 1}",
            id_mag_pub: idMagazinePublication,
            date_of_publication: dateOfPublication,
          );
        }
      }
      print(idMagazinePublication);
      return await magazineRepository.GetPage(
        page: pageNo,
        id_mag_pub: idMagazinePublication,
        date_of_publication: dateOfPublication,
      );
    } else {
      // print("no get");
      // If the file is in the cache, return its content as Uint8List
      return cacheFile!.file.readAsBytes();
    }
    //     .then((value)async => {
    // if (value?.file.lengthSync() == null)
    // {
    //     print("get c ${idMagazinePublication}_${dateOfPublication}"),
    // // print("page does not exist1 ${NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!} ${value?.file.lengthSync()}"),
    // return await magazineRepository.GetPage(
    // page: '0',
    // id_mag_pub: idMagazinePublication,
    // date_of_publication: dateOfPublication)
    // }}
    // );
  }

  Future<void> checkLocation(LocationData currentLocation) async {
    bool updateLocation = false;
    await locationRepository
        .checklocation(
            null, NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude, NavbarState.token, NavbarState.fingerprint)
        .then((value) async => {
              // print("bloc LocationRefresh ${appbarlocation!.idLocation}"),
              // print("bloc LocationRefresh ${appbarlocation.idLocation} ${value!.data!}"),
              // updateLocation = value!.data!.length == 0 ? false : true,
              if (value!.data!.length == 0)
                {
                  if (currentLocation.idLocation == null) {updateLocation = false} else {updateLocation = true}
                }
              else if (value.data!.length == 1)
                {
                  if (currentLocation.idLocation != value.data![0].idLocation)
                    {
                      // state.appbarlocation = Data(),
                      print(currentLocation.idLocation),
                      NavbarState.allNearbyLocations = value.data!,
                      add(InitializeNavbar(currentPosition: value.data![0])),
                    }
                }
              else
                {updateLocation = true},

              if (updateLocation == true)
                {
                  if (value.data!.length == 0)
                    {
                      currentLocation = LocationData(),
                      NavbarState.allNearbyLocations = value.data!,
                      add(InitializeNavbar(currentPosition: LocationData())),
                    }
                  else if (value.data!.length == 1)
                    {
                      // NavbarState.appbarlocation = value?.data?[0],
                      NavbarState.allNearbyLocations = value.data!,
                      add(InitializeNavbar(currentPosition: value.data![0])),
                    }
                  else if (value.data!.length > 1)
                    {
                      //       {
                      //         SplashState.appbarlocation = Data(),
                      NavbarState.allNearbyLocations = value.data!,
                      // await EasyLoading.dismiss(),
                      emit(GoToLocationSelection(NavbarState.allNearbyLocations, currentLocation)),
                      // add(Initialize123(currentPosition: Data())),
                      // },
                      // await EasyLoading.dismiss(),
                      // emit(GoToLocationSelection(SplashState.allNearbyLocations)),
                    },
                },
            });
  }
}