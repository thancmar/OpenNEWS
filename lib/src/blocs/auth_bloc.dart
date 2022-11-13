import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/models/hotspots_model.dart';
import 'package:sharemagazines_flutter/src/models/incomplete_login_model.dart';
import 'package:sharemagazines_flutter/src/resources/auth_repository.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';

import '../resources/dioClient.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final HotspotRepository hotspotRepository;

  // late ApiClient dioClient;
  ApiClient dioClient = ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());
  final GetIt getIt = GetIt.instance;

  // final _dataController = StreamController<String>.broadcast();
  // Sink<String?> get searchQuery => _dataController.sink;
  // late Stream<HotspotsGetAllActive> hotspotStream;

  AuthBloc({required this.authRepository, required this.hotspotRepository}) : super(UnAuthenticated()) {
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      print("signin");
      emit(LoadingAuth());
      // getIt.registerSingleton<ApiClient>(dioClient = ApiClient(dio: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage()), signalsReady: true);
      // dioClient = ApiClient(dio: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());
      // getIt.registerSingleton(() => ApiClient(dio: getIt<Dio>(), networkInfo: getIt<NetworkInfo>(), secureStorage: getIt<FlutterSecureStorage>()));
      // print(getIt.isRegistered());
      try {
        final data = await authRepository.signIn(email: event.email, password: event.password);
        // await authRepository.signIn(email: data?.response?.email, password: data?.response?.password);
        // print("asdasfsdfsd123432423");
        // print(data!.response!.email!);
        // await dioClient.secureStorage.write(key: "email", value: data!.response!.email!);
        // await dioClient.secureStorage.write(key: "pw", value: data!.response!.password!);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<IncompleteSignInRequested>((event, emit) async {
      print("first");
      emit(LoadingAuth());

      // getIt.registerSingleton<ApiClient>(ApiClient(dio: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage()), signalsReady: true);
      // dioClient = ApiClient(dio: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());
      // await dioClient.secureStorage.deleteAll();
      var emailexists = await dioClient.secureStorage.read(key: "email");
      var pwexists = await dioClient.secureStorage.read(key: "pw");
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // var emailexists = prefs.getString("email");
      // var pwexists = prefs.getString("pw");
      // print(getIt.isRegistered());
      print("check emailexists");
      print(emailexists);
      if (emailexists is Null || emailexists == "") {
        try {
          await authRepository
              .signInIncomplete(client: dioClient)
              .then((value) async => await authRepository.signIn(email: value?.response?.email, password: value?.response?.password).then((value) => emit(IncompleteAuthenticated())));
          print("2001");
          // final data = await authRepository.signInIncomplete(client: dioClient);
          // print(data?.response?.email);
          //
          // await authRepository.signIn(email: data?.response?.email, password: data?.response?.password);
          // // print("asdasfsdfsd123432423");
          // print(data!.response!.email!);
          // // await dioClient.secureStorage.write(key: "email", value: data!.response!.email!);
          // // await dioClient.secureStorage.write(key: "pw", value: data!.response!.password!);
          // // print(event.password);
          // // print("asdasfsdfasdsd");
          // // prefs.setString('email', data.response!.email!);
          // // prefs.setString('pw', data.response!.password!);
          // // print("lateinierr");
          // // await hotspotRepository.GetAllActiveHotspots();
          // // hotspotStream = _dataController.stream
          // //     .asyncMap((query) => hotspotRepository.GetAllActiveHotspots());
          //
          // print("mmmm");
          // emit(IncompleteAuthenticated());
        } catch (e) {
          print("err");
          emit(AuthError(e.toString()));
          emit(UnAuthenticated());
        }
      } else {
        print("IncompleteSignInRequested else");
        print("email = $emailexists");
        print("pw = $pwexists");
        await authRepository.signIn(email: emailexists, password: pwexists).then((value) => emit(IncompleteAuthenticated()));
        // hotspotStream = _dataController.stream
        //     .asyncMap((query) => hotspotRepository.GetAllActiveHotspots());
        // emit(IncompleteAuthenticated());
      }
    });

    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignUpRequested>((event, emit) async {
      emit(LoadingAuth());
      try {
        await authRepository.signUp(
            email: event.email,
            password: event.password,
            firstname: event.firstname,
            lastname: event.lastname,
            date_of_birth: event.date_of_birth,
            sex: event.sex,
            address_street: event.address_street!,
            address_house_nr: event.address_house_nr!,
            address_zip: event.address_zip!,
            address_city: event.address_city!,
            phone: event.phone!,
            iban: event.iban!,
            account_owner: event.account_owner!,
            creation_date: event.creation_date!,
            origin: event.origin!);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    // When User Presses the Google Login Button, we will send the GoogleSignInRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    // on<GoogleSignInRequested>((event, emit) async {
    //   emit(Loading());
    //   try {
    //     await authRepository.signInWithGoogle();
    //     emit(Authenticated());
    //   } catch (e) {
    //     emit(AuthError(e.toString()));
    //     emit(UnAuthenticated());
    //   }
    // });
    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SignOutRequested>((event, emit) async {
      // emit(Loading());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', "");
      prefs.setString('pw', "");
      await authRepository.signOut();
      emit(UnAuthenticated());
    });
  }
  dispose() {
    // _dataController.close();
  }
}