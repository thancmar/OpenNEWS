part of 'reader_bloc.dart';

// enum NavbarItems { Home, Menu, Map, Account }

abstract class ReaderState extends Equatable {
  // late final NavbarItems navbarItem;
  // late final int index;

  final List<Future<Uint8List>>? futureFuncAllPages;
  ReaderState(this.futureFuncAllPages);
//
// @override
  List<Object> get props => [];
}

class Initialized extends ReaderState {
  Initialized() : super(null);

  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class ReaderOpened extends ReaderState {
  // final List<Uint8List> bytes;
  final List<Future<Uint8List>>? futureFuncAllPages;
  ReaderOpened(this.futureFuncAllPages) : super(futureFuncAllPages);
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}
//
// class GoToMenu extends ReaderState {
//   // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);
//
//   @override
//   List<Object> get props => [];
// }
//
// class GoToMap extends ReaderState {
//   // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);
//
//   @override
//   List<Object> get props => [];
// }
//
// class GoToAccount extends ReaderState {
//   // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);
//
//   @override
//   List<Object> get props => [];
// }
//
// class GoToLocation extends ReaderState {
//   // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);
//
//   @override
//   List<Object> get props => [];
// }
//
// class NavbarError extends ReaderState {
//   final String error;
//
//   NavbarError(this.error);
//   @override
//   List<Object?> get props => [error];
// }