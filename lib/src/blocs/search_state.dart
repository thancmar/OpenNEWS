part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  // late final SearchItems navbarItem;
  // late final int index;
// Localization get access_location;
  final List<Future<Uint8List>>? futureFunc;
  final List<Future<Uint8List>>? futureLangFunc;

  SearchState(this.futureFunc, [this.futureLangFunc]);

// @override
// List<Object> get props => [this.navbarItem, this.index];
}

class Loading extends SearchState {
  Loading() : super(null);

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

class GoToSearchPage extends SearchState {
  // final MagazinePublishedGetLastWithLimit? magazinePublishedGetLastWithLimit;
  // // final List<Uint8List> bytes;
  // final List<Future<Uint8List>>? futureFunc;
  // final Localization? location;
  final List<dynamic>? searchResults;

  // GoToHome([this.magazinePublishedGetLastWithLimit, this.location, this.futureFunc]);
  GoToSearchPage(this.searchResults) : super(null);
  @override
  // TODO: implement props
  List<Object?> get props => [];
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

class GoToSearchResults extends SearchState {
  // final Localization? location;
  final MagazinePublishedGetLastWithLimit? magazinePublishedGetLastWithLimit;
  // final List<Uint8List> bytes;
  final List<Future<Uint8List>>? futureFunc;
  final Localization? location;
  GoToSearchResults(this.magazinePublishedGetLastWithLimit, this.futureFunc, this.location) : super(futureFunc);

  @override
  List<Object> get props => [];

  // @override
  // TODO: implement access_position
  // Localization get access_location => throw UnimplementedError();
}

class GoToLanguageResults extends SearchState {
  // final Localization? location;
  final MagazinePublishedGetLastWithLimit? magazinePublishedGetLastWithLimit;
  // final List<Uint8List> bytes;
  final List<Future<Uint8List>>? futureLangFunc;
  final Localization? location;
  GoToLanguageResults(this.magazinePublishedGetLastWithLimit, this.futureLangFunc, this.location) : super(futureLangFunc);

  @override
  List<Object> get props => [];

  // @override
  // TODO: implement access_position
  // Localization get access_location => throw UnimplementedError();
}

// class GoToHomeorMenu extends NavbarState {
//   // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);
//
//   @override
//   List<Object> get props => [];
// }