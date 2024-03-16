part of 'navbar_bloc.dart';

enum CategoryStatus {
  presse,
  ebooks,
  hoerbuecher,
}

abstract class NavbarState extends Equatable {
  // late final NavbarItems navbarItem;
  // late final int index;
  static ValueNotifier<CategoryStatus>  categoryStatus =ValueNotifier(CategoryStatus.presse);
  // static CategoryStatus categoryStatus = CategoryStatus.presse;
  static MagazinePublishedGetAllLastByHotspotId magazinePublishedGetLastWithLimit = MagazinePublishedGetAllLastByHotspotId(response: []);

  static EbooksForLocationGetAllActive ebooks = EbooksForLocationGetAllActive(response: []);
  static EbookCategoryGetAllActiveByLocale ebookCategoryGetAllActiveByLocale = EbookCategoryGetAllActiveByLocale(response: []);

  static AudioBooksForLocationGetAllActive audiobooks = AudioBooksForLocationGetAllActive(response: []);
  static AudiobookCategoryGetAllActiveByLocale audioBooksCategoryGetAllActiveByLocale = AudiobookCategoryGetAllActiveByLocale(response: []);

  static ValueNotifier<MagazinePublishedGetAllLastByHotspotId> bookmarks =ValueNotifier<MagazinePublishedGetAllLastByHotspotId>(MagazinePublishedGetAllLastByHotspotId(response: []));

  static MagazinePublishedGetAllLastByHotspotId? magazinePublishedGetTopLastByRange = null;

  static late MagazineCategoryGetAllActive? magazineCategoryGetAllActive;
  // static EbooksForLocationGetAllActive ebooks = EbooksForLocationGetAllActive(response: []);
  static late Position? currentPosition = null;
  static late HotspotsGetAllActive hotspotList;
  static late List<Place> allMapMarkers = <Place>[];
  static late List<Future<Uint8List>>? languageResultsALL = List.empty(growable: true);
 // static

  static late Future<LocationGetHeader>? locationheader = null;
  static  Future<LocationOffers>? locationoffers = null;
  static  Future<List<OfferImage>>? locationoffers123 = null;
  static  List<OfferImage> locationoffersImages =[] ;
  static late List<Future<File>>? locationoffersVideos = List.empty(growable: true);
  static late Future<Uint8List>? locationImage = null;
   final LocationData appbarlocation ; //This is the global location for the App

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
  LoadingNavbar(LocationData appbarlocation) : super(appbarlocation);

  @override
  List<Object> get props => [];

// @override
// TODO: implement access_position
// Localization get access_location => throw UnimplementedError();
}

class NavbarLoaded extends NavbarState {
  // final List<String> data;
  // final Data data;


  NavbarLoaded(LocationData appbarlocation) : super(appbarlocation);

  // @override
  // List<Object> get props => [appbarlocation];
}

class GoToLocationSelection extends NavbarState {
  final List<LocationData>? locations_GoToLocationSelection;

  GoToLocationSelection(this.locations_GoToLocationSelection,LocationData appbarlocation) : super(appbarlocation);

  @override
  List<Object> get props => [];
}

class GoToLanguageSelection extends NavbarState {
  final LocationData appbarlocation;
  final List<Locale> languageOptions;

  GoToLanguageSelection({required this.appbarlocation,required this.languageOptions}) : super(appbarlocation);

  @override
  List<Object> get props => [];
}

class ScrollSelection extends NavbarState {
  final LocationData appbarlocation;
  // final List<Locale> languageOptions;

  ScrollSelection({required this.appbarlocation}) : super(appbarlocation);

  @override
  List<Object> get props => [];
}


class AskForLocationPermission extends NavbarState {
  // final List<Data>? locations_GoToLocationSelection;
  AskForLocationPermission(LocationData appbarlocation) : super(appbarlocation);

  @override
  List<Object> get props => [];
}

class NavbarError extends NavbarState {
  final String error;

  NavbarError(this.error) : super(LocationData());
// @override
// List<Object?> get props => [appbarlocation];

// @override
// // TODO: implement access_position
// Localization get access_location => throw UnimplementedError();
}