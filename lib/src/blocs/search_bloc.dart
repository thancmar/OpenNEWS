import 'dart:convert';

import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';

import '../constants.dart';
import '../models/location_model.dart';
import '../models/magazine_publication_model.dart';
import '../resources/dioClient.dart';
import 'navbar_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

// enum NavbarItems { Home, Menu, Map, Account }

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MagazineRepository magazineRepository;
  // final MagazineRepository magazineRepository;
  // late ReaderState currentState;
  late List<Uint8List> image = [];
  late Uint8List image123;
  List<dynamic> listOfItems = [];
  ApiClient dioClient = ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());

  // final dio = Dio();
  late List<Future<Uint8List>> futureFuncCovers = List.empty(growable: true);
  static late MagazinePublishedGetLastWithLimit magazinePublishedGetLastWithLimitdata;
  // late List<Future<Uint8List>> futureFuncLanguageResultsALL = List.empty(growable: true);
  // late List<Future<Uint8List>> futureFuncLanguageResultsDE = List.empty(growable: true);
  // late List<Future<Uint8List>> futureFuncLanguageResultsEN = List.empty(growable: true);
  // late List<Future<Uint8List>> futureFuncLanguageResultsFR = List.empty(growable: true);
  SearchBloc({required this.magazineRepository}) : super(Loading()) {
    // on<Initialize>((event, emit) async {
    //   emit(Initialized());
    //   // try {
    //   //   print("emission-1");
    //   //   // final magazinePublishedGetLastWithLimitdata = await magazineRepository
    //   //   //     .magazinePublishedGetLastWithLimit(id_hotspot: '0');
    //   //   // // print(magazinePublishedGetLastWithLimit!.response);
    //   //   print("blocc");
    //   //   // currentState = GoToHome(
    //   //   //     magazinePublishedGetLastWithLimit:
    //   //   //         magazinePublishedGetLastWithLimitdata!);
    //   //   final getimage =
    //   //       await magazineRepository.Getimage(page: '0', id_mag_pub: '190360');
    //   //   print(getimage);
    //   //   print("blocc");
    //   //   emit(GoToHome(magazinePublishedGetLastWithLimitdata, getimage));
    //   // } catch (e) {
    //   //   print("noemission");
    //   //   emit(NavbarError(e.toString()));
    //   // }
    // });
    on<Initialize>((event, emit) async {
      print("Search Bloc Initialize");
      print(BlocProvider.of<NavbarBloc>(event.context));
      // add(OpenSearch());
      // futureFuncLanguageResults = await BlocProvider.of<NavbarBloc>(event.context).state.magazinePublishedGetLastWithLimit
      // await BlocProvider.of<NavbarBloc>(event.context).state.magazinePublishedGetLastWithLimit();
      NavbarState cState = BlocProvider.of<NavbarBloc>(event.context).state;
      magazinePublishedGetLastWithLimitdata = cState.magazinePublishedGetLastWithLimit!;
      // await BlocProvider.of<NavbarBloc>(event.context).state.magazinePublishedGetLastWithLimit().then((value) => {});
      // for (var i = 0; i < await cState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
      //   print("magazinePublishedGetLastWithLimitdata = ${cState.magazinePublishedGetLastWithLimit!.response!.length}");
      //   // if (cState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase() {
      //   print(cState.magazinePublishedGetLastWithLimit!.response![i].name!);
      //   futureFuncLanguageResultsALL.add(cState.futureFunc![i]);
      //   // }
      // }
      // for (var i = 0; i < await cState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
      //   if (cState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("de")) {
      //     print(cState.magazinePublishedGetLastWithLimit!.response![i].name!);
      //     futureFuncLanguageResultsDE.add(cState.futureFunc![i]);
      //   }
      // }
      // for (var i = 0; i < await cState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
      //   if (cState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("en")) {
      //     print(cState.magazinePublishedGetLastWithLimit!.response![i].name!);
      //     futureFuncLanguageResultsEN.add(cState.futureFunc![i]);
      //   }
      // }
      // for (var i = 0; i < await cState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
      //   if (cState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("fr")) {
      //     print(cState.magazinePublishedGetLastWithLimit!.response![i].name!);
      //     futureFuncLanguageResultsFR.add(cState.futureFunc![i]);
      //   }
      // }
      add(OpenSearch());
    });

    on<OpenSearch>((event, emit) async {
      // ReaderOpened(futureFunc);
      print("OpenSearch");
      String? stringOfItems = await dioClient.secureStorage.read(key: 'listOfItems');
      // await dioClient.secureStorage.deleteAll();
      if (stringOfItems != null && stringOfItems.isNotEmpty) {
        listOfItems.add(jsonDecode(stringOfItems));
      }
      // List<dynamic> listOfItems = jsonDecode(stringOfItems);
      // if (stringOfItems.isNotEmpty){
      //   List<dynamic> listOfItems = jsonDecode(stringOfItems!);
      // }else{
      //
      // }
      emit(GoToSearchPage(listOfItems));
      // print(" OpenReader ");

      // try {
      //   for (var i = 0; i < int.parse(event.pageNo); i++) {
      //     futureFunc.add(magazineRepository.GetPagesforReader(page: i.toString(), id_mag_pub: event.idMagazinePublication));
      //   }
      // } finally {
      //   emit(ReaderOpened(futureFunc));
      // }
    });

    on<OpenSearchResults>((event, emit) async {
      // ReaderOpened(futureFunc);
      print("OpenSearchResults");
      futureFuncCovers.clear();
      String? stringOfItems = await dioClient.secureStorage.read(key: 'listOfItems');
      if (stringOfItems != null && stringOfItems.isNotEmpty) {
        listOfItems.add(jsonDecode(stringOfItems));
      }
      listOfItems.add(event.searchText.toLowerCase().toString());
      // List<String> listViewerBuilderString = listOfItems + event.searchText.toLowerCase().toString();

      // await dioClient.secureStorage.write(key: 'listOfItems', value: jsonEncode(listViewerBuilderString));
      await dioClient.secureStorage.write(key: "search_results", value: jsonEncode(event.searchText.toLowerCase()));
      // BlocListener
      NavbarState cState = BlocProvider.of<NavbarBloc>(event.context).state;
      // print(BlocProvider.of<NavbarBloc>(event.context).currentState);
      // if (cState == GoToHome()) {
      print(cState.magazinePublishedGetLastWithLimit?.response?.length);
      // magazinePublishedGetLastWithLimitdata = cState.magazinePublishedGetLastWithLimit!;
      for (var i = 0; i < cState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
        if (cState.magazinePublishedGetLastWithLimit!.response![i].name!.toLowerCase().contains(event.searchText.toLowerCase())) {
          // print(cState.magazinePublishedGetLastWithLimit!.response![i].name!);
          futureFuncCovers.add(cState.futureFunc![i]);
        }
        // futureFunc.add(magazineRepository.GetPage(page: '0', id_mag_pub: magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication!));
        // print(futureFunc[i]);
      }
      // }
      emit(GoToSearchResults(null, futureFuncCovers, null));
      // print(" OpenReader ");

      // try {
      //   for (var i = 0; i < int.parse(event.pageNo); i++) {
      //     futureFunc.add(magazineRepository.GetPagesforReader(page: i.toString(), id_mag_pub: event.idMagazinePublication));
      //   }
      // } finally {
      //   emit(ReaderOpened(futureFunc));
      // }
    });
    on<OpenLanguageResults>((event, emit) async {
      // ReaderOpened(futureFunc);
      print("OpenLanguageResults");
      // // futureFuncLanguageResults.clear();
      // String? stringOfItems = await dioClient.secureStorage.read(key: 'listOfItems');
      // if (stringOfItems != null && stringOfItems.isNotEmpty) {
      //   listOfItems.add(jsonDecode(stringOfItems));
      // }
      // listOfItems.add(event.searchText.toLowerCase().toString());
      // // List<String> listViewerBuilderString = listOfItems + event.searchText.toLowerCase().toString();
      //
      // // await dioClient.secureStorage.write(key: 'listOfItems', value: jsonEncode(listViewerBuilderString));
      // await dioClient.secureStorage.write(key: "search_results", value: jsonEncode(event.searchText.toLowerCase()));
      // // BlocListener
      // NavbarState cState = BlocProvider.of<NavbarBloc>(event.context).state;
      // // print(BlocProvider.of<NavbarBloc>(event.context).currentState);
      // // if (cState == GoToHome()) {
      // print(cState.magazinePublishedGetLastWithLimit?.response?.length);
      // for (var i = 0; i < cState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
      //   if (cState.magazinePublishedGetLastWithLimit!.response![i].name!.toLowerCase().contains(event.searchText.toLowerCase())) {
      //     print(cState.magazinePublishedGetLastWithLimit!.response![i].name!);
      //     futureFunc.add(cState.futureFunc![i]);
      //   }
      //   // futureFunc.add(magazineRepository.GetPage(page: '0', id_mag_pub: magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication!));
      //   // print(futureFunc[i]);
      // }
      // // }

      // emit(GoToLanguageResults(
      //     event.languageText.toLowerCase().contains("german")
      //         ? futureFuncLanguageResultsDE
      //         : event.languageText.toLowerCase().contains("english")
      //             ? futureFuncLanguageResultsEN
      //             : event.languageText.toLowerCase().contains("french")
      //                 ? futureFuncLanguageResultsFR
      //                 : futureFuncLanguageResultsALL,
      //     null));
      emit(GoToLanguageResults(
          magazinePublishedGetLastWithLimitdata,
          event.languageText.toLowerCase().contains("german")
              ? BlocProvider.of<NavbarBloc>(event.context).state.futureFuncLanguageResultsDE
              : event.languageText.toLowerCase().contains("english")
                  ? BlocProvider.of<NavbarBloc>(event.context).state.futureFuncLanguageResultsEN
                  : event.languageText.toLowerCase().contains("french")
                      ? BlocProvider.of<NavbarBloc>(event.context).state.futureFuncLanguageResultsFR
                      : BlocProvider.of<NavbarBloc>(event.context).state.futureFuncLanguageResultsALL,
          null));
      // print(" OpenReader ");

      // try {
      //   for (var i = 0; i < int.parse(event.pageNo); i++) {
      //     futureFunc.add(magazineRepository.GetPagesforReader(page: i.toString(), id_mag_pub: event.idMagazinePublication));
      //   }
      // } finally {
      //   emit(ReaderOpened(futureFunc));
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
  }
}