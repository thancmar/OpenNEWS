part of 'reader_bloc.dart';

abstract class ReaderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class Initialize extends ReaderEvent {
  Initialize();
}

class OpenReader extends ReaderEvent {
  final String idMagazinePublication;
  final String pageNo;
  OpenReader({required this.idMagazinePublication, required this.pageNo});
}

class CloseReader extends ReaderEvent {
  CloseReader();
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