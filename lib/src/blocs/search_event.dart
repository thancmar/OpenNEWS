part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class Initialize extends SearchEvent {
  // final NavbarBloc navbarBloc;
  final BuildContext context;
  Initialize(this.context);
}

class OpenSearch extends SearchEvent {
  // final String idMagazinePublication;
  // final String pageNo;

  OpenSearch();
}

class OpenSearchResults extends SearchEvent {
  // final String idMagazinePublication;
  // final String pageNo;
  final BuildContext context;
  final String searchText;
  OpenSearchResults(this.context, this.searchText);
}

class OpenLanguageResults extends SearchEvent {
  // final String idMagazinePublication;
  // final String pageNo;
  final BuildContext context;
  final String languageText;
  OpenLanguageResults(this.context, this.languageText);
}
//
// class Menu extends ReaderEvent {
//   Menu();
// }
//
// class Map extends ReaderEvent {
//   Map();
// }
//
// class AccountEvent extends ReaderEvent {
//   AccountEvent();
// }
//
// class Location extends ReaderEvent {
//   Location();
// }