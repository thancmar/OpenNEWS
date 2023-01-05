import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/resources/auth_repository.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';

import '../../models/hotspots_model.dart';
import '../../resources/dioClient.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GetIt getIt = GetIt.instance;

  SplashBloc() : super(Initial()) {
    // on<NavigateToHomeEvent>((event, emit) async {
    //   emit(Loading());
    // });

    on<NavigateToHomeEvent>((event, emit) async {
      //emit(LoadingSplash());
      getIt.registerSingleton<ApiClient>(ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage()), signalsReady: true);

      // late GoogleMapController mapController;
      // await Future.delayed(Duration(seconds: 2)); // This is to simulate that above checking process
      bool serviceEnabled;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        // return Future.error('Location services are disabled.');
        emit(Loaded());
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
          emit(Loaded());
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print("splash permission");
        await Geolocator.requestPermission();
        permission = await Geolocator.requestPermission();
        // Permissions are denied forever, handle appropriately.
        // return Future.error('Location permissions are permanently denied, we cannot request permissions.');
        emit(Loaded());
      }
      print("splash permission");
      print(permission);
      emit(Loaded());
      // emit(Loaded(await Geolocator.getCurrentPosition())); // In this state we can load the HOME PAGE
    });
  }
}