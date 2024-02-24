part of 'ebook_bloc.dart';

// enum NavbarItems { Home, Menu, Map, Account }

abstract class EbookState extends Equatable {
  // late final NavbarItems navbarItem;
  // late final int index;
  static late Uint8List doc;
  static late List<Future<Uint8List>>? pagesAll = List.empty(growable: true);
  // final List<Future<Uint8List>>? futureFuncAllPages;
  EbookState();
//
// @override
  List<Object> get props => [];
}

// class Initialized extends EbookState {
//   Initialized() : super();
//
//   // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);
//
//   @override
//   List<Object> get props => [];
// }

class EbookOpened extends EbookState {
  // final Uint8List doc;
  // final List<Uint8List> bytes;
  // final List<Future<Uint8List>>? futureFuncAllPages;

  EbookOpened() : super();
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class ReaderOpenedPDF extends EbookState {
  // final List<Uint8List> bytes;

  final pdfDocument;
  ReaderOpenedPDF(this.pdfDocument) : super();
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class ReaderClosed extends EbookState {
  // final List<Uint8List> bytes;
  final List<Future<Uint8List>>? futureFuncAllPages;
  ReaderClosed(this.futureFuncAllPages) : super();
  // Loading(NavbarItems navbarItem, int index) : super(navbarItem, index);

  @override
  List<Object> get props => [];
}

class ReaderError extends EbookState {
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