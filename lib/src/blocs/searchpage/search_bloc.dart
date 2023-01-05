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

import '../../constants.dart';
import '../../models/location_model.dart';
import '../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../resources/dioClient.dart';
import '../navbar/navbar_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

// enum NavbarItems { Home, Menu, Map, Account }

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MagazineRepository magazineRepository;
  late List<Uint8List> image = [];
  List<dynamic?> oldSearchResults = List.empty(growable: true);
  ApiClient dioClient = ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());

  late List<Future<Uint8List>> searchResultCovers = List.empty(growable: true);
  static late MagazinePublishedGetAllLastByHotspotId? allMagazinesData;
  // late List<Future<Uint8List>> futureFuncLanguageResultsALL = List.empty(growable: true);
  // late List<Future<Uint8List>> futureFuncLanguageResultsDE = List.empty(growable: true);
  // late List<Future<Uint8List>> futureFuncLanguageResultsEN = List.empty(growable: true);
  // late List<Future<Uint8List>> futureFuncLanguageResultsFR = List.empty(growable: true);
  SearchBloc({required this.magazineRepository}) : super(LoadingSearchState()) {
    on<DeleteSearchResult>((event, emit) async {
      oldSearchResults.removeAt(event.index);
      await dioClient.secureStorage.write(key: "oldSearchResults", value: jsonEncode(oldSearchResults));
    });

    on<Initialize>((event, emit) async {
      print("Search Bloc Initialize");
      // print(BlocProvider.of<NavbarBloc>(event.context));
      // NavbarState navBarState = BlocProvider.of<NavbarBloc>(event.context).state;
      allMagazinesData = await NavbarState.magazinePublishedGetLastWithLimit;
      // add(OpenSearch());
      // futureFuncLanguageResults = await BlocProvider.of<NavbarBloc>(event.context).state.magazinePublishedGetLastWithLimit
      // await BlocProvider.of<NavbarBloc>(event.context).state.magazinePublishedGetLastWithLimit();
      // NavbarState navbarState = BlocProvider.of<NavbarBloc>(event.context).state;
      // magazinePublishedGetLastWithLimitdata = navbarState.magazinePublishedGetLastWithLimit;
      // await BlocProvider.of<NavbarBloc>(event.context).state.magazinePublishedGetLastWithLimit().then((value) => {});
      // for (var i = 0; i < await navbarState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
      //   print("magazinePublishedGetLastWithLimitdata = ${navbarState.magazinePublishedGetLastWithLimit!.response!.length}");
      //   // if (navbarState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase() {
      //   print(navbarState.magazinePublishedGetLastWithLimit!.response![i].name!);
      //   futureFuncLanguageResultsALL.add(navbarState.futureFunc![i]);
      //   // }
      // }
      // for (var i = 0; i < await navbarState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
      //   if (navbarState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("de")) {
      //     print(navbarState.magazinePublishedGetLastWithLimit!.response![i].name!);
      //     futureFuncLanguageResultsDE.add(navbarState.futureFunc![i]);
      //   }
      // }
      // for (var i = 0; i < await navbarState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
      //   if (navbarState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("en")) {
      //     print(navbarState.magazinePublishedGetLastWithLimit!.response![i].name!);
      //     futureFuncLanguageResultsEN.add(navbarState.futureFunc![i]);
      //   }
      // }
      // for (var i = 0; i < await navbarState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
      //   if (navbarState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("fr")) {
      //     print(navbarState.magazinePublishedGetLastWithLimit!.response![i].name!);
      //     futureFuncLanguageResultsFR.add(navbarState.futureFunc![i]);
      //   }
      // }
      add(OpenSearch());
    });

    on<OpenSearch>((event, emit) async {
      print("OpenSearch");
      String? stringOfItems = await dioClient.secureStorage.read(key: 'oldSearchResults');
      // await dioClient.secureStorage.deleteAll();
      if (stringOfItems != null && stringOfItems.isNotEmpty) {
        List<dynamic?> temp = jsonDecode(stringOfItems);
        print("stringOfItems $temp");
        // oldSearchResults = temp;
        oldSearchResults = temp;
      }
      // List<dynamic> listOfItems = jsonDecode(stringOfItems);
      // if (stringOfItems.isNotEmpty){
      //   List<dynamic> listOfItems = jsonDecode(stringOfItems!);
      // }else{
      //
      // }
      emit(GoToSearchPage(oldSearchResults));
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
      searchResultCovers.clear(); //removes the old search covers

      // if()
      // String? stringOfItems = await dioClient.secureStorage.read(key: 'oldSearchResults');
      // if (stringOfItems != null && stringOfItems.isNotEmpty) {
      //   // List<dynamic> parsedListJson = jsonDecode(stringOfItems);
      //   // List<String> itemsList = List<String>.from(parsedListJson.map<String>((dynamic i) => String.fromJson(i)));
      //   oldSearchResults.add(jsonDecode(stringOfItems));
      // }
      // print(stringOfItems);
      // List<String> listViewerBuilderString = listOfItems + event.searchText.toLowerCase().toString();

      // await dioClient.secureStorage.write(key: 'listOfItems', value: jsonEncode(listViewerBuilderString));
      if (oldSearchResults?.contains(event.searchText) == false) {
        oldSearchResults?.add(event.searchText.toLowerCase().toString());
        await dioClient.secureStorage.write(key: "oldSearchResults", value: jsonEncode(oldSearchResults));
      }
      // await dioClient.secureStorage.write(key: "search_results", value: jsonEncode(event.searchText.toLowerCase()));
      // BlocListener
      NavbarState navbarState = BlocProvider.of<NavbarBloc>(event.context).state;
      print("navbarstate searchbloc ${BlocProvider.of<NavbarBloc>(event.context).state}");
      // if (navbarState == GoToHome()) {
      // if (navbarState is GoToHome) {
      //   for (var i = 0; i < navbarState.magazinePublishedGetLastWithLimit_HomeState!.response!.length; i++) {
      //     if (navbarState.magazinePublishedGetLastWithLimit_HomeState!.response![i].name!.toLowerCase().contains(event.searchText.toLowerCase())) {
      //       print(navbarState.magazinePublishedGetLastWithLimit_HomeState!.response![i].name!);
      //
      //       searchResultCovers.add(navbarState.languageResultsALL_HomeState![i]);
      //     }
      //     // futureFunc.add(magazineRepository.GetPage(page: '0', id_mag_pub: magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication!));
      //     // print(futureFunc[i]);
      //   }
      // }
      for (var i = 0; i < allMagazinesData!.response!.length; i++) {
        if (allMagazinesData!.response![i].name!.toLowerCase().contains(event.searchText.toLowerCase())) {
          print(allMagazinesData!.response![i].name!);

          searchResultCovers.add(NavbarState.languageResultsALL![i]);
        }
        // futureFunc.add(magazineRepository.GetPage(page: '0', id_mag_pub: magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication!));
        // print(futureFunc[i]);
      }
      emit(GoToSearchResults(searchResultCovers));
    });
    on<OpenLanguageResults>((event, emit) async {
      print("OpenLanguageResults");
      emit(GoToLanguageResults(
          event.languageText.toLowerCase().contains("german")
              ? NavbarState.languageResultsDE
              : event.languageText.toLowerCase().contains("english")
                  ? NavbarState.languageResultsEN
                  : event.languageText.toLowerCase().contains("french")
                      ? NavbarState.languageResultsFR
                      : NavbarState.languageResultsALL,
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
  }
}

// import 'dart:convert';
//
// import 'dart:typed_data';
//
// import 'package:bloc/bloc.dart';
// import 'package:dio/adapter.dart';
// import 'package:dio/dio.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:network_info_plus/network_info_plus.dart';
// import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';
//
// import '../constants.dart';
// import '../models/location_model.dart';
// import '../models/magazinePublishedGetAllLastByHotspotId_model.dart';
// import '../resources/dioClient.dart';
// import 'navbar_bloc.dart';
//
// part 'search_event.dart';
// part 'search_state.dart';
//
// // enum NavbarItems { Home, Menu, Map, Account }
//
// class SearchBloc extends Bloc<SearchEvent, SearchState> {
//   final MagazineRepository magazineRepository;
//   // final MagazineRepository magazineRepository;
//   // late ReaderState currentState;
//   late List<Uint8List> image = [];
//   // late Uint8List image123;
//   List<dynamic?> oldSearchResults = List.empty(growable: true);
//   ApiClient dioClient = ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());
//
//   late List<Future<Uint8List>> searchResultCovers = List.empty(growable: true);
//   static late MagazinePublishedGetAllLastByHotspotId? magazinePublishedGetLastWithLimitdata_SearchBloc;
//   // late List<Future<Uint8List>> futureFuncLanguageResultsALL = List.empty(growable: true);
//   // late List<Future<Uint8List>> futureFuncLanguageResultsDE = List.empty(growable: true);
//   // late List<Future<Uint8List>> futureFuncLanguageResultsEN = List.empty(growable: true);
//   // late List<Future<Uint8List>> futureFuncLanguageResultsFR = List.empty(growable: true);
//   SearchBloc({required this.magazineRepository}) : super(Loading()) {
//     // on<Initialize>((event, emit) async {
//     //   emit(Initialized());
//     //   // try {
//     //   //   print("emission-1");
//     //   //   // final magazinePublishedGetLastWithLimitdata = await magazineRepository
//     //   //   //     .magazinePublishedGetLastWithLimit(id_hotspot: '0');
//     //   //   // // print(magazinePublishedGetLastWithLimit!.response);
//     //   //   print("blocc");
//     //   //   // currentState = GoToHome(
//     //   //   //     magazinePublishedGetLastWithLimit:
//     //   //   //         magazinePublishedGetLastWithLimitdata!);
//     //   //   final getimage =
//     //   //       await magazineRepository.Getimage(page: '0', id_mag_pub: '190360');
//     //   //   print(getimage);
//     //   //   print("blocc");
//     //   //   emit(GoToHome(magazinePublishedGetLastWithLimitdata, getimage));
//     //   // } catch (e) {
//     //   //   print("noemission");
//     //   //   emit(NavbarError(e.toString()));
//     //   // }
//     // });
//
//     on<DeleteSearchResult>((event, emit) async {
//       oldSearchResults.removeAt(event.index);
//     });
//     on<Initialize>((event, emit) async {
//       print("Search Bloc Initialize");
//       print(BlocProvider.of<NavbarBloc>(event.context));
//       // add(OpenSearch());
//       // futureFuncLanguageResults = await BlocProvider.of<NavbarBloc>(event.context).state.magazinePublishedGetLastWithLimit
//       // await BlocProvider.of<NavbarBloc>(event.context).state.magazinePublishedGetLastWithLimit();
//       // NavbarState navbarState = BlocProvider.of<NavbarBloc>(event.context).state;
//       // magazinePublishedGetLastWithLimitdata = navbarState.magazinePublishedGetLastWithLimit;
//       // await BlocProvider.of<NavbarBloc>(event.context).state.magazinePublishedGetLastWithLimit().then((value) => {});
//       // for (var i = 0; i < await navbarState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
//       //   print("magazinePublishedGetLastWithLimitdata = ${navbarState.magazinePublishedGetLastWithLimit!.response!.length}");
//       //   // if (navbarState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase() {
//       //   print(navbarState.magazinePublishedGetLastWithLimit!.response![i].name!);
//       //   futureFuncLanguageResultsALL.add(navbarState.futureFunc![i]);
//       //   // }
//       // }
//       // for (var i = 0; i < await navbarState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
//       //   if (navbarState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("de")) {
//       //     print(navbarState.magazinePublishedGetLastWithLimit!.response![i].name!);
//       //     futureFuncLanguageResultsDE.add(navbarState.futureFunc![i]);
//       //   }
//       // }
//       // for (var i = 0; i < await navbarState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
//       //   if (navbarState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("en")) {
//       //     print(navbarState.magazinePublishedGetLastWithLimit!.response![i].name!);
//       //     futureFuncLanguageResultsEN.add(navbarState.futureFunc![i]);
//       //   }
//       // }
//       // for (var i = 0; i < await navbarState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
//       //   if (navbarState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("fr")) {
//       //     print(navbarState.magazinePublishedGetLastWithLimit!.response![i].name!);
//       //     futureFuncLanguageResultsFR.add(navbarState.futureFunc![i]);
//       //   }
//       // }
//       add(OpenSearch());
//     });
//
//     on<OpenSearch>((event, emit) async {
//       // ReaderOpened(futureFunc);
//       print("OpenSearch");
//       // await dioClient.secureStorage.deleteAll();
//       String? stringOfItems = await dioClient.secureStorage.read(key: 'oldSearchResults');
//       // await dioClient.secureStorage.deleteAll();
//       if (stringOfItems != null && stringOfItems.isNotEmpty) {
//         List<dynamic?> temp = jsonDecode(stringOfItems);
//         print("stringOfItems $temp");
//         // oldSearchResults = temp;
//         oldSearchResults = temp;
//       }
//       // List<dynamic> listOfItems = jsonDecode(stringOfItems);
//       // if (stringOfItems.isNotEmpty){
//       //   List<dynamic> listOfItems = jsonDecode(stringOfItems!);
//       // }else{
//       //
//       // }
//       emit(GoToSearchPage(oldSearchResults));
//       // print(" OpenReader ");
//
//       // try {
//       //   for (var i = 0; i < int.parse(event.pageNo); i++) {
//       //     futureFunc.add(magazineRepository.GetPagesforReader(page: i.toString(), id_mag_pub: event.idMagazinePublication));
//       //   }
//       // } finally {
//       //   emit(ReaderOpened(futureFunc));
//       // }
//     });
//
//     on<OpenSearchResults>((event, emit) async {
//       // ReaderOpened(futureFunc);
//       print("OpenSearchResults");
//       searchResultCovers.clear(); //removes the old search covers
//
//       // if()
//       // String? stringOfItems = await dioClient.secureStorage.read(key: 'oldSearchResults');
//       // if (stringOfItems != null && stringOfItems.isNotEmpty) {
//       //   // List<dynamic> parsedListJson = jsonDecode(stringOfItems);
//       //   // List<String> itemsList = List<String>.from(parsedListJson.map<String>((dynamic i) => String.fromJson(i)));
//       //   oldSearchResults.add(jsonDecode(stringOfItems));
//       // }
//       // print(stringOfItems);
//       // List<String> listViewerBuilderString = listOfItems + event.searchText.toLowerCase().toString();
//
//       // await dioClient.secureStorage.write(key: 'listOfItems', value: jsonEncode(listViewerBuilderString));
//       if (oldSearchResults?.contains(event.searchText) == false) {
//         oldSearchResults?.add(event.searchText.toLowerCase().toString());
//         await dioClient.secureStorage.write(key: "oldSearchResults", value: jsonEncode(oldSearchResults));
//       }
//       // await dioClient.secureStorage.write(key: "search_results", value: jsonEncode(event.searchText.toLowerCase()));
//       // BlocListener
//       NavbarState navbarState = BlocProvider.of<NavbarBloc>(event.context).state;
//       print("navbarstate searchbloc ${BlocProvider.of<NavbarBloc>(event.context).state}");
//       // if (navbarState == GoToHome()) {
//       if (navbarState is GoToHome) {
//         for (var i = 0; i < navbarState.magazinePublishedGetLastWithLimit_HomeState!.response!.length; i++) {
//           if (navbarState.magazinePublishedGetLastWithLimit_HomeState!.response![i].name!.toLowerCase().contains(event.searchText.toLowerCase())) {
//             print(navbarState.magazinePublishedGetLastWithLimit_HomeState!.response![i].name!);
//
//             searchResultCovers.add(navbarState.languageResultsALL_HomeState![i]);
//           }
//           // futureFunc.add(magazineRepository.GetPage(page: '0', id_mag_pub: magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication!));
//           // print(futureFunc[i]);
//         }
//       }
//       // print(navbarState?.magazinePublishedGetLastWithLimit_HomeState.response?.length);
//       // magazinePublishedGetLastWithLimitdata = navbarState.magazinePublishedGetLastWithLimit!;
//
//       // }
//       emit(GoToSearchResults(searchResultCovers));
//       // print(" OpenReader ");
//
//       // try {
//       //   for (var i = 0; i < int.parse(event.pageNo); i++) {
//       //     futureFunc.add(magazineRepository.GetPagesforReader(page: i.toString(), id_mag_pub: event.idMagazinePublication));
//       //   }
//       // } finally {
//       //   emit(ReaderOpened(futureFunc));
//       // }
//     });
//     on<OpenLanguageResults>((event, emit) async {
//       // ReaderOpened(futureFunc);
//       print("OpenLanguageResults");
//       // // futureFuncLanguageResults.clear();
//       // String? stringOfItems = await dioClient.secureStorage.read(key: 'listOfItems');
//       // if (stringOfItems != null && stringOfItems.isNotEmpty) {
//       //   listOfItems.add(jsonDecode(stringOfItems));
//       // }
//       // listOfItems.add(event.searchText.toLowerCase().toString());
//       // // List<String> listViewerBuilderString = listOfItems + event.searchText.toLowerCase().toString();
//       //
//       // // await dioClient.secureStorage.write(key: 'listOfItems', value: jsonEncode(listViewerBuilderString));
//       // await dioClient.secureStorage.write(key: "search_results", value: jsonEncode(event.searchText.toLowerCase()));
//       // // BlocListener
//       // NavbarState navbarState = BlocProvider.of<NavbarBloc>(event.context).state;
//       // // print(BlocProvider.of<NavbarBloc>(event.context).currentState);
//       // // if (navbarState == GoToHome()) {
//       // print(navbarState.magazinePublishedGetLastWithLimit?.response?.length);
//       // for (var i = 0; i < navbarState.magazinePublishedGetLastWithLimit!.response!.length; i++) {
//       //   if (navbarState.magazinePublishedGetLastWithLimit!.response![i].name!.toLowerCase().contains(event.searchText.toLowerCase())) {
//       //     print(navbarState.magazinePublishedGetLastWithLimit!.response![i].name!);
//       //     futureFunc.add(navbarState.futureFunc![i]);
//       //   }
//       //   // futureFunc.add(magazineRepository.GetPage(page: '0', id_mag_pub: magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication!));
//       //   // print(futureFunc[i]);
//       // }
//       // // }
//
//       // emit(GoToLanguageResults(
//       //     event.languageText.toLowerCase().contains("german")
//       //         ? futureFuncLanguageResultsDE
//       //         : event.languageText.toLowerCase().contains("english")
//       //             ? futureFuncLanguageResultsEN
//       //             : event.languageText.toLowerCase().contains("french")
//       //                 ? futureFuncLanguageResultsFR
//       //                 : futureFuncLanguageResultsALL,
//       //     null));
//
//       // emit(GoToLanguageResults(
//       //     magazinePublishedGetLastWithLimitdata,
//       //     event.languageText.toLowerCase().contains("german")
//       //         ? BlocProvider.of<NavbarBloc>(event.context).currentState.languageResultsALL_HomeState
//       //         : event.languageText.toLowerCase().contains("english")
//       //             ? BlocProvider.of<NavbarBloc>(event.context).state.languageResultsEN
//       //             : event.languageText.toLowerCase().contains("french")
//       //                 ? BlocProvider.of<NavbarBloc>(event.context).state.languageResultsFR
//       //                 : BlocProvider.of<NavbarBloc>(event.context).state.languageResultsALL,
//       //     null));
//       // print(" OpenReader ");
//
//       // try {
//       //   for (var i = 0; i < int.parse(event.pageNo); i++) {
//       //     futureFunc.add(magazineRepository.GetPagesforReader(page: i.toString(), id_mag_pub: event.idMagazinePublication));
//       //   }
//       // } finally {
//       //   emit(ReaderOpened(futureFunc));
//       // }
//     });
//     // print(image);
//     // print("bloccc");
//     // try {
//     //   final magazinePublishedGetLastWithLimit = await magazineRepository
//     //       .magazinePublishedGetLastWithLimit(id_hotspot: '0');
//     //   emit(GoToHome(magazinePublishedGetLastWithLimit!));
//     // } catch (e) {
//     //   emit(NavbarError(e.toString()));
//     // }
//     // });
//   }
// }