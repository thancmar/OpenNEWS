part of 'navbar_bloc.dart';

enum NavbarItems { Home, Menu, Map, Account }

abstract class NavbarState extends Equatable {
  // late final NavbarItems navbarItem;
  // late final int index;
  static late MagazinePublishedGetAllLastByHotspotId? magazinePublishedGetLastWithLimit;
  static late MagazinePublishedGetAllLastByHotspotId? magazinePublishedGetTopLastByRange;
  static late MagazineCategoryGetAllActive? magazineCategoryGetAllActive;
  static late Position? currentPosition = null;
  static int counterDE = 0;
  static int counterEN = 0;
  static int counterFR = 0;
  static int counterES = 0;
  static late Future<HotspotsGetAllActive> hotspotList;
  static late List<Place> allMapMarkers = <Place>[];
  // final List<Uint8List> bytes;
  // List<Future<Uint8List>>? AllCovers = List.empty(growable: true);
  // late final List<Future<Uint8List>>? futureFunc;
  static late List<Future<Uint8List>>? languageResultsALL = List.empty(growable: true);
  static late List<Stream<Uint8List>>? languageResultsALLStream = List.empty(growable: true);
  static late List<Future<Uint8List>>? languageResultsDE = List.empty(growable: true);
  static late List<Future<Uint8List>>? languageResultsEN = List.empty(growable: true);
  static late List<Future<Uint8List>>? languageResultsFR = List.empty(growable: true);
  static late List<Future<Uint8List>>? getTopMagazines = List.empty(growable: true);
  // late final Localization? locations_NavbarState;

  // Localization get access_location;
  static late Future<LocationGetHeader>? locationheader = null;
  static late Future<LocationOffers>? locationoffers = null;
  static late List<Future<Uint8List>>? locationoffersImages = List.empty(growable: true);
  static late Future<Uint8List>? locationImage = null;

  static late Future<LocationOffers>? maplocationoffers = null;
  // NavbarState(this.magazinePublishedGetLastWithLimit, this.languageResultsALL, this.locations);
  NavbarState();

  // @override
  // List<Object> get props => [this.locations];
}

class Loading extends NavbarState {
  // final MagazinePublishedGetLastWithLimit magazinePublishedGetLastWithLimit;
  // final List<Future<Uint8List>>? futureFuncall1;
  // Loading([this.futureFuncall]) : super(null, futureFuncall, null);
  Loading() : super();
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
  final MagazinePublishedGetAllLastByHotspotId? magazinePublishedGetLastWithLimit_HomeState;
  // final List<Uint8List> bytes;
  // final List<Future<Uint8List>>? futureFunc;
  final List<Future<Uint8List>>? languageResultsALL_HomeState;
  final List<Future<Uint8List>>? languageResultsDE_HomeState;
  final List<Future<Uint8List>>? languageResultsEN_HomeState;
  final List<Future<Uint8List>>? languageResultsFR_HomeState;
  final Localization? locations_HomeState;
  final Data? location_HomeState;
  // GoToHome([this.magazinePublishedGetLastWithLimit, this.location, this.futureFunc]);
  GoToHome(
      [this.magazinePublishedGetLastWithLimit_HomeState,
      // this.futureFunc,
      this.languageResultsALL_HomeState,
      this.languageResultsDE_HomeState,
      this.languageResultsEN_HomeState,
      this.languageResultsFR_HomeState,
      this.locations_HomeState,
      this.location_HomeState])
      : super();

  @override
  // TODO: implement props
  List<Object?> get props => [this.location_HomeState];

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
  final Localization? locations_NavbarState;
  final Data? location;
  GoToMenu(this.locations_NavbarState, this.location) : super();

  @override
  List<Object> get props => [];

  // @override
  // // TODO: implement access_position
  // Localization get access_location => throw UnimplementedError();
}

// class GoToHomeorMenu extends NavbarState {
//   // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);
//
//   @override
//   List<Object> get props => [];
// }

class GoToMap extends NavbarState {
  GoToMap() : super();

  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];

  // @override
  // // TODO: implement access_position
  // Localization get access_location => throw UnimplementedError();
}

class GoToMapOffer extends NavbarState {
  final Place loc;
  final Future<LocationOffers>? offers;
  GoToMapOffer({required this.loc, required this.offers}) : super();

  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];

// @override
// // TODO: implement access_position
// Localization get access_location => throw UnimplementedError();
}

class GoToAccount extends NavbarState {
  GoToAccount(MagazinePublishedGetAllLastByHotspotId? magazinePublishedGetLastWithLimit, List<Future<Uint8List>>? futureFunc, Localization? locations) : super();

  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];

  // @override
  // // TODO: implement access_position
  // Localization get access_location => throw UnimplementedError();
}

class GoToLocationSelection extends NavbarState {
  final Localization? locations_GoToLocationSelection;
  GoToLocationSelection(this.locations_GoToLocationSelection) : super();

  @override
  List<Object> get props => [];
}

class NavbarError extends NavbarState {
  final String error;

  NavbarError(this.error) : super();
  @override
  List<Object?> get props => [error];

  // @override
  // // TODO: implement access_position
  // Localization get access_location => throw UnimplementedError();
}