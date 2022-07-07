import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:sharemagazines_flutter/src/models/hotspots_model.dart';
import 'dart:async';

import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final HotspotRepository hotspotRepository;
  final _dataController = StreamController<HotspotsGetAllActive>();
  Sink<HotspotsGetAllActive> get searchQuery => _dataController.sink;
  Stream<HotspotsGetAllActive>? get hotspotStream => _dataController.stream;

  MapBloc({required this.hotspotRepository}) : super(Loading()) {
    on<Initialize>((event, emit) async {
      emit(Loading());
      print("now");
      // searchQuery.add(hotspotRepository.GetAllActiveHotspots());
      // _dataController.stream.listen((event) {
      //   print(event);
      // });
      print("loaded");
      emit(Loaded()); // In this state we can load the HOME PAGE
    });
  }
}
