
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
// import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// import 'package:printing/printing.dart';

import 'package:sharemagazines/src/resources/magazine_repository.dart';
import 'package:sharemagazines/src/models/magazinePublishedGetAllLastByHotspotId_model.dart'
    as model;


part 'reader_event.dart';
part 'reader_state.dart';

// enum NavbarItems { Home, Menu, Map, Account }

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final MagazineRepository magazineRepository;
  // final MagazineRepository magazineRepository;
  // late ReaderState currentState;
  late List<Uint8List> image = [];
  late Uint8List image123;
  late List<Future<Uint8List>> futureFuncAllPages = List.empty(growable: true);
  late Uint8List pdfDocument;

  static late int? length;

  late Future<Uint8List> pageImageBytes;
  late List<Uint8List> pdfImgages = List.empty(growable: true);

  CancelToken cancelToken = CancelToken();
  // final dio = Dio();
  // late List<Future<Uint8List>> futureFunc = List.empty(growable: true);
  ReaderBloc({required this.magazineRepository}) : super(ReaderOpened()) {
    // on<Initialize>((event, emit) async {
    //   emit(Initialized());
    // });

    // on<OpenReader>((event, emit) async {
    //   print("OpenReader");
    //   try {
    //     // for (var i = 0; i < int.parse(event.magazine.pageMax!); i++) {
    //     // for (var i = 0; i < int.parse(event.magazine.pageMax!); i++) {
    //     //   if(i<=3){
    //     //     await DefaultCacheManager()
    //     //         .getFileFromCache(event.magazine.idMagazinePublication! +
    //     //             "_" +
    //     //             event.magazine.dateOfPublication! +
    //     //             "_" +
    //     //             i.toString())
    //     //         .then((value) async => {
    //     //               if (value?.file.lengthSync() == null)
    //     //                 {
    //     //                   print(
    //     //                       "page does not exist2 ${NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!} ${value}"),
    //     //                   magazineRepository.GetPagesforReader(
    //     //                       page: i,
    //     //                       id_mag_pub: event.magazine.idMagazinePublication,
    //     //                       date_of_publication:
    //     //                           event.magazine.dateOfPublication,
    //     //                       readerCancelToken: cancelToken),
    //     //                 }
    //     //             });
    //     //   }
    //     //
    //     //   await DefaultCacheManager()
    //     //       .getFileFromCache(event.magazine.idMagazinePublication! +
    //     //           "_" +
    //     //           event.magazine.dateOfPublication! +
    //     //           "_" +
    //     //           i.toString() +
    //     //           "_" +
    //     //           "thumbnail")
    //     //       .then((value) async => {
    //     //             if (value?.file.lengthSync() == null)
    //     //               {
    //     //                 print(
    //     //                     "page does not exist2 ${NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!} ${value}"),
    //     //                 magazineRepository.GetThumbnailforReader(
    //     //                     page: i,
    //     //                     id_mag_pub: event.magazine.idMagazinePublication,
    //     //                     date_of_publication:
    //     //                         event.magazine.dateOfPublication,
    //     //                     readerCancelToken: cancelToken),
    //     //               }
    //     //           });
    //     // }
    //   } catch (error) {
    //     print("OpenReader error - $error");
    //     emit(ReaderError(error.toString()));
    //   } finally {
    //     // emit(ReaderOpened(futureFuncAllPages));
    //     emit(ReaderOpened());
    //   }
    //   // }
    // });
    on<DownloadPage>((event, emit) async {
      print("DownloadPage");
      try {
        if (event.pageNo <= int.parse(event.magazine.pageMax!)) {
          await DefaultCacheManager()
              .getFileFromCache(
                  event.magazine.idMagazinePublication! +
                      "_" +
                      event.magazine.dateOfPublication! +
                      "_" +
                      event.pageNo.toString(),
                  ignoreMemCache: false)
              .then((value) async => {
                    if (value?.file.lengthSync() == null)
                      {
                        // print("page does not exist3 ${NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!} ${value}"),
                        magazineRepository.GetPagesforReader(
                            page: event.pageNo,
                            id_mag_pub: event.magazine.idMagazinePublication,
                            date_of_publication:
                                event.magazine.dateOfPublication,
                            readerCancelToken: cancelToken),
                      }
                  });
        }
      } catch (error) {
        print("OpenReader error - $error");
        emit(ReaderError(error.toString()));
      }
    });

    on<DownloadThumbnail>((event, emit) async {
      print("DownloadThumbnail");
      try {
        if (event.pageNo <= int.parse(event.magazine.pageMax!)) {
          await DefaultCacheManager()
              .getFileFromCache(
                  event.magazine.idMagazinePublication! +
                      "_" +
                      event.magazine.dateOfPublication! +
                      "_" +
                      event.pageNo.toString() +
                      "_" +
                      "thumbnail",
                  ignoreMemCache: false)
              .then((value) async => {
                    if (value?.file.lengthSync() == null)
                      {
                        // print("page does not exist3 ${NavbarState.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!} ${value}"),
                        magazineRepository.GetThumbnailforReader(
                            page: event.pageNo,
                            id_mag_pub: event.magazine.idMagazinePublication,
                            date_of_publication:
                                event.magazine.dateOfPublication,
                            // readerCancelToken: cancelToken
                        ),
                      }
                  });
        }
      } catch (error) {
        print("OpenReader error - $error");
        emit(ReaderError(error.toString()));
      }
    });

    on<CloseReader>((event, emit) async {
      print("cancelToken.cancel() ");
      cancelToken.cancel();
      emit(ReaderClosed(futureFuncAllPages));
    });
  }
}