part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  // final List<Future<Uint8List>>? searchResultCovers;
  final List<Future<Uint8List>>? futureLangFunc;
  // List<dynamic>? oldSearchResults = List.empty(growable: true);
  SearchState(this.futureLangFunc);
// @override
// List<Object> get props => [this.navbarItem, this.index];
}

class LoadingSearchState extends SearchState {
  LoadingSearchState() : super(null);

  @override
  List<Object> get props => [];
}

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
}

class GoToSearchResults extends SearchState {
  // final Localization? location;
  // final MagazinePublishedGetAllLastByHotspotId? magazinePublishedGetLastWithLimit;
  // final List<Uint8List> bytes;
  // final List<Future<Uint8List>>? searchResultCovers;
  final MagazinePublishedGetAllLastByHotspotId? searchResultCovers;
  // final Localization? location;
  GoToSearchResults(this.searchResultCovers) : super(null);

  @override
  List<Object> get props => [];
}

class GoToLanguageResults extends SearchState {
  // final Localization? location;
  // final MagazinePublishedGetAllLastByHotspotId? magazinePublishedGetLastWithLimit;
  // final List<Uint8List> bytes;
  // final List<Future<Uint8List>>? futureLangFunc;
  late MagazinePublishedGetAllLastByHotspotId? selectedLanguage;

  // final Localization? location;
  GoToLanguageResults({required this.selectedLanguage}) : super(null);

  @override
  List<Object> get props => [];
}

class GoToCategoryPage extends SearchState {
  // final Localization? location;
  // final MagazinePublishedGetAllLastByHotspotId? magazinePublishedGetLastWithLimit;
  // final List<Uint8List> bytes;
  // final List<Future<Uint8List>>? futureLangFunc;
  // late List<Response>? itemCount;
  late MagazinePublishedGetAllLastByHotspotId? selectedCategory;

  // final Localization? location;
  GoToCategoryPage({required this.selectedCategory}) : super(null);

  @override
  List<Object> get props => [];
}