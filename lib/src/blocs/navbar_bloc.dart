import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sharemagazines_flutter/src/models/magazine_publication_model.dart';
import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';

part 'navbar_event.dart';
part 'navbar_state.dart';

// enum NavbarItems { Home, Menu, Map, Account }

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  final MagazineRepository magazineRepository;
  late NavbarState currentState;
  late Uint8List image123;
  late List<Uint8List> imagebytes = [];
  NavbarBloc({required this.magazineRepository}) : super(Loading()) {
    on<Home>((event, emit) async {
      emit(Loading());
      try {
        print("emission-11");
        final magazinePublishedGetLastWithLimitdata = await magazineRepository
            .magazinePublishedGetLastWithLimit(id_hotspot: '0');
        // print(magazinePublishedGetLastWithLimit!.response);
        print("dartsas");
        for (var i = 1;
            i < 6; //magazinePublishedGetLastWithLimitdata.response!.length;
            i++) {
          // print(magazinePublishedGetLastWithLimitdata
          //     .response![i].idMagazinePublication!);

          image123 = await magazineRepository.Getimage(
              page: '0',
              id_mag_pub: magazinePublishedGetLastWithLimitdata
                  .response![i].idMagazinePublication!);
          imagebytes.add(image123);
          // imagebytes.add(await magazineRepository.Getimage(
          //     page: '0',
          //     id_mag_pub: magazinePublishedGetLastWithLimitdata
          //         .response![i].idMagazinePublication!));
        }
        // print(magazinePublishedGetLastWithLimitdata
        //     .response![0].idMagazinePublication!);
        // currentState = GoToHome(
        //     magazinePublishedGetLastWithLimit:
        //         magazinePublishedGetLastWithLimitdata!);

        final getimage =
            await magazineRepository.Getimage(page: '0', id_mag_pub: '190360');
        print(imagebytes[3]);
        print("blocc");
        emit(GoToHome(magazinePublishedGetLastWithLimitdata, imagebytes));
      } catch (e) {
        print("noemission");
        emit(NavbarError(e.toString()));
      }
    });

    // on<Home>((event, emit) async {
    //   // emit(currentState);
    //   // print("bloccc");
    //   // try {
    //   //   final magazinePublishedGetLastWithLimit = await magazineRepository
    //   //       .magazinePublishedGetLastWithLimit(id_hotspot: '0');
    //   //   emit(GoToHome(magazinePublishedGetLastWithLimit!));
    //   // } catch (e) {
    //   //   emit(NavbarError(e.toString()));
    //   // }
    // });
    on<Menu>((event, emit) async {
      emit(GoToMenu());
    });
    on<HomeorMenu>((event, emit) async {
      emit(GoToHomeorMenu());
    });
    on<Map>((event, emit) async {
      emit(GoToMap());
    });
    on<AccountEvent>((event, emit) async {
      emit(GoToAccount());
    });
    on<Location>((event, emit) async {
      emit(GoToLocation());
    });
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
