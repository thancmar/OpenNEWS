import 'dart:async';

import 'dart:typed_data';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:sharemagazines_flutter/src/models/location_model.dart';
import 'package:sharemagazines_flutter/src/models/magazine_publication_model.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';
import 'package:sharemagazines_flutter/src/resources/location_repository.dart';
import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

import '../constants.dart';
import '../models/hotspots_model.dart';
import '../resources/dioClient.dart';

part 'navbar_event.dart';
part 'navbar_state.dart';

// enum NavbarItems { Home, Menu, Map, Account }

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  final MagazineRepository magazineRepository;
  final LocationRepository locationRepository;
  final HotspotRepository hotspotRepository;
  late Future<HotspotsGetAllActive> hotspotList;
  late NavbarState currentState;
  // late Uint8List image123;
  // late List<Uint8List> imagebytes = [];
  late Localization appbarlocation;
  // var username;
  static late MagazinePublishedGetLastWithLimit magazinePublishedGetLastWithLimitdata;
  bool statechanged = false;
  bool completer = false;
  StreamSubscription? _meistgelesene_Subscription;
  late List<Future<Uint8List>> futureFunc = List.empty(growable: true);
  late List<Future<Uint8List>> futureFuncLanguageResultsALL = List.empty(growable: true);
  late List<Future<Uint8List>> futureFuncLanguageResultsDE = List.empty(growable: true);
  late List<Future<Uint8List>> futureFuncLanguageResultsEN = List.empty(growable: true);
  late List<Future<Uint8List>> futureFuncLanguageResultsFR = List.empty(growable: true);
  var client = http.Client();
  // late ApiClient dioClient;
  // DOnt need this
  // ApiClient dioClient = ApiClient(dioforImages: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());
  final GetIt getIt = GetIt.instance;
  var cookieJar = CookieJar();
  // GetIt getIt = GetIt.instance;

  NavbarBloc({required this.magazineRepository, required this.locationRepository, required this.hotspotRepository}) : super(Loading()) {
    on<Initialize123>((event, emit) async {
      print("access token");
      event.timer?.cancel();
      await EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
      print('EasyLoading show');
      // print(dioClient.accessToken);
      hotspotList = hotspotRepository.GetAllActiveHotspots();
      await locationRepository.checklocation().then((value) => {
            //print("checklocation value $value"),
            //appbarlocation = value!,
            magazineRepository.magazinePublishedGetLastWithLimit(id_hotspot: '0', cookieJar: cookieJar).then((data) async {
              magazinePublishedGetLastWithLimitdata = data;

              // dioClient.accessToken = data.response?.headers['set-cookie'];
              // event.timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
              //   EasyLoading.showProgress(event.progress, status: '${(event.progress * 100).toStringAsFixed(0)}%');
              //   event.progress += 0.03;
              //
              //   if (event.progress >= 1) {
              //     event.timer?.cancel();
              //     EasyLoading.dismiss();
              //   }
              // });
              for (var i = 0; i < magazinePublishedGetLastWithLimitdata.response!.length; i++) {
                print("magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication! = ${magazinePublishedGetLastWithLimitdata.response!.length}");

                futureFunc.add(magazineRepository.GetPage(page: '0', id_mag_pub: magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication!));

                // print(futureFunc[i]);
              }
              for (var i = 0; i < magazinePublishedGetLastWithLimitdata.response!.length; i++) {
                print("magazinePublishedGetLastWithLimitdata = ${magazinePublishedGetLastWithLimitdata.response!.length}");
                // if (cState.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase() {
                print(magazinePublishedGetLastWithLimitdata.response![i].name!);
                futureFuncLanguageResultsALL.add(futureFunc![i]);
                if (magazinePublishedGetLastWithLimitdata.response![i].magazineLanguage!.toLowerCase().contains("de")) {
                  print(magazinePublishedGetLastWithLimitdata.response![i].name!);
                  futureFuncLanguageResultsDE.add(futureFunc![i]);
                }
                if (magazinePublishedGetLastWithLimitdata.response![i].magazineLanguage!.toLowerCase().contains("en")) {
                  print(magazinePublishedGetLastWithLimitdata.response![i].name!);
                  futureFuncLanguageResultsEN.add(futureFunc![i]);
                }
                if (magazinePublishedGetLastWithLimitdata.response![i].magazineLanguage!.toLowerCase().contains("fr")) {
                  print(magazinePublishedGetLastWithLimitdata.response![i].name!);
                  futureFuncLanguageResultsFR.add(futureFunc![i]);
                }
                // }
              }
              // for (var i = 0; i < magazinePublishedGetLastWithLimitdata.response!.length; i++) {
              //   if (magazinePublishedGetLastWithLimitdata.response![i].magazineLanguage!.toLowerCase().contains("de")) {
              //     print(magazinePublishedGetLastWithLimitdata.response![i].name!);
              //     futureFuncLanguageResultsDE.add(futureFunc![i]);
              //   }
              // }
              // for (var i = 0; i < magazinePublishedGetLastWithLimitdata.response!.length; i++) {
              //   if (magazinePublishedGetLastWithLimitdata.response![i].magazineLanguage!.toLowerCase().contains("en")) {
              //     print(magazinePublishedGetLastWithLimitdata.response![i].name!);
              //     futureFuncLanguageResultsEN.add(futureFunc![i]);
              //   }
              // }
              // for (var i = 0; i < magazinePublishedGetLastWithLimitdata.response!.length; i++) {
              //   if (magazinePublishedGetLastWithLimitdata.response![i].magazineLanguage!.toLowerCase().contains("fr")) {
              //     print(magazinePublishedGetLastWithLimitdata.response![i].name!);
              //     futureFuncLanguageResultsFR.add(futureFunc![i]);
              //   }
              // }

              add(Home());
              event.timer?.cancel();
              await EasyLoading.dismiss();
            }),
          });

      // await Future.wait<void>([
      //   locationRepository.checklocation(),
      //   magazineRepository.magazinePublishedGetLastWithLimit(id_hotspot: '0'),
      //
      // ]).then((List responses) => emit(GoToHome(null, responses[0], futureFunc))).catchError((e) => NavbarError(e));
      // checkLocation().then((value) {
      //   add(Home());
      //   // emit(GoToHome(null, value, futureFunc));
      // });
    });

    on<Home>((event, emit) async {
      try {
        // checkLocation().then((value) {

        emit(GoToHome(magazinePublishedGetLastWithLimitdata, futureFunc, futureFuncLanguageResultsALL, futureFuncLanguageResultsDE, futureFuncLanguageResultsEN, futureFuncLanguageResultsFR, null));
        print("Navbarbloc home event emitted");
        // emit(GoToHome());
        // });
        statechanged = false;
        // MagazinePublishedGetLastWithLimit magazinePublishedGetLastWithLimitdata = await magazineRepository.magazinePublishedGetLastWithLimit(id_hotspot: '0');
        // final Localization? onLocation = await locationRepository.checklocation();
        // appbarlocation = onLocation!;
        // print(appbarlocation == onLocation);

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
        // try {
        //   for (var i = 1; i < magazinePublishedGetLastWithLimitdata.response!.length; i++) {
        //     futureFunc.add(magazineRepository.GetPage(page: '0', id_mag_pub: magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication!));
        //     // print(futureFunc[i]);
        //   }
        // } finally {
        //   // if (statechanged == false) {
        //
        //   // print(futureFunc[1]);
        //   // print("emission-Home-bloc");
        //   // emit(GoToHome(magazinePublishedGetLastWithLimitdata, appbarlocation!, futureFunc));
        //   // for (var p = 1; p < 10; p++) {
        //   // print("api response");
        //   // print(futureFunc.first.asStream());
        //   // }
        //   // }
        // }

        // statsechanged = true;
      } catch (e) {
        // statechanged = false;
      }
    });
    on<Menu>((event, emit) async {
      statechanged = true;
      emit(GoToMenu(appbarlocation));
      statechanged = false;
    });
    // on<HomeorMenu>((event, emit) async {
    //   emit(GoToHomeorMenu());
    // });
    on<Map>((event, emit) async {
      statechanged = true;
      emit(GoToMap(null, null, null));
      statechanged = false;
    });
    on<AccountEvent>((event, emit) async {
      statechanged = true;
      emit(GoToAccount(null, null, null));
      statechanged = false;
    });
    // on<Location>((event, emit) async {
    //   emit(GoToLocation());
    //   // statechanged = true;
    // });
    // on<Search>((event, emit) async {
    //   emit(GoToSearch());
    //   // statechanged = true;
    // });
  }

  //Future<Localization> checkLocation() async {
  //return await locationRepository.checklocation();
  //}
  // void getNavBarItem(NavbarItems navbarItem) {
  //   switch (navbarItem) {
  //     case NavbarItems.Home:
  //       emit(NavbarState(NavbarItems.Home, 0));
  //       break;
  //     case NavbarItems.Menu:
  //       emit(NavbarState(NavbarItems.Menu, 1));
  //       break;
  //     case NavbarItems.Map:
  //       emit(NavbarState(NavbarItems.Map, 2));
  //       break;
  //     case NavbarItems.Account:
  //       emit(NavbarState(NavbarItems.Account, 3));
  //       break;
  //   }
  // }
}