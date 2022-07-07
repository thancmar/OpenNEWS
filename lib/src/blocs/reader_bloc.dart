import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reader_event.dart';
part 'reader_state.dart';

// enum NavbarItems { Home, Menu, Map, Account }

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  // final MagazineRepository magazineRepository;
  // late ReaderState currentState;
  ReaderBloc() : super(Initialized()) {
    on<Initialize>((event, emit) async {
      emit(Initialized());
      // try {
      //   print("emission-1");
      //   // final magazinePublishedGetLastWithLimitdata = await magazineRepository
      //   //     .magazinePublishedGetLastWithLimit(id_hotspot: '0');
      //   // // print(magazinePublishedGetLastWithLimit!.response);
      //   print("blocc");
      //   // currentState = GoToHome(
      //   //     magazinePublishedGetLastWithLimit:
      //   //         magazinePublishedGetLastWithLimitdata!);
      //   final getimage =
      //       await magazineRepository.Getimage(page: '0', id_mag_pub: '190360');
      //   print(getimage);
      //   print("blocc");
      //   emit(GoToHome(magazinePublishedGetLastWithLimitdata, getimage));
      // } catch (e) {
      //   print("noemission");
      //   emit(NavbarError(e.toString()));
      // }
    });

    on<OpenReader>((event, emit) async {
      emit(ReaderOpened());
      // print("bloccc");
      // try {
      //   final magazinePublishedGetLastWithLimit = await magazineRepository
      //       .magazinePublishedGetLastWithLimit(id_hotspot: '0');
      //   emit(GoToHome(magazinePublishedGetLastWithLimit!));
      // } catch (e) {
      //   emit(NavbarError(e.toString()));
      // }
      // });
      // on<Menu>((event, emit) async {
      //   emit(GoToMenu());
      // });
      // on<Map>((event, emit) async {
      //   emit(GoToMap());
      // });
      // on<AccountEvent>((event, emit) async {
      //   emit(GoToAccount());
      // });
      // on<Location>((event, emit) async {
      //   emit(GoToLocation());
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
