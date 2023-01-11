import 'dart:async';

import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get_it/get_it.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sharemagazines_flutter/src/models/location_model.dart';
import 'package:sharemagazines_flutter/src/models/magazinePublishedGetAllLastByHotspotId_model.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';
import 'package:sharemagazines_flutter/src/resources/location_repository.dart';
import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';
import 'package:cookie_jar/cookie_jar.dart';

import '../../models/hotspots_model.dart';
import '../../presentation/widgets/place_map.dart';
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
  late Data appbarlocation;
  bool statechanged = false;
  late List<Future<Uint8List>> getTop = List.empty(growable: true);
  // Position? position = null;
  final GetIt getIt = GetIt.instance;
  var cookieJar = CookieJar();
  // GetIt getIt = GetIt.instance;

  Future<void> GetAllMagazinesCover(int locationID, NavbarEvent? event) async {
    // event?.timer?.cancel();
    // await EasyLoading.show(
    //   status: 'loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );
    print("GetAllMagazinesCover ${NavbarState.currentPosition?.latitude}");
    await locationRepository.checklocation(locationID.toString(), NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude).then((value) async => {
          // if (index != 0)
          if (locationID != 0)
            {
              await magazineRepository.magazinePublishedGetTopLastByRange(id_hotspot: locationID.toString(), cookieJar: cookieJar).then((value) async => {
                    NavbarState.magazinePublishedGetTopLastByRange = value,
                    // magazinePublishedGetLastWithLimitdata_navbarBloc = value,
                    for (var i = 0; i < value.response!.length; i++)
                      {
                        NavbarState.getTopMagazines?.add(magazineRepository.GetPage(page: '0', id_mag_pub: NavbarState.magazinePublishedGetTopLastByRange?.response![i].idMagazinePublication!)),
                        // print("magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication! = ${futureFunc[i].toString()}");
                      },
                    event?.timer?.cancel(),
                    await EasyLoading.dismiss(),
                  })
            },
          await magazineRepository.magazinePublishedGetAllLastByHotspotId(id_hotspot: locationID.toString(), cookieJar: cookieJar).then((data) async {
            NavbarState.magazinePublishedGetLastWithLimit = data;
            for (var i = 0; i < NavbarState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
              NavbarState.languageResultsALL?.add(magazineRepository.GetPage(page: '0', id_mag_pub: NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!));
              if (NavbarState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("de")) {
                NavbarState.languageResultsDE?.add(NavbarState.languageResultsALL![i]);
              }
              if (NavbarState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("en")) {
                NavbarState.languageResultsEN?.add(NavbarState.languageResultsALL![i]);
              }
              if (NavbarState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("fr")) {
                NavbarState.languageResultsFR?.add(NavbarState.languageResultsALL![i]);
              }
            }
            event?.timer?.cancel();
            await EasyLoading.dismiss();
          }),
        });
  }

  NavbarBloc({required this.magazineRepository, required this.locationRepository, required this.hotspotRepository}) : super(Loading()) {
    on<Initialize123>((event, emit) async {
      print("access token");
      event.timer?.cancel();
      await EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
      print('EasyLoading show Initialize123');
      NavbarState.languageResultsALL?.clear();
      NavbarState.languageResultsDE?.clear();
      NavbarState.languageResultsEN?.clear();
      NavbarState.languageResultsFR?.clear();
      // print(dioClient.accessToken);
      NavbarState.hotspotList = hotspotRepository.GetAllActiveHotspots();
      // await NavbarState.hotspotList;
      NavbarState.hotspotList.then((data) {
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
        NavbarState.currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium).catchError(() => {throw Exception("Failed to localize")});
      }

      print("Position lat");
      await locationRepository.checklocation(null, NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude).then((value) async => {
            // print("checklocation value ${value!.data}"),
            locationResponse = value,
            // for (var i = 0; i < appbarlocation.data!.length; i++){
            //
            // },
            // if (value.code)
            // await locationRepository.checklocation(value!.data![0].idLocation),
            print("value!.data!.length! ${value!.data!.length}"),
            print("value!.data!.length! }"),
            if (value.data!.length > 1)
              {
                add(LocationSelection()),
                event.timer?.cancel(),
                await EasyLoading.dismiss(),
                print('EasyLoading dismiss 3'),
              }
            else if (value.data!.length == 1)
              {
                // add(Home(value!.data![0])),
                // await GetAllMagazinesCover(int.parse(value!.data![0].idLocation!)),
                appbarlocation = value.data![0],
                print("appbarlocation = Data(),"),
                await GetAllMagazinesCover(int.parse(value.data![0].idLocation!), event).then((valueGetAllMagazinesCover) async => {
                      add(Home(value.data![0])),
                      event.timer?.cancel(),
                      await EasyLoading.dismiss(),
                      print('EasyLoading dismiss 1'),
                    }),
                // event.timer?.cancel(),
                // await EasyLoading.dismiss(),
              }
            // else if (value!.data!.length! == 0)
            else
              {
                appbarlocation = Data(),

                await GetAllMagazinesCover(int.parse("0"), null).then((value) async => {
                      add(Home()),
                      event.timer?.cancel(),
                      await EasyLoading.dismiss(),
                      print('EasyLoading dismiss 2'),
                    }),
                // add(Home()),
              },
            print("Breakpoint"),
          });
    });

    on<Home>((event, emit) async {
      try {
        // print(futureFuncLanguageResultsALL[1].toString());
        // emit(GoToHome(magazinePublishedGetLastWithLimitdata, getTop, futureFuncLanguageResultsALL, futureFuncLanguageResultsDE, futureFuncLanguageResultsEN, futureFuncLanguageResultsFR,
        //     locationResponse, appbarlocation));
        // emit(GoToHome(magazinePublishedGetLastWithLimitdata_navbarBloc, futureFuncLanguageResultsALL, futureFuncLanguageResultsDE, futureFuncLanguageResultsEN, futureFuncLanguageResultsFR,
        //     locationResponse, appbarlocation));
        emit(GoToHome(NavbarState.magazinePublishedGetLastWithLimit, NavbarState.languageResultsALL, NavbarState.languageResultsDE, NavbarState.languageResultsEN, NavbarState.languageResultsFR,
            locationResponse, appbarlocation));

        print("Navbarbloc home event emitted123");
        // emit(GoToHome());
        // });
        statechanged = false;

        // statsechanged = true;
      } catch (e) {
        // statechanged = false;
        print(e);
      }
    });

    on<Menu>((event, emit) async {
      statechanged = true;
      emit(GoToMenu(locationResponse, appbarlocation));
      statechanged = false;
    });

    on<Map>((event, emit) async {
      statechanged = true;
      emit(GoToMap());
      statechanged = false;
    });

    on<AccountEvent>((event, emit) async {
      statechanged = true;
      emit(GoToAccount(null, null, null));
      statechanged = false;
    });

    on<LocationSelection>((event, emit) async {
      print("emit(GoToLocationSelection(null, null, locationResponse)); ${event.location?.idLocation},");
      statechanged = true;
      if (event.location?.idLocation != null) {
        event.timer?.cancel();
        await EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
        appbarlocation = event.location!;
        await GetAllMagazinesCover(int.parse(event.location!.idLocation!), event).then((valueGetAllMagazinesCover) async => {
              add(Home(event.location!)),
              event.timer?.cancel(),
              await EasyLoading.dismiss(),
            });
      } else {
        emit(GoToLocationSelection(locationResponse));
      }
      statechanged = false;
    });
  }

  Future<void> checkLocation(Timer? timer) async {
    statechanged = true;

    // await EasyLoading.show(
    //   status: 'loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );
    print("bloc LocationRefresh");
    await locationRepository.checklocation(null, NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude).then((value) async => {
          print("bloc LocationRefresh ${appbarlocation.idLocation}"),
          // print("bloc LocationRefresh ${appbarlocation.idLocation} ${value!.data!}"),

          if (appbarlocation.idLocation == null)
            {
              if (value!.data!.length > 0)
                {add(Initialize123())}
              else
                {
                  // event.timer?.cancel(),
                  // await EasyLoading.dismiss(),
                }
            }
          else
            {
              // nearbyLocationIDs = [],
              // for (int i = 0; i < value!.data!.length; i++) {},
              for (int i = 0; i < value!.data!.length; i++)
                {
                  if (appbarlocation.idLocation == value.data![i].idLocation)
                    {
                      await EasyLoading.dismiss(),
                    }
                },
              // if (value!.data!.length == 0)
              //   {
              //     add(Initialize123(event.timer)),
              //   },
              if (timer?.isActive == true || value.data!.length == 0)
                {
                  add(Initialize123()),
                }
              // if (value!.data!.contains("appbarlocation") == false)
              //   {
              //     add(Initialize123(event.timer)),
              //   }
              // else
              //   {
              //     // event.timer?.cancel(),
              //     // await EasyLoading.dismiss(),
              //   }
            },
          // {add(Initialize123(event.timer))},
          statechanged = false,
          timer?.cancel(),
          await EasyLoading.dismiss(),
        });

    // emit(GoToLocationSelection(null, null, locationResponse));
    // });
// on<Location>((event, emit) async {
//   emit(GoToLocation());
//   // statechanged = true;
// });
// on<Search>((event, emit) async {
//   emit(GoToSearch());
//   // statechanged = true;
// });
  }
  // void getNavBarItem(NavbarItems navbarItem) {
  //   switch (navbarItem) {
  //     case NavbarItems.Home:
  //       emit(NavbarState(NavbarItems.Home, 0));
  //       break;
  //     case NavbarItems.Menu:
  //       emit(NavbarState(NavbarItems.Menu, 1));
  //       break;
  //     case NavbarItems.Map:
  //       emit(NavbarState(NavbarItems.Map, 2));
  //       break;
  //     case NavbarItems.Account:
  //       emit(NavbarState(NavbarItems.Account, 3));
  //       break;
  //   }
  // }
}