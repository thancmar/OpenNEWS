part of 'navbar_bloc.dart';

abstract class NavbarEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitializeNavbar extends NavbarEvent {
  final Data? currentPosition;
  InitializeNavbar(
      {required this.currentPosition}
      );
  List<Object> get props => [];
}

// class Home extends NavbarEvent {
//   Data? location;
//
//   Home([Data? this.location]);
//   List<Object> get props => [];
// }
//
// class Menu extends NavbarEvent {
//   Menu();
//   List<Object> get props => [];
// }
//
// class Map extends NavbarEvent {
//   Map();
//   List<Object> get props => [];
// }
//
// class AccountEvent extends NavbarEvent {
//   AccountEvent();
//   List<Object> get props => [];
// }

class GetMapOffer extends NavbarEvent {
  final Place loc;
  GetMapOffer({required this.loc});
  List<Object> get props => [];
}

class BackFromLocationPermission extends NavbarEvent {
  BackFromLocationPermission();
  List<Object> get props => [];
}

class OpenSystemSettings extends NavbarEvent {
  OpenSystemSettings();
  List<Object> get props => [];
}

class OpenLanguageSelection extends NavbarEvent {
  final List<Locale> languageOptions;
  OpenLanguageSelection({required this.languageOptions});
  List<Object> get props => [];
}

// class Search extends NavbarEvent {
//   Search();
//   List<Object> get props => [];
// }

// To add and remove
class Bookmark extends NavbarEvent {

  Bookmark();
  List<Object> get props => [];
}

// class GetCover extends NavbarEvent {
//   final String idMagazinePublication;
//   final String dateOfPublication;
//
//
//   GetCover({required this.idMagazinePublication, required this.dateOfPublication});
//   List<Object> get props => [];
// }

class LocationSelected extends NavbarEvent {
  final Data? selectedLocation;
  final Data? currentLocation;
  LocationSelected({required this.selectedLocation, required this.currentLocation});
  List<Object> get props => [];
}

class LanguageSelected extends NavbarEvent {
  final Locale? language;
  final Data? currentLocation;
  LanguageSelected({required this.language, required this.currentLocation});
  List<Object> get props => [];
}

class LocationRefresh extends NavbarEvent {
  LocationRefresh();
  List<Object> get props => [];
}