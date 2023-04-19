import 'dart:convert';

import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart' as dio;
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

  static late MagazinePublishedGetAllLastByHotspotId categoryCovers;
  static late MagazinePublishedGetAllLastByHotspotId? selectedLanguageCovers;
  static late MagazinePublishedGetAllLastByHotspotId? searchResultCovers;

  static late MagazinePublishedGetAllLastByHotspotId? frLanguageCovers;
  List<dynamic?> oldSearchResults = List.empty(growable: true);
  ApiClient dioClient = ApiClient(dioforImages: dio.Dio(), diofordata: dio.Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());

  SearchBloc({required this.magazineRepository}) : super(LoadingSearchState()) {
    on<DeleteSearchResult>((event, emit) async {
      try {
        print("remove at ${event.index}");
        oldSearchResults.removeAt(event.index);
        await dioClient.secureStorage.write(key: "oldSearchResults", value: jsonEncode(oldSearchResults));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });

    //Probably dont need this
    on<Initialize>((event, emit) async {
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
      emit(GoToSearchPage(oldSearchResults));
    });

    on<OpenSearchResults>((event, emit) async {
      if (oldSearchResults?.contains(event.searchText) == false) {
        oldSearchResults?.add(event.searchText.toLowerCase().toString());
        await dioClient.secureStorage.write(key: "oldSearchResults", value: jsonEncode(oldSearchResults));
      }
      NavbarState navbarState = BlocProvider.of<NavbarBloc>(event.context).state;
      searchResultCovers = MagazinePublishedGetAllLastByHotspotId(
          response: NavbarState.magazinePublishedGetLastWithLimit!.response!.where((element) => element.name!.toLowerCase().contains(event.searchText.toLowerCase()) == true).toList());

      emit(GoToSearchResults(searchResultCovers));
    });
    on<OpenLanguageResults>((event, emit) async {
      if (event.languageText != "all") {
        selectedLanguageCovers = MagazinePublishedGetAllLastByHotspotId(
            response: NavbarState.magazinePublishedGetLastWithLimit!.response!.where((element) => element.magazineLanguage!.contains(event.languageText) == true).toList());
      } else {
        selectedLanguageCovers = NavbarState.magazinePublishedGetLastWithLimit;
      }
      emit(GoToLanguageResults(selectedLanguage: selectedLanguageCovers));
    });
    on<OpenCategoryPage>((event, emit) async {
      categoryCovers = MagazinePublishedGetAllLastByHotspotId(
          response: NavbarState.magazinePublishedGetLastWithLimit!.response!.where((element) => element.idsMagazineCategory!.contains(event.categoryID) == true).toList());
      emit(GoToCategoryPage(selectedCategory: categoryCovers));
    });
  }
}