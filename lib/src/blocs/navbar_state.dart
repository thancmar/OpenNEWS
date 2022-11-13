part of 'navbar_bloc.dart';

enum NavbarItems { Home, Menu, Map, Account }

abstract class NavbarState extends Equatable {
  // late final NavbarItems navbarItem;
  // late final int index;
  late final MagazinePublishedGetLastWithLimit? magazinePublishedGetLastWithLimit;
  // final List<Uint8List> bytes;
  late final List<Future<Uint8List>>? futureFunc;
  late final List<Future<Uint8List>>? futureFuncLanguageResultsALL;
  late final List<Future<Uint8List>>? futureFuncLanguageResultsDE;
  late final List<Future<Uint8List>>? futureFuncLanguageResultsEN;
  late final List<Future<Uint8List>>? futureFuncLanguageResultsFR;
  late final Localization? location;
  // Localization get access_location;

  NavbarState(this.magazinePublishedGetLastWithLimit, this.futureFunc, this.location);

  // @override
  // List<Object> get props => [this.navbarItem, this.index];
}

class Loading extends NavbarState {
  // final MagazinePublishedGetLastWithLimit magazinePublishedGetLastWithLimit;

  Loading() : super(null, null, null);

  @override
  List<Object> get props => [];

  // @override
  // TODO: implement access_position
  // Localization get access_location => throw UnimplementedError();
}

// class GoToHome extends NavbarState {
//   // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);
//
//   @override
//   List<Object> get props => [];
//
//   @override
//   // TODO: implement access_position
//   Localization get access_location => throw UnimplementedError();
// }

class GoToHome extends NavbarState {
  final MagazinePublishedGetLastWithLimit? magazinePublishedGetLastWithLimit;
  // final List<Uint8List> bytes;
  final List<Future<Uint8List>>? futureFunc;
  final List<Future<Uint8List>>? futureFuncLanguageResultsALL;
  final List<Future<Uint8List>>? futureFuncLanguageResultsDE;
  final List<Future<Uint8List>>? futureFuncLanguageResultsEN;
  final List<Future<Uint8List>>? futureFuncLanguageResultsFR;
  final Localization? location;

  // GoToHome([this.magazinePublishedGetLastWithLimit, this.location, this.futureFunc]);
  GoToHome(
      [this.magazinePublishedGetLastWithLimit,
      this.futureFunc,
      this.futureFuncLanguageResultsALL,
      this.futureFuncLanguageResultsDE,
      this.futureFuncLanguageResultsEN,
      this.futureFuncLanguageResultsFR,
      this.location])
      : super(magazinePublishedGetLastWithLimit, futureFunc, location);
  @override
  // TODO: implement props
  List<Object?> get props => [this.location];
  //
  // @override
  // // TODO: implement access_position
  // Localization get access_location => throw UnimplementedError();
  // @override
  // List<Object> get props => [magazinePublishedGetLastWithLimit, bytes];
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  // @override
  // List<Object> get props => [magazinePublishedGetLastWithLimit];
}

class GoToMenu extends NavbarState {
  final Localization? location;
  GoToMenu(this.location) : super(null, null, null);

  @override
  List<Object> get props => [];

  @override
  // TODO: implement access_position
  Localization get access_location => throw UnimplementedError();
}

// class GoToHomeorMenu extends NavbarState {
//   // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);
//
//   @override
//   List<Object> get props => [];
// }

class GoToMap extends NavbarState {
  GoToMap(MagazinePublishedGetLastWithLimit? magazinePublishedGetLastWithLimit, List<Future<Uint8List>>? futureFunc, Localization? location)
      : super(magazinePublishedGetLastWithLimit, futureFunc, location);

  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];

  @override
  // TODO: implement access_position
  Localization get access_location => throw UnimplementedError();
}

// class GoToSearch extends NavbarState {
//   // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);
//
//   @override
//   List<Object> get props => [];
//
//   @override
//   // TODO: implement access_position
//   Localization get access_location => throw UnimplementedError();
// }

class GoToAccount extends NavbarState {
  GoToAccount(MagazinePublishedGetLastWithLimit? magazinePublishedGetLastWithLimit, List<Future<Uint8List>>? futureFunc, Localization? location)
      : super(magazinePublishedGetLastWithLimit, futureFunc, location);

  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];

  @override
  // TODO: implement access_position
  Localization get access_location => throw UnimplementedError();
}

class GoToLocation extends NavbarState {
  GoToLocation(MagazinePublishedGetLastWithLimit? magazinePublishedGetLastWithLimit, List<Future<Uint8List>>? futureFunc, Localization? location)
      : super(magazinePublishedGetLastWithLimit, futureFunc, location);

  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];

  @override
  // TODO: implement access_position
  Localization get access_location => throw UnimplementedError();
}

class NavbarError extends NavbarState {
  final String error;

  NavbarError(this.error) : super(null, null, null);
  @override
  List<Object?> get props => [error];

  @override
  // TODO: implement access_position
  Localization get access_location => throw UnimplementedError();
}