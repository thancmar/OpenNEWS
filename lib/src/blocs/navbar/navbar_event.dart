part of 'navbar_bloc.dart';

abstract class NavbarEvent extends Equatable {
  Timer? timer;
  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class Initialize123 extends NavbarEvent {
  Initialize123();
  List<Object> get props => [];
}

class Home extends NavbarEvent {
  Data? location;
  Timer? timer;

  Home([Data? this.location, Timer? this.timer]);
  List<Object> get props => [];
}

class Menu extends NavbarEvent {
  Menu();
  List<Object> get props => [];
}

// class HomeorMenu extends NavbarEvent {
//   HomeorMenu();
//   List<Object> get props => [];
// }

class Map extends NavbarEvent {
  Map();
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
  Data? location;
  LocationSelection([this.location]);
  List<Object> get props => [];
}

class LocationRefresh extends NavbarEvent {
  LocationRefresh();
  List<Object> get props => [];
}