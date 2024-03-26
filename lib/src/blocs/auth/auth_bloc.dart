import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:sharemagazines/src/models/registrierung_model.dart';
import 'package:sharemagazines/src/resources/auth_repository.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../models/userDetails_model.dart';
import '../../presentation/widgets/src/easyloading/easy_loading.dart';
import '../../resources/dioClient.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  ApiClient dioClient = ApiClient(dioforImages: Dio(), diofordata: Dio(), networkInfo: NetworkInfo(), secureStorage: FlutterSecureStorage());
  final GetIt getIt = GetIt.instance;

  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<Initialize>((event, emit) async {
      emit(UnAuthenticated());

      AuthState.savedEmail = await dioClient.secureStorage.read(key: "email");
      AuthState.savedPWD = await dioClient.secureStorage.read(key: "pwd");
      if (AuthState.savedEmail != null) {
        AuthState.savedEmail = await dioClient.secureStorage.read(key: "emailGuest");
        AuthState.savedEmail = await dioClient.secureStorage.read(key: "pwdGuest");
      }
    });

    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      try {
        print("SignInRequested onEvent");
        await authRepository
            .signIn(email: event.email, password: event.password, token: event.token, fingerprint: event.fingerprint)
            .then((value) async => {
                  print("link with firebase"),
                  if (event.qrscan == false) {dioClient.secureStorage.write(key: "email", value: event.email)},
                  if (event.qrscan == false) {dioClient.secureStorage.write(key: "pwd", value: event.password)},
                  if (event.qrscan == false) AuthState.savedEmail = event.email,
                  if (event.qrscan == false) AuthState.savedPWD = event.password,
                  print(value),
                  // credential = EmailAuthProvider.credential(email: event.email, password: event.password),
                  // AuthState.userDetails = await authRepository.getUserDetails(userID: value.response!.id, email: value.response!.email),
                  await authRepository.getUserDetails(userID: value.response!.id, email: value.response!.email).then((value) => {
                        AuthState.userDetails = value,
                        if (state is IncompleteAuthenticated) {emit(IncompleteAuthenticated())} else {emit(Authenticated())}
                      }),
                });
      } catch (e) {
        // await EasyLoading.dismiss();
        emit(AuthError(e.toString()));
      }
    });

    on<IncompleteSignInRequested>((event, emit) async {
      try {
        await EasyLoading.show(
          status: 'Logging in as guest...',
          maskType: EasyLoadingMaskType.black,
        );
        String? existingemail = await dioClient.secureStorage.read(key: "emailGuest");
        String? existingpwd = await dioClient.secureStorage.read(key: "pwdGuest");
        if (existingemail == null && existingpwd == null) {
          await authRepository.signInIncomplete().then((value) async => {
                print("qwertrefgve"),
                dioClient.secureStorage.write(key: "emailGuest", value: value?.response?.email),
                dioClient.secureStorage.write(key: "pwdGuest", value: value?.response?.password),
                AuthState.savedEmail = value?.response?.email,
                AuthState.savedPWD = value?.response?.password,
                await authRepository
                    .signIn(email: value?.response?.email, password: value?.response?.password, token: "", fingerprint: "")
                    .then((valueIncomplete) async => {
                          // await authRepository.signIn(email: value?.response?.email, password: value?.response?.password).then((value) async => {}),
                          // emit(IncompleteAuthenticated()),
                          await EasyLoading.dismiss(),
                          AuthState.inCompleteUserDetails =
                              await authRepository.getUserDetails(userID: valueIncomplete.response!.id, email: valueIncomplete.response!.email),
                          emit(IncompleteAuthenticated()),
                        }),
              });
        } else {
          await authRepository.signIn(email: existingemail, password: existingpwd, token: "", fingerprint: "").then((value) async => {
                AuthState.savedEmail = existingemail,
                AuthState.savedPWD = existingpwd,
                await EasyLoading.dismiss(),
                AuthState.inCompleteUserDetails = await authRepository.getUserDetails(userID: value.response!.id, email: value.response!.email),
                emit(IncompleteAuthenticated()),
              });
        }
        // }
      } catch (e) {
        dioClient.secureStorage.delete(key: "emailGuest");
        dioClient.secureStorage.delete(key: "pwdGuest");
        AuthState.savedEmail = "";
        AuthState.savedPWD = "";
        await EasyLoading.dismiss();
        emit(AuthError(e.toString()));
        // emit(UnAuthenticated());
        // emit(AuthError(e.toString()));
      }
    });

    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated() State if no error occurs
    on<SignUpRequested>((event, emit) async {
      try {
        await authRepository
            .signUp(
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
                origin: event.origin!)
            .then((value) => add(SignInRequested(event.email, event.password, '', '', false)))
            .onError((error, stackTrace) {
          emit(AuthError(error.toString()));
          // Assuming Registrierung is a class you might want to create an instance of it and return.
          return Registrierung();
        });
        // emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<OpenLoginPage>((event, emit) async {
      try {
        emit(GoToLoginPage());
        AuthState.savedEmail = await dioClient.secureStorage.read(key: "email");
        AuthState.savedPWD = await dioClient.secureStorage.read(key: "pwd");
      } on Exception catch (e) {
        emit(AuthError(e.toString()));
        // TODO
      }
    });

    on<DeleteAccount>((event, emit) async {
      try {
        AuthState.savedPWD = await dioClient.secureStorage.read(key: "pwd");
        await authRepository.deleteUser(event.user_details, AuthState.savedPWD).then((value) => emit(UnAuthenticated()));
        // emit(UnAuthenticated());
        AuthState.savedEmail = await dioClient.secureStorage.read(key: "email");
        AuthState.savedPWD = await dioClient.secureStorage.read(key: "pwd");
      } on Exception catch (e) {
        emit(AuthError(e.toString()));
        // TODO
      }
    });

    // on<SignInWithGoogle>((event, emit) async {
    //   final response = await authRepository.signInWithGoogle();
    //   print("Google response ${response}");
    //   if (response) {
    //     emit(AuthenticatedWithGoogle());
    //   } else {
    //     emit(UnAuthenticated());
    //   }
    //   // emit(GoToLoginPage());
    // });
    //
    // on<SignUpWithGoogle>((event, emit) async {
    //   final response = await authRepository.signInWithGoogle();
    //   print("Google response ${response}");
    //   if (response) {
    //     emit(AuthenticatedWithGoogle());
    //   } else {
    //     emit(UnAuthenticated());
    //   }
    //   // emit(GoToLoginPage());
    // });

    // on<SignUpWithApple>((event, emit) async {
    //   final credential = await SignInWithApple.getAppleIDCredential(
    //     scopes: [
    //       AppleIDAuthorizationScopes.email,
    //       AppleIDAuthorizationScopes.fullName,
    //     ],
    //   );
    //
    //   print(credential);
    //   // if (response) {
    //   //   // emit(AuthenticatedWithGoogle());
    //   // } else {
    //   //   // emit(UnAuthenticated());
    //   // }
    //   // emit(GoToLoginPage());
    // });

    //IMPORTANT: delete the "emailGuest", "email" and passwords from cache
    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SignOutRequested>((event, emit) async {
      // emit(Loading());
      // dioClient.secureStorage.delete(key: "email");
      dioClient.secureStorage.delete(key: "pwd");
      // AuthState.userDetails = GetUserDetails();
      emit(UnAuthenticated());
    });
  }
}