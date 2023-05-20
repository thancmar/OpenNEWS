part of 'reader_bloc.dart';

// enum NavbarItems { Home, Menu, Map, Account }

abstract class ReaderState extends Equatable {
  // late final NavbarItems navbarItem;
  // late final int index;
  static late Uint8List doc;
  static late List<Future<Uint8List>>? pagesAll = List.empty(growable: true);
  // final List<Future<Uint8List>>? futureFuncAllPages;
  ReaderState();
//
// @override
  List<Object> get props => [];
}

class Initialized extends ReaderState {
  Initialized() : super();

  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class ReaderOpened extends ReaderState {
  // final Uint8List doc;
  // final List<Uint8List> bytes;
  // final List<Future<Uint8List>>? futureFuncAllPages;

  ReaderOpened() : super();
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class ReaderOpenedPDF extends ReaderState {
  // final List<Uint8List> bytes;

  final pdfDocument;
  ReaderOpenedPDF(this.pdfDocument) : super();
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class ReaderClosed extends ReaderState {
  // final List<Uint8List> bytes;
  final List<Future<Uint8List>>? futureFuncAllPages;
  ReaderClosed(this.futureFuncAllPages) : super();
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class ReaderError extends ReaderState {
  final String error;
  // final List<Uint8List> bytes;
  // final List<Future<Uint8List>>? futureFuncAllPages;
  ReaderError(this.error) : super();
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
