part of 'navbar_bloc.dart';

enum NavbarItems { Home, Menu, Map, Account }

abstract class NavbarState extends Equatable {
  late final NavbarItems navbarItem;
  late final int index;
  //
  // NavbarState(this.navbarItem, this.index);
  //
  // @override
  // List<Object> get props => [this.navbarItem, this.index];
}

class Loading extends NavbarState {
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class GoToHome extends NavbarState {
  final MagazinePublishedGetLastWithLimit magazinePublishedGetLastWithLimit;
  final List<Uint8List> bytes;

  GoToHome(this.magazinePublishedGetLastWithLimit, this.bytes);
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [magazinePublishedGetLastWithLimit];
}

class GoToMenu extends NavbarState {
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class GoToHomeorMenu extends NavbarState {
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class GoToMap extends NavbarState {
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class GoToAccount extends NavbarState {
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class GoToLocation extends NavbarState {
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class NavbarError extends NavbarState {
  final String error;

  NavbarError(this.error);
  @override
  List<Object?> get props => [error];
}
