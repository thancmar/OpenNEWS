import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/models/hotspots_model.dart';
import 'package:sharemagazines_flutter/src/models/incomplete_login_model.dart';
import 'package:sharemagazines_flutter/src/resources/auth_repository.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final HotspotRepository hotspotRepository;
  // final _dataController = StreamController<String>.broadcast();
  // Sink<String?> get searchQuery => _dataController.sink;
  // late Stream<HotspotsGetAllActive> hotspotStream;

  AuthBloc({required this.authRepository, required this.hotspotRepository})
      : super(UnAuthenticated()) {
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      print("signin");
      emit(Loading());

      try {
        await authRepository.signIn(
            email: event.email, password: event.password);

        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<IncompleteSignInRequested>((event, emit) async {
      print("first");
      emit(Loading());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var emailexists = prefs.getString("email");
      var pwexists = prefs.getString("pw");
      print("emailexists");
      if (emailexists == "") {
        try {
          print("2001");
          final data = await authRepository.signInIncomplete();
          print(data?.response?.email);

          await authRepository.signIn(
              email: data?.response?.email, password: data?.response?.password);
          print("asdasfsdfsd123432423");
          print(data!.response!.email!);
          // print(event.password);
          print("asdasfsdfasdsd");
          prefs.setString('email', data.response!.email!);
          prefs.setString('pw', data.response!.password!);
          print("lateinierr");
          // await hotspotRepository.GetAllActiveHotspots();
          // hotspotStream = _dataController.stream
          //     .asyncMap((query) => hotspotRepository.GetAllActiveHotspots());

          print("mmmm");
          emit(IncompleteAuthenticated());
        } catch (e) {
          print("err");
          emit(AuthError(e.toString()));
          emit(UnAuthenticated());
        }
      } else {
        print("IncompleteSignInRequested else");
        await authRepository.signIn(email: emailexists, password: pwexists);
        // hotspotStream = _dataController.stream
        //     .asyncMap((query) => hotspotRepository.GetAllActiveHotspots());
        emit(IncompleteAuthenticated());
      }
    });

    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignUpRequested>((event, emit) async {
      emit(Loading());
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
