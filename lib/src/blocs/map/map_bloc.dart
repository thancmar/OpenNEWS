import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sharemagazines_flutter/src/models/hotspots_model.dart';
import 'dart:async';

import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final HotspotRepository hotspotRepository;
  final _dataController = StreamController<HotspotsGetAllActive>();
  // Sink<HotspotsGetAllActive> get searchQuery => _dataController.sink;
  // Stream<HotspotsGetAllActive>? get hotspotStream => _dataController.stream;

  MapBloc({required this.hotspotRepository}) : super(LoadingMap()) {
    on<Initialize>((event, emit) async {
      emit(LoadingMap());
      print("now");
      // final availableMaps = await MapLauncher.installedMaps;
      // print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
      //
      // await availableMaps.first.showMarker(
      //   coords: Coords(37.759392, -122.5107336),
      //   title: "Ocean Beach",
      // );
      // searchQuery.add(hotspotRepository.GetAllActiveHotspots());
      // _dataController.stream.listen((event) {
      //   print(event);
      // });
      print("loaded");
      emit(Loaded()); // In this state we can load the HOME PAGE
    });
  }
}