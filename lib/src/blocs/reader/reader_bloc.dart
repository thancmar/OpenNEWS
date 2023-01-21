import 'dart:convert';

import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:printing/printing.dart';

import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';

import '../../constants.dart';

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
  late PdfDocument pdfdoc;
  late PdfPage page;
  late PdfPageImage? pageImage;
  late Future<Uint8List> pageImageBytes;
  late List<Uint8List> pdfImgages = List.empty(growable: true);

  CancelToken cancelToken = CancelToken();
  // final dio = Dio();
  // late List<Future<Uint8List>> futureFunc = List.empty(growable: true);
  ReaderBloc({required this.magazineRepository}) : super(Initialized()) {
    on<Initialize>((event, emit) async {
      emit(Initialized());
      // try {
      //   print("emission-1");
      //   // final magazinePublishedGetLastWithLimitdata = await magazineRepository
      //   //     .magazinePublishedGetLastWithLimit(id_hotspot: '0');
      //   // // print(magazinePublishedGetLastWithLimit!.response);
      //   print("blocc");
      //   // currentState = GoToHome(
      //   //     magazinePublishedGetLastWithLimit:
      //   //         magazinePublishedGetLastWithLimitdata!);
      //   final getimage =
      //       await magazineRepository.Getimage(page: '0', id_mag_pub: '190360');
      //   print(getimage);
      //   print("blocc");
      //   emit(GoToHome(magazinePublishedGetLastWithLimitdata, getimage));
      // } catch (e) {
      //   print("noemission");
      //   emit(NavbarError(e.toString()));
      // }
    });

    on<OpenReader>((event, emit) async {
      // ReaderOpened(futureFunc);
      print("OpenReader");
      print(" OpenReader ${event.idMagazinePublication}");
      // futureFuncAllPages = futureFunc;
      // dio.options.baseUrl = ApiConstants.baseUrl;
      // dio.interceptors.add(
      //   InterceptorsWrapper(
      //     onRequest: (
      //       RequestOptions requestOptions,
      //       RequestInterceptorHandler handler,
      //     ) {
      //       print(requestOptions.uri);
      //       Future.delayed(Duration(seconds: 5), () {
      //         handler.next(requestOptions);
      //       });
      //     },
      //   ),
      // );
      // dio.httpClientAdapter = DefaultHttpClientAdapter()..onHttpClientCreate = (httpClient) => httpClient..maxConnectionsPerHost = 20;
      // for (var i = 0; i < int.parse(event.pageNo) + 1; i++) {
      //   // id_mag_pub: '51');
      //   // imagebytes.add(image123);
      //
      //   image123 = await magazineRepository.GetPage(page: i.toString(), id_mag_pub: event.idMagazinePublication, client: dio);
      //   // id_mag_pub: '51');
      //   image.add(image123);
      //
      //   // var image1 = File(image).writeAsBytes(Uint8list);
      //
      //   // print("bloccc");
      //   // // print(image1);
      //   emit(ReaderOpened(image));
      // }
      //
      // emit(ReaderOpened(image));
      // if (int.parse(event.pageNo) > 5) {
      //   // try {
      //   print(event.pageNo);
      //   // for (var i = 0; i < int.parse(event.pageNo); i++) {
      //   //   futureFuncAllPages.add(magazineRepository.GetPagesforReader(page: i.toString(), id_mag_pub: event.idMagazinePublication, readerCancelToken: cancelToken));
      //   // }
      //   // Future asd = await magazineRepository.GetPagesforReader(page: "", id_mag_pub: event.idMagazinePublication, readerCancelToken: cancelToken);
      //
      //   // await magazineRepository.GetPagesAsPDFforReader(id_mag_pub: event.idMagazinePublication, readerCancelToken: cancelToken).then((value) => {emit(ReaderOpenedPDF(value))});
      //
      //   // await magazineRepository.GetPagesAsPDFforReader(id_mag_pub: event.idMagazinePublication, readerCancelToken: cancelToken).then((value) async => {
      //   //       //if we dont store it in a variable, there is a memeory leak
      //   //       pdfDocument = value,
      //   //       // emit(ReaderOpenedPDF(pdfDocument)),
      //   //       pdfdoc = await PdfDocument.openData(value),
      //   //       // page = await pdfdoc.getPage(1),
      //   //       // pageImage = await page.render(width: page.width, height: page.height, format: PdfPageImageFormat.jpeg, backgroundColor: '#FFFFFF'),
      //   //       // print(await Printing.raster(pageImage!.bytes)),
      //   //       // await page.close(),
      //   //       for (int i = 1; i < pdfdoc.pagesCount; i++)
      //   //         {
      //   //           page = await pdfdoc.getPage(i),
      //   //           pageImage = await page.render(width: page.width, height: page.height, format: PdfPageImageFormat.jpeg, backgroundColor: '#FFFFFF'),
      //   //
      //   //           pdfImgages.add(pageImage!.bytes),
      //   //
      //   //           // print("qwertz ${page1.toImage()}"),
      //   //         },
      //   //       // ReaderOpened(page.render(width: page.width, height: page.height)),
      //   //       emit(ReaderOpenedPDF(pdfImgages)),
      //   //     });
      //   //
      //   // print("event.pageNo");
      //   // pdfDocument = await PdfDocument.openData(await magazineRepository.GetPagesAsPDFforReader(id_mag_pub: event.idMagazinePublication, readerCancelToken: cancelToken));
      //   emit(ReaderOpenedPDF(pdfDocument));
      //   // } finally {
      //   //   // emit(ReaderOpenedPDF(pdfDocument));
      //   // }
      // } else {
      try {
        // image = await PdfDocument.openData(await magazineRepository.GetPagesAsPDFforReader(id_mag_pub: event.idMagazinePublication, readerCancelToken: cancelToken));
        ReaderState.doc = await magazineRepository.GetPagesAsPDFforReader(id_mag_pub: event.idMagazinePublication, readerCancelToken: cancelToken);
        //
        // for (var i = 0; i < int.parse(event.pageNo); i++) {
        //   futureFuncAllPages.add(magazineRepository.GetPagesforReader(page: i.toString(), id_mag_pub: event.idMagazinePublication, readerCancelToken: cancelToken));
        // }
      } finally {
        // emit(ReaderOpened(futureFuncAllPages));
        emit(ReaderOpened());
      }
      // }
    });
    // print(image);
    // print("bloccc");
    // try {
    //   final magazinePublishedGetLastWithLimit = await magazineRepository
    //       .magazinePublishedGetLastWithLimit(id_hotspot: '0');
    //   emit(GoToHome(magazinePublishedGetLastWithLimit!));
    // } catch (e) {
    //   emit(NavbarError(e.toString()));
    // }
    // });
    on<CloseReader>((event, emit) async {
      print("cancelToken.cancel();");
      cancelToken.cancel();
      emit(ReaderClosed(futureFuncAllPages));
    });
  }
}