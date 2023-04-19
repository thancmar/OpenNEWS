part of 'navbar_bloc.dart';

abstract class NavbarEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Initialize123 extends NavbarEvent {
  Initialize123();
  List<Object> get props => [];
}

class Home extends NavbarEvent {
  Data? location;

  Home([Data? this.location]);
  List<Object> get props => [];
}

class Menu extends NavbarEvent {
  Menu();
  List<Object> get props => [];
}

class Map extends NavbarEvent {
  Map();
  List<Object> get props => [];
}

class GetMapOffer extends NavbarEvent {
  final Place loc;
  GetMapOffer({required this.loc});
  List<Object> get props => [];
}

class AccountEvent extends NavbarEvent {
  AccountEvent();
  List<Object> get props => [];
}

// class Search extends NavbarEvent {
//   Search();
//   List<Object> get props => [];
// }

class LocationSelection extends NavbarEvent {
  final List<Data>? locations;
  LocationSelection({required this.locations});
  List<Object> get props => [];
}

class LocationSelected extends NavbarEvent {
  final Data? location;
  LocationSelected({required this.location});
  List<Object> get props => [];
}

class LocationRefresh extends NavbarEvent {
  LocationRefresh();
  List<Object> get props => [];
}