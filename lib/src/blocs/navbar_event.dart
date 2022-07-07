part of 'navbar_bloc.dart';

abstract class NavbarEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class Initialize1 extends NavbarEvent {
  Initialize1();
}

class Home extends NavbarEvent {
  Home();
}

class Menu extends NavbarEvent {
  Menu();
}

class HomeorMenu extends NavbarEvent {
  HomeorMenu();
}

class Map extends NavbarEvent {
  Map();
}

class AccountEvent extends NavbarEvent {
  AccountEvent();
}

class Location extends NavbarEvent {
  Location();
}
