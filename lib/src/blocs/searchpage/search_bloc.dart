import 'dart:convert';
import 'dart:math';

import 'dart:typed_data';

import 'package:bloc/bloc.dart';

// import 'package:dio/adapter.dart';
import 'package:dio/dio.dart' as dio;
import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:sharemagazines/src/models/audioBooksForLocationGetAllActive.dart';
import 'package:sharemagazines/src/models/ebooksForLocationGetAllActive.dart';
import 'package:sharemagazines/src/resources/magazine_repository.dart';

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

  static late BaseResponse categoryCovers;
  static late MagazinePublishedGetAllLastByHotspotId selectedLanguageCovers;
  static late MagazinePublishedGetAllLastByHotspotId searchResultMagazines;
  static late EbooksForLocationGetAllActive searchResultEbook;
  static late AudioBooksForLocationGetAllActive searchResultAudiobooks;

  static late MagazinePublishedGetAllLastByHotspotId? frLanguageCovers;

  // static late List<dynamic?> oldSearchResults = List.empty(growable: true);
  ApiClient dioClient = ApiClient(dioforImages: dio.Dio(), diofordata: dio.Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());

  // SearchBloc({required this.magazineRepository}) : super(GoToSearchPage(oldSearchResults)) {
  SearchBloc({required this.magazineRepository}) : super(GoToSearchPage(SearchState.oldSearchResults)) {
    on<DeleteSearchResult>((event, emit) async {
      try {
        print("remove at ${event.index}");
        SearchState.oldSearchResults!.removeAt(event.index);
        await dioClient.secureStorage.write(key: "oldSearchResults", value: jsonEncode(SearchState.oldSearchResults));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });

    // //Probably dont need this
    // on<Initialize>((event, emit) async {
    //   add(OpenSearch());
    // });

    on<OpenSearch>((event, emit) async {
      try {
        print("OpenSearch");
        String? stringOfItems = await dioClient.secureStorage.read(key: 'oldSearchResults');
        // await dioClient.secureStorage.deleteAll();
        if (stringOfItems != null && stringOfItems.isNotEmpty) {
          List<dynamic?> temp = jsonDecode(stringOfItems);
          print("stringOfItems $temp");
          // oldSearchResults = temp;
          SearchState.oldSearchResults = temp;
        }

        emit(GoToSearchPage(SearchState.oldSearchResults));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });

    on<OpenSearchResults>((event, emit) async {
      if (SearchState.oldSearchResults?.contains(event.searchText) == false && event.saveResult) {
        SearchState.oldSearchResults?.add(event.searchText.toLowerCase().toString());
        await dioClient.secureStorage.write(key: "oldSearchResults", value: jsonEncode(SearchState.oldSearchResults));
      }
      // NavbarState navbarState = BlocProvider.of<NavbarBloc>(event.context).state;
      // searchResultCovers =MagazinePublishedGetAllLastByHotspotId(response:null);

      searchResultMagazines = MagazinePublishedGetAllLastByHotspotId(
          response: NavbarState.magazinePublishedGetLastWithLimit!
              .response()!
              .where((element) => element.title!.toLowerCase().contains(event.searchText.toLowerCase().toString()) == true)
              .toList());
      await searchResultMagazines;
      searchResultEbook = EbooksForLocationGetAllActive(
          response: NavbarState.ebooks!
              .response()!
              .where((element) => element.title!.toLowerCase().contains(event.searchText.toLowerCase().toString()) == true)
              .toList());
      await searchResultEbook;
      searchResultAudiobooks = AudioBooksForLocationGetAllActive(
          response: NavbarState.audiobooks!
              .response()!
              .where((element) => element.title!.toLowerCase().contains(event.searchText.toLowerCase().toString()) == true)
              .toList());
      await searchResultAudiobooks;
      emit(GoToSearchResults(
          searchResultsMagazines: searchResultMagazines, searchResultsEbooks: searchResultEbook, searchResultsAudiobooks: searchResultAudiobooks));
    });

    on<OpenLanguageResults>((event, emit) async {
      print("search ${event.languageText}");
      if (event.languageText != "all") {
        selectedLanguageCovers = MagazinePublishedGetAllLastByHotspotId(
            response: NavbarState.magazinePublishedGetLastWithLimit!
                .response()!
                .where((element) => element.magazineLanguage?.contains(event.languageText) == true)
                .toList());
      } else {
        selectedLanguageCovers = NavbarState.magazinePublishedGetLastWithLimit;
      }
      print(selectedLanguageCovers.response());
      emit(GoToLanguageResults(selectedLanguage: selectedLanguageCovers));
    });

    on<OpenCategory>((event, emit) async {
      // categoryCovers;
      try {
        if (event.categoryType == CategoryStatus.ebooks) {
          categoryCovers = EbooksForLocationGetAllActive(response: []);
          String? cID = await NavbarState.ebookCategoryGetAllActiveByLocale!.response!.firstWhere((element) => element.name == event.categoryName).id;
          categoryCovers = EbooksForLocationGetAllActive(
              response: NavbarState.ebooks!.response()!.where((element) => element.idsEbookCategory?.contains(cID ?? '') == true).toList());
          await categoryCovers;
          emit(GoToCategoryPage(selectedCategory: categoryCovers));
        }else if (event.categoryType == CategoryStatus.hoerbuecher) {
          categoryCovers = AudioBooksForLocationGetAllActive(response: []);
          String? cID = await NavbarState.audioBooksCategoryGetAllActiveByLocale!.response!.firstWhere((element) => element.name == event.categoryName).id;
          categoryCovers = AudioBooksForLocationGetAllActive(
              response: NavbarState.audiobooks!.response()!.where((element) => element.idsAudiobookCategory?.contains(cID ?? '') == true).toList());
          await categoryCovers;
          emit(GoToCategoryPage(selectedCategory: categoryCovers));
        }else if (event.categoryType == CategoryStatus.presse) {
          categoryCovers = MagazinePublishedGetAllLastByHotspotId(response: []);
          String? cID = await NavbarState.magazineCategoryGetAllActive!.response!.firstWhere((element) => element.name == event.categoryName).id;
          categoryCovers = MagazinePublishedGetAllLastByHotspotId(
              response: NavbarState.magazinePublishedGetLastWithLimit!.response()!.where((element) => element.idsMagazineCategory?.contains(cID ?? '') == true).toList());
          await categoryCovers;
          emit(GoToCategoryPage(selectedCategory: categoryCovers));
        }else{
        categoryCovers = MagazinePublishedGetAllLastByHotspotId(response: []);
        String cID = await NavbarState.magazineCategoryGetAllActive!.response!.firstWhere((element) => element.name == event.categoryName).id!;
        categoryCovers = MagazinePublishedGetAllLastByHotspotId(
            response: NavbarState.magazinePublishedGetLastWithLimit!
                .response()!
                .where((element) => element.idsMagazineCategory?.contains(cID ?? '') == true)
                .toList());
        await categoryCovers;
        emit(GoToCategoryPage(selectedCategory: categoryCovers));}
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }
}