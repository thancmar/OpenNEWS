import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/resources/auth_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../models/userDetails_model.dart';
import '../../resources/dioClient.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  // late ApiClient dioClient;
  late final AuthCredential credential;
  ApiClient dioClient = ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());
  final GetIt getIt = GetIt.instance;

  // final _dataController = StreamController<String>.broadcast();
  // Sink<String?> get searchQuery => _dataController.sink;
  // late Stream<HotspotsGetAllActive> hotspotStream;

  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<Initialize>((event, emit) async {
      emit(UnAuthenticated());
      String? emailexists = await dioClient.secureStorage.read(key: "email");
      String? guestemailexists = await dioClient.secureStorage.read(key: "email");
      String? existingpwd = await dioClient.secureStorage.read(key: "pwd");
      // if (emailexists != null) {
      //   emit(Authenticated());
      //   return;
      // }
      // if (guestemailexists != null) {
      //   emit(IncompleteAuthenticated());
      //   return;
      // }
      // AuthState.savedEmail = await dioClient.secureStorage.read(key: "email") ?? "asdsadddadsfdscvdfvfd";
      // print("sdfdsf ${AuthState.savedEmail}");
      // AuthState.savedPWD = await dioClient.secureStorage.read(key: "pw") ?? "";
      emit(UnAuthenticated());
    });

    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      try {
        // dioClient.secureStorage.deleteAll();
        print("SignInRequested");
        // emit(LoadingAuth());
        // getIt.registerSingleton<ApiClient>(dioClient = ApiClient(dio: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage()), signalsReady: true);
        // dioClient = ApiClient(dio: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());
        // getIt.registerSingleton(() => ApiClient(dio: getIt<Dio>(), networkInfo: getIt<NetworkInfo>(), secureStorage: getIt<FlutterSecureStorage>()));
        // print(getIt.isRegistered());
        await EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
        await authRepository.signIn(email: event.email, password: event.password).then((value) async => {
              print("link with firebase"),
              await dioClient.secureStorage.write(key: "email", value: event.email),
              await dioClient.secureStorage.write(key: "pwd", value: event.password),
              // credential = EmailAuthProvider.credential(email: event.email, password: event.password),
              // AuthState.userDetails = await authRepository.getUserDetails(userID: value.response!.id, email: value.response!.email),
              authRepository.getUserDetails(userID: value.response!.id, email: value.response!.email).then((value) => AuthState.userDetails = value),
              // await AuthState.userDetails,
              emit(Authenticated()),
            });
        // try {
        //   print("link with firebase ${FirebaseAuth.instance.currentUser?.email}");
        //   final userCredential = await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        // } on FirebaseAuthException catch (e) {
        //   print("link with firebase error");
        //   switch (e.code) {
        //     case "provider-already-linked":
        //       print("The provider has already been linked to the user.");
        //       break;
        //     case "invalid-credential":
        //       print("The provider's credential is not valid.");
        //       break;
        //     case "credential-already-in-use":
        //       print("The account corresponding to the credential already exists, "
        //           "or is already linked to a Firebase User.");
        //       break;
        //     // See the API reference for the full list of error codes.
        //     default:
        //       print("Unknown error.");
        //   }
        //   print("link with firebase currentuser ${FirebaseAuth.instance.currentUser!.email}");
        // }
        // await authRepository.signIn(email: data?.response?.email, password: data?.response?.password);
        // print("asdasfsdfsd123432423");
        // print(data!.response!.email!);
        // await dioClient.secureStorage.write(key: "email", value: data!.response!.email!);
        // await dioClient.secureStorage.write(key: "pw", value: data!.response!.password!);
        // emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        // emit(UnAuthenticated());
        emit(AuthError(e.toString()));
      }
      await EasyLoading.dismiss();
    });

    on<IncompleteSignInRequested>((event, emit) async {
      try {
        await EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
        String? existingemail = await dioClient.secureStorage.read(key: "email");
        String? existingpwd = await dioClient.secureStorage.read(key: "pwd");

        // if (AuthState.userDetails?.response?.email != existingemail) {
          if (existingemail == null && existingpwd == null) {
            await authRepository.signInIncomplete().then((value) async => {
                  print("qwertrefgve"),
                  await authRepository.signIn(email: value?.response?.email, password: value?.response?.password).then((value) async => {
                        emit(IncompleteAuthenticated()),
                        AuthState.userDetails = await authRepository.getUserDetails(userID: value.response!.id, email: value.response!.email),
                      }),
                  dioClient.secureStorage.write(key: "email", value: value?.response?.email),
                  dioClient.secureStorage.write(key: "pwd", value: value?.response?.password)
                });
          } else {
            await authRepository.signIn(email: existingemail, password: existingpwd).then((value) async => {
                  emit(IncompleteAuthenticated()),
                  AuthState.userDetails = await authRepository.getUserDetails(userID: value.response!.id, email: value.response!.email),
                });
          }
        // }
        emit(IncompleteAuthenticated());
        print("2001");
      } catch (e) {
        emit(AuthError(e.toString()));
        // emit(UnAuthenticated());
        emit(AuthError(e.toString()));
      }
      // await EasyLoading.dismiss();
      // await EasyLoading.dismiss();
    });

    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated() State if no error occurs
    on<SignUpRequested>((event, emit) async {
      // emit(LoadingAuth());
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

    on<OpenLoginPage>((event, emit) async {
      AuthState.savedEmail = await dioClient.secureStorage.read(key: "email");
      AuthState.savedPWD = await dioClient.secureStorage.read(key: "pwd");
      emit(GoToLoginPage());
    });

    on<SignInWithGoogle>((event, emit) async {
      final response = await authRepository.signInWithGoogle();
      print("Google response ${response}");
      if (response) {
        emit(AuthenticatedWithGoogle());
      } else {
        emit(UnAuthenticated());
      }
      // emit(GoToLoginPage());
    });

    on<SignUpWithGoogle>((event, emit) async {
      final response = await authRepository.signInWithGoogle();
      print("Google response ${response}");
      if (response) {
        emit(AuthenticatedWithGoogle());
      } else {
        emit(UnAuthenticated());
      }
      // emit(GoToLoginPage());
    });

    on<SignUpWithApple>((event, emit) async {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print(credential);
      // if (response) {
      //   // emit(AuthenticatedWithGoogle());
      // } else {
      //   // emit(UnAuthenticated());
      // }
      // emit(GoToLoginPage());
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

    //IMPORTANT: delete the "emailGuest", "email" and passwords from cache
    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SignOutRequested>((event, emit) async {
      // emit(Loading());
      dioClient.secureStorage.delete(key: "email");
      dioClient.secureStorage.delete(key: "pwd");
      AuthState.userDetails = GetUserDetails();
      emit(UnAuthenticated());
    });
  }
  dispose() {
    // _dataController.close();
  }
}