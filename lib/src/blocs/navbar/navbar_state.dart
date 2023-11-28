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

  static late List<Future<Uint8List>>? languageResultsALL = List.empty(growable: true);


  static late Future<LocationGetHeader>? locationheader = null;
  static  Future<LocationOffers>? locationoffers = null;
  static  Future<List<OfferImage>>? locationoffers123 = null;
  static  List<OfferImage> locationoffersImages =[] ;
  static late List<Future<File>>? locationoffersVideos = List.empty(growable: true);
  static late Future<Uint8List>? locationImage = null;
   final Data appbarlocation ; //This is the global location for the App

  static late String? token = null;
  static late String? fingerprint = null;

  static late Future<LocationOffers>? maplocationoffers = null;

  // NavbarState(this.magazinePublishedGetLastWithLimit, this.languageResultsALL, this.locations);
  NavbarState(this.appbarlocation);

  @override
  List<Object> get props => [appbarlocation];
}

class LoadingNavbar extends NavbarState {
  // final MagazinePublishedGetLastWithLimit magazinePublishedGetLastWithLimit;
  // final List<Future<Uint8List>>? futureFuncall1;
  // Loading([this.futureFuncall]) : super(null, futureFuncall, null);
  LoadingNavbar(Data appbarlocation) : super(appbarlocation);

  @override
  List<Object> get props => [];

// @override
// TODO: implement access_position
// Localization get access_location => throw UnimplementedError();
}

class NavbarLoaded extends NavbarState {
  // final List<String> data;
  // final Data data;

  NavbarLoaded(Data appbarlocation) : super(appbarlocation);

  // @override
  // List<Object> get props => [appbarlocation];
}

class GoToLocationSelection extends NavbarState {
  final List<Data>? locations_GoToLocationSelection;

  GoToLocationSelection(this.locations_GoToLocationSelection,Data appbarlocation) : super(appbarlocation);

  @override
  List<Object> get props => [];
}

class GoToLanguageSelection extends NavbarState {
  final List<Locale> languageOptions;

  GoToLanguageSelection({required this.languageOptions}) : super(Data());

  @override
  List<Object> get props => [];
}

class AskForLocationPermission extends NavbarState {
  // final List<Data>? locations_GoToLocationSelection;
  AskForLocationPermission(Data appbarlocation) : super(appbarlocation);

  @override
  List<Object> get props => [];
}

class NavbarError extends NavbarState {
  final String error;

  NavbarError(this.error) : super(Data());
// @override
// List<Object?> get props => [appbarlocation];

// @override
// // TODO: implement access_position
// Localization get access_location => throw UnimplementedError();
}