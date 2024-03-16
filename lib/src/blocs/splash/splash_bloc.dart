import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:sharemagazines/src/resources/auth_repository.dart';

import '../../models/location_model.dart';
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
    on<NavigateToHomeEvent>((event, emit) async {
      // try {
        String? emailExists;
        String? existingpwd;
        bool serviceEnabled;
        LocationPermission permission;
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        Position? currentPosition;

        // Uncomment to debug - this will delete all cache
        // await DefaultCacheManager().emptyCache();
        // dioClient.secureStorage.deleteAll();

        // To have only one instance of ApiClient
        if (!getIt.isRegistered<ApiClient>()) {
          getIt.registerSingleton<ApiClient>(
              ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage()),
              signalsReady: true);
          // getIt.registerSingleton<LoadingAnimation>(LoadingAnimation(), signalsReady: true);
        }

        String? emailExistsIncomplete = await dioClient.secureStorage.read(key: "emailGuest");
        String? existingpwdIncomplete = await dioClient.secureStorage.read(key: "pwdGuest");
        if (await dioClient.secureStorage.read(key: "email") != null && await dioClient.secureStorage.read(key: "email") != null) {
          emailExists = await dioClient.secureStorage.read(key: "email");
          existingpwd = await dioClient.secureStorage.read(key: "pwd");
        }

        // if (!serviceEnabled) {
        //   // Location services are not enabled don't continue
        //   // accessing the position and request users of the
        //   // App to enable the location services.
        //   // return Future.error('Location services are disabled.');
        //   // emit(Loaded());
        //   SplashError("Please activate location services");
        //
        //   await locationRepository.checklocation(null, null, null).then((value) async => {
        //         print("debug"),
        //         if (value!.data!.length != 0)
        //           {
        //             // SplashState.appbarlocation = value?.data?[0],
        //             SplashState.allNearbyLocations = value.data!
        //           },
        //         if (emailExists != null && existingpwd != null)
        //           {emit(SkipLogin(emailExists, existingpwd))}
        //         else if (emailExistsIncomplete != null && existingpwdIncomplete != null)
        //           {emit(SkipLoginIncomplete(emailExistsIncomplete, existingpwdIncomplete))}
        //         else
        //           {emit(Loaded())}
        //       });
        //   // emit(SplashError("Location services are not enabled"));
        //   // if (!await Geolocator.isLocationServiceEnabled()) {
        //   //   // If the user still didn't enable the location service, handle this case.
        //   //   // You can show a dialog or a snackbar to inform the user that the app requires location services.
        //   // };
        // }
          permission = await Geolocator.checkPermission();


        // permission = await Geolocator.requestPermission();
        // if ( permission == LocationPermission.deniedForever) {
        //   // Permissions are denied, next time you could try
        //   // requesting permissions again (this is also where
        //   // Android's shouldShowRequestPermissionRationale
        //   // returned true. According to Android guidelines
        //   // your App should show an explanatory UI now.
        //   // return Future.error('Location permissions are denied');
        //   // emit(Loaded());
        //   // emit(SplashError("Location services are not enabled"));
        //   // permission = await Geolocator.requestPermission();
        //
        // // } else if (permission == LocationPermission.denied ||permission == LocationPermission.unableToDetermine) {
        // //   permission = await Geolocator.requestPermission();
        // } else
        if(permission == LocationPermission.denied|| permission == LocationPermission.unableToDetermine){
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          // await locationRepository.checklocation(null, currentPosition.latitude, currentPosition.longitude).then((value) async => {
          //       print("debug"),
          //       // print(value.data![0].nameApp),
          //       if (value!.data!.length != 0) SplashState.appbarlocation = value?.data?[0],
          //       SplashState.allNearbyLocations = value.data!,
          //
          //       emit(Loaded())
          //     });

        }

        await locationRepository.checklocation(null, currentPosition?.latitude, currentPosition?.longitude).then((value) async => {
          if (value!.data!.length != 0)
            {
              // SplashState.appbarlocation = value?.data?[0],
              SplashState.allNearbyLocations = value.data!
            },
          if (emailExists != null && existingpwd != null)
            {emit(SkipLogin(emailExists, existingpwd))}
          else if (emailExistsIncomplete != null && existingpwdIncomplete != null)
            {emit(SkipLoginIncomplete(emailExistsIncomplete, existingpwdIncomplete))}
          else
            {emit(Loaded())}
        });
      // } catch (error) {
      //   // emit(SplashError(error.toString()));
      // }
    });
  }
}