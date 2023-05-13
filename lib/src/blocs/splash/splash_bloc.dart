import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    on<NavigateToHomeEvent>((event, emit) async {
      try{
      getIt.registerSingleton<ApiClient>(ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage()), signalsReady: true);
      String? emailExists = await dioClient.secureStorage.read(key: "email");
      String? existingpwd = await dioClient.secureStorage.read(key: "pwd");
      // await dioClient.secureStorage.deleteAll();
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        // return Future.error('Location services are disabled.');
        // emit(Loaded());

        permission = await Geolocator.requestPermission();
        emit(SplashError("Location services are not enabled"));
        // if (!await Geolocator.isLocationServiceEnabled()) {
        //   // If the user still didn't enable the location service, handle this case.
        //   // You can show a dialog or a snackbar to inform the user that the app requires location services.
        // };
      }else{
         permission = await Geolocator.checkPermission();

      }

      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          // return Future.error('Location permissions are denied');
          // emit(Loaded());
        // emit(SplashError("Location services are not enabled"));
        permission = await Geolocator.requestPermission();
          await locationRepository.checklocation(null,null, null).then((value) async => {
            // if (value!.data!.length > 1)
            //   {
            //     // SplashState.appbarlocation = value.data![1],
            //     add(LocationSelection(locations: value.data!)),
            //     // await locationRepository.checklocation(value!.data![0].idLocation!, currentPosition?.latitude, currentPosition?.longitude).then((value) async => {})
            //   }
            // else if (value!.data!.length == 1)
            //   {
                print("debug"),
                // print(value.data![0].nameApp),
                // SplashState.appbarlocation = value.data![0],
                if(emailExists!=null &&existingpwd!=null){
                  emit(SkipLogin(emailExists, existingpwd))
                }else{
                  emit(Loaded())
                }

                // await locationRepository.checklocation(value!.data![0] .toString(), NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude).then((value) async => {
          //     }
          //   else {
          // SplashState.appbarlocation = Data(),
          // if(emailExists!=null && existingpwd!=null){
          // emit(SkipLogin(emailExists, existingpwd, Data()))
          // } else{
          // emit(Loaded(currentLocation: Data()))
          // }
          //
          //   }
          });
        }else{


        Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
        await locationRepository.checklocation(null, currentPosition.latitude, currentPosition.longitude).then((value) async => {
          // if (value!.data!.length > 1)
          //   {
          //     // SplashState.appbarlocation = value.data![1],
          //     add(LocationSelection(locations: value.data!)),
          //     // await locationRepository.checklocation(value!.data![0].idLocation!, currentPosition?.latitude, currentPosition?.longitude).then((value) async => {})
          //   }
          // else if (value!.data!.length == 1)
          //   {
              print("debug"),
              // print(value.data![0].nameApp),
          if (value!.data!.length != 0)
            SplashState.appbarlocation=value?.data?[0],
            SplashState.allNearbyLocations=value.data!,
          // if(value!.data!.length == 1)
          //   SplashState.appbarlocation=value!.data![0],




          //     SplashState.appbarlocation = value.data[0],
              // emit(Loaded(currentLocation: value.data![0]))
              // if(emailExists!=null && existingpwd!=null){
              //   emit(SkipLogin(emailExists, existingpwd))
              // } else{
                emit(Loaded())
              // }
              // await locationRepository.checklocation(value!.data![0] .toString(), NavbarState.currentPosition?.latitude, NavbarState.currentPosition?.longitude).then((value) async => {
        //     }
        //   else
        // {
        // SplashState.appbarlocation = Data(),
        // // emit(Loaded(currentLocation: Data())
        // if(emailExists!=null && existingpwd!=null){
        // emit(SkipLogin(emailExists, existingpwd, Data()))
        // } else{
        // emit(Loaded(currentLocation: Data()))
        // }
        // },

        }
        );
      }
    } catch (error) {
      emit(SplashError(error.toString()));
    }
      }

      );
    // on<LocationSelection>((event, emit) async {
    //   try {
    //     await EasyLoading.dismiss();
    //     emit(GoToLocationSelection(event.locations));
    //   } on Exception catch (e) {
    //     emit(SplashError(e.toString()));
    //     print(e);
    //   }
    // });

  }
}