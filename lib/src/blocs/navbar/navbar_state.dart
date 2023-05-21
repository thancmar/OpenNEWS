part of 'navbar_bloc.dart';

enum NavbarItems { Home, Menu, Map, Account }

abstract class NavbarState extends Equatable {
  // late final NavbarItems navbarItem;
  // late final int index;
  static MagazinePublishedGetAllLastByHotspotId magazinePublishedGetLastWithLimit = MagazinePublishedGetAllLastByHotspotId(response: []);
  static ValueNotifier<MagazinePublishedGetAllLastByHotspotId> bookmarks =ValueNotifier<MagazinePublishedGetAllLastByHotspotId>(MagazinePublishedGetAllLastByHotspotId(response: []));

  static MagazinePublishedGetAllLastByHotspotId? magazinePublishedGetTopLastByRange = null;

  static late MagazineCategoryGetAllActive? magazineCategoryGetAllActive;
  static late Position? currentPosition = null;
  static int counterDE = 0;
  static int counterEN = 0;
  static int counterFR = 0;
  static int counterES = 0;
  static late HotspotsGetAllActive hotspotList;
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
  static late List<Future<Uint8List>> locationoffersImages = List.empty(growable: true);
  static late List<Future<File>>? locationoffersVideos = List.empty(growable: true);
  static late Future<Uint8List>? locationImage = null;
  static late Data appbarlocation = Data(); //This is the global location for the App

  static late Future<LocationOffers>? maplocationoffers = null;

  // NavbarState(this.magazinePublishedGetLastWithLimit, this.languageResultsALL, this.locations);
  NavbarState();

  @override
  List<Object> get props => [];
}

class LoadingNavbar extends NavbarState {
  // final MagazinePublishedGetLastWithLimit magazinePublishedGetLastWithLimit;
  // final List<Future<Uint8List>>? futureFuncall1;
  // Loading([this.futureFuncall]) : super(null, futureFuncall, null);
  LoadingNavbar() : super();

  @override
  List<Object> get props => [];

// @override
// TODO: implement access_position
// Localization get access_location => throw UnimplementedError();
}

class NavbarLoaded extends NavbarState {
  // final List<String> data;
  // final Data data;

  NavbarLoaded() : super();

  @override
  List<Object> get props => [];
}

class GoToLocationSelection extends NavbarState {
  final List<Data>? locations_GoToLocationSelection;

  GoToLocationSelection(this.locations_GoToLocationSelection) : super();

  @override
  List<Object> get props => [];
}

class GoToLanguageSelection extends NavbarState {
  final List<Locale> languageOptions;

  GoToLanguageSelection({required this.languageOptions}) : super();

  @override
  List<Object> get props => [];
}

class AskForLocationPermission extends NavbarState {
  // final List<Data>? locations_GoToLocationSelection;
  AskForLocationPermission() : super();

  @override
  List<Object> get props => [];
}

class NavbarError extends NavbarState {
  final String error;

  NavbarError(this.error) : super();
// @override
// List<Object?> get props => [appbarlocation];

// @override
// // TODO: implement access_position
// Localization get access_location => throw UnimplementedError();
}