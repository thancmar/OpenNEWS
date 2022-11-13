part of 'navbar_bloc.dart';

abstract class NavbarEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class Initialize123 extends NavbarEvent {
  Timer? timer;
  late double progress;
  Initialize123(Timer? timer, double? progress);
  List<Object> get props => [];
}

class Home extends NavbarEvent {
  Home();
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

class Location extends NavbarEvent {
  Location();
  List<Object> get props => [];
}