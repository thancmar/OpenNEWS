import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:sharemagazines/src/models/hotspots_model.dart';
import 'dart:async';

import 'package:sharemagazines/src/resources/hotspot_repository.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final HotspotRepository hotspotRepository;
  final _dataController = StreamController<HotspotsGetAllActive>();
  // Sink<HotspotsGetAllActive> get searchQuery => _dataController.sink;
  // Stream<HotspotsGetAllActive>? get hotspotStream => _dataController.stream;

  PlayerBloc({required this.hotspotRepository}) : super(Initialized()) {
    on<Initialize>((event, emit) async {
      // emit(Initialized());
      print("now");
      // searchQuery.add(hotspotRepository.GetAllActiveHotspots());
      // _dataController.stream.listen((event) {
      //   print(event);
      // });
      print("loaded");
      emit(PlayerOpened()); // In this state we can load the HOME PAGE
    });
    on<OpenPlayer>((event, emit) async {
      // emit(Initialized());
      print("now");
      // searchQuery.add(hotspotRepository.GetAllActiveHotspots());
      // _dataController.stream.listen((event) {
      //   print(event);
      // });
      print("loaded");
      emit(PlayerOpened()); // In this state we can load the HOME PAGE
    });
  }
}