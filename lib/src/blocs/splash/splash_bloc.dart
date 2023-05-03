import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/resources/auth_repository.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';

import '../../models/hotspots_model.dart';
import '../../models/location_model.dart';
import '../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../resources/dioClient.dart';
import '../../resources/location_repository.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final getIt = GetIt.instance;
  final AuthRepository authRepository;
  final LocationRepository locationRepository;
  ApiClient dioClient = ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());

  SplashBloc({required this.authRepository, required this.locationRepository}) : super(Initial()) {
    // on<NavigateToHomeEvent>((event, emit) async {
    //   emit(Loading());
    // });

    on<NavigateToHomeEvent>((event, emit) async {
      getIt.registerSingleton<ApiClient>(ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage()), signalsReady: true);
      // await dioClient.secureStorage.deleteAll;
      String? emailExists = await dioClient.secureStorage.read(key: "email");
      String? existingpwd = await dioClient.secureStorage.read(key: "pwd");

      //emit(LoadingSplash());

      // late GoogleMapController mapController;
      // await Future.delayed(Duration(seconds: 2)); // This is to simulate that above checking process
      bool serviceEnabled;
      // await Geolocator.();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        // return Future.error('Location services are disabled.');
        // emit(Loaded());
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          // return Future.error('Location permissions are denied');
          // emit(Loaded());
        }
      }
      if (permission == LocationPermission.denied) {
        print("splash permission");

        await Geolocator.requestPermission();
        permission = await Geolocator.requestPermission();
        // openAppSettings();
        // return Future.error(Exception('Location permissions are denied.'));
        // Permissions are denied forever, handle appropriately.
        // return Future.error('Location permissions are permanently denied, we cannot request permissions.');
        // emit(Loaded());
      }
      if (permission == LocationPermission.deniedForever) {
        print("splash permission");
        await Geolocator.requestPermission();
        // throw Exception("sdcds");
        // openAppSettings();
        permission = await Geolocator.requestPermission();
        // return Future.error(Exception('Location permissions are denied.'));
        // Permissions are denied forever, handle appropriately.
        // return Future.error('Location permissions are permanently denied, we cannot request permissions.');
        // emit(Loaded());
      }
      print("splash permission");
      print(permission);

      Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium).catchError(() => {emit(SplashError())});

      await locationRepository.checklocation(null, currentPosition.latitude, currentPosition.longitude).then((value) async => {
            if (value!.data!.length > 1)
              {
                // SplashState.appbarlocation = value.data![1],
                add(LocationSelection(locations: value.data!)),
                // await locationRepository.checklocation(value!.data![0].idLocation!, currentPosition?.latitude, currentPosition?.longitude).then((value) async => {})
              }
            else if (value!.data!.length == 1)
              {
                print("debug"),
                print(value.data![0].nameApp),
                SplashState.appbarlocation = value.data![0],
                emit(Loaded(currentLocation: value.data![0]))
                // await locationRepository.checklocation(value!.data![0] .toString(), NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude).then((value) async => {
              }
            else
              {SplashState.appbarlocation = Data(), emit(Loaded(currentLocation: Data()))},
            // if (emailExists != null && existingpwd != null)
            //   {
            //     emit(SkipLogin(emailExists, existingpwd, value!.data![0])),
            //     // return
            //   }
            // else
            //   {SplashState.appbarlocation = Data(), emit(Loaded(currentLocation: Data()))}
          });

      // if (emailExists != null && existingpwd != null) {
      //   emit(SkipLogin(emailExists, existingpwd));
      //   return;
      // }
      // emit(Loaded(currentLocation: Data()));
      // emit(Loaded());
      // emit(Loaded(await Geolocator.getCurrentPosition())); // In this state we can load the HOME PAGE
    });
    on<LocationSelection>((event, emit) async {
      // print("emit(GoToLocationSelection(null, null, locationResponse)); ${event.location?.idLocation},");
      // statechanged = true;
      // if (event.location?.idLocation != null) {
      //   event.timer?.cancel();
      //   await EasyLoading.show(
      //     status: 'loading...',
      //     maskType: EasyLoadingMaskType.black,
      //   );
      //   appbarlocation = event.location!;
      //   await GetAllMagazinesCover(int.parse(event.location!.idLocation!), event).then((valueGetAllMagazinesCover) async => {
      //         add(Home(event.location!)),
      //         event.timer?.cancel(),
      //         await EasyLoading.dismiss(),
      //       });
      // } else {
      try {
        await EasyLoading.dismiss();
        emit(GoToLocationSelection(event.locations));
        // }
        // statechanged = false;
      } on Exception catch (e) {
        emit(SplashError());
        print(e);
      }
    });
  }
}