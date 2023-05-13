part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  // final List<Future<Uint8List>>? searchResultCovers;
  // final List<Future<Uint8List>>? futureLangFunc;
  // List<dynamic>? oldSearchResults = List.empty(growable: true);
  // SearchState(this.futureLangFunc);
  SearchState();
// @override
// List<Object> get props => [this.navbarItem, this.index];
}

class LoadingSearchState extends SearchState {
  LoadingSearchState() : super();

  @override
  List<Object> get props => [];
}

class GoToSearchPage extends SearchState {
  final List<dynamic>? searchResults;
  GoToSearchPage(this.searchResults) : super();

  @override
  // TODO: implement props
  List<Object?> get props => [searchResults];
}

class GoToSearchResults extends SearchState {
  final MagazinePublishedGetAllLastByHotspotId searchResults;
  GoToSearchResults( {required this.searchResults}) : super();

  @override
  List<MagazinePublishedGetAllLastByHotspotId> get props => [searchResults];
}

class GoToLanguageResults extends SearchState {
  late MagazinePublishedGetAllLastByHotspotId? selectedLanguage;
  GoToLanguageResults({required this.selectedLanguage}) : super();

  @override
  List<Object> get props => [];
}

class GoToCategoryPage extends SearchState {
  late MagazinePublishedGetAllLastByHotspotId? selectedCategory;
  GoToCategoryPage({required this.selectedCategory}) : super();

  @override
  List<Object> get props => [];
}

class SearchError extends SearchState {
  final String error;
  SearchError(this.error) : super();

  @override
  List<Object?> get props => [error];
}