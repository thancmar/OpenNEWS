part of 'ebook_bloc.dart';

abstract class EbookEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
// class Initialize extends EbookEvent {
//   Initialize();
// }

// class OpenReader extends EbookEvent {
//   // final String idMagazinePublication;
//   // final String dateofPublicazion;
//   // final String pageNo;
//   final model.ResponseMagazine magazine;
//   OpenReader({required this.magazine});
// }

class DownloadPage extends EbookEvent {
  // final String idMagazinePublication;
  // final String dateofPublicazion;
  // final String pageNo;
  final model.ResponseMagazine magazine;
  final int pageNo;
  DownloadPage({required this.magazine, required this.pageNo});
}

class DownloadThumbnail extends EbookEvent {
  // final String idMagazinePublication;
  // final String dateofPublicazion;
  // final String pageNo;
  final model.ResponseMagazine magazine;
  final int pageNo;
  DownloadThumbnail({required this.magazine, required this.pageNo});
}

class CloseReader extends EbookEvent {
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