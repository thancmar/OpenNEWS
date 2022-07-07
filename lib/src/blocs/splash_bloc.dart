import 'dart:async';

import 'package:bloc/bloc.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/resources/auth_repository.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(Initial()) {
    on<NavigateToHomeEvent>((event, emit) async {
      emit(Loading());
      // late GoogleMapController mapController;
      await Future.delayed(Duration(
          seconds: 2)); // This is to simulate that above checking process
      emit(Loaded()); // In this state we can load the HOME PAGE
    });
  }
}
