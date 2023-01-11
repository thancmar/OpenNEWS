import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sharemagazines_flutter/src/models/incomplete_login_model.dart';
import 'package:sharemagazines_flutter/src/models/login_model.dart';
import 'package:sharemagazines_flutter/src/models/registrierung_model.dart';
import 'package:sharemagazines_flutter/src/resources/dioClient.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _fbAuth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class AuthRepository {
  Future<Registrierung> signUp(
      {required String email,
      required String password,
      required String firstname,
      required String lastname,
      required String date_of_birth,
      required String sex,
      String? address_street,
      required String address_house_nr,
      required String address_zip,
      required String address_city,
      required String phone,
      required String iban,
      required String account_owner,
      required String creation_date,
      required String origin}) async {
    Map data = {
      'f': 'readerAdd',
      'json':
          '{"email": "$email", "password":"$password", "firstname":"$firstname", "lastname":"$lastname", "date_of_birth":"$date_of_birth", "sex":"$sex","address_street":"$address_street" ,"address_house_nr":"$address_house_nr","address_zip":"$address_zip","address_city":"$address_city","phone":"$phone","iban":"$iban","account_owner":"$account_owner","creation_date":"","origin":"$origin"}'
    };
    print(data);

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint),
      body: data,
      // headers: head,
    );
    print("login response: ${response.body}");
    if (response.statusCode == 200) {
      // return jokeModelFromJson(response.body);
      // print(response.body);
      if (json.decode(response.body)['response']['code'] == 1062) {
        print("1062");
        throw Exception("Failed to signup");
      } else {
        // String rawCookie = response.headers['set-cookie'] ?? _cookieData;
        print("rk");
        print(response.headers['set-cookie']);
        // try {
        //   UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: "barry.allen@example.com", password: "SuperSecretPassword!");
        // } on FirebaseAuthException catch (e) {
        //   if (e.code == 'weak-password') {
        //     print('The password provided is too weak.');
        //   } else if (e.code == 'email-already-in-use') {
        //     print('The account already exists for that email.');
        //   }
        // } catch (e) {
        //   print(e);
        // }
        return RegistrierungFromJson(response.body);
      }
    } else {
      throw Exception("Failed to login");
    }
  }
  // Future<User> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //   // Create a new credential
  //   final GoogleAuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   final UserCredential authResult =
  //   await _fbAuth.signInWithCredential(credential);
  //   final User user = authResult.user;
  //   assert(!user.isAnonymous);
  //   assert(await user.getIdToken() != null);
  //   final User currentUser = _fbAuth.currentUser;
  //   assert(currentUser.uid == user.uid);
  //   return user;
  // }

  Future<bool> signInWithGoogle() async {
    try {
      // final user = FirebaseAuth.instance.currentUser!;
      // final GoogleSignInAccount? user = GoogleSignIn().currentUser ?? await GoogleSignIn().signIn();
      print("GoogleSignIn().currentUser ${GoogleSignIn().currentUser}");
      final GoogleSignInAccount? user = await GoogleSignIn().signIn();
      print("GoogleSignIn().signIn() ${user}");
      // if (user != null) {
      //   await GoogleSignIn().signOut();
      // }
      print("signInWithGoogle");
      final GoogleSignInAuthentication? googleAuth = await user?.authentication;
      print("signInWithGoogle");
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      print(FirebaseAuth.instance.currentUser?.email);
      return true;
    } catch (e) {
      print('An Error Occurred $e');
      return false;
    }
  }

  Future<void> handleSignOut() => GoogleSignIn().disconnect();
  // Future<void> signOut() async {
  //   final _googleSignIn = GoogleSignIn();
  //   _googleSignIn.disconnect();
  // }

  Future<LoginModel> signIn({
    required String? email,
    required String? password,
    // required ApiClient client,
  }) async {
    print("Complete signIn");
    final getIt = GetIt.instance;
    Map data = {'f': 'readerLogin', 'json': '{"email": "$email", "password":"$password", "version":"5", "client":"ios", "lang":"en", "token":"","fingerprint":"AABBCC"}'};

    final response = await getIt<ApiClient>().diofordata.post(ApiConstants.usersEndpoint, data: data, options: Options(responseType: ResponseType.plain));
    print("User login response: ${response.data}");
    // print(response!.headers);
//COde 103 cannot add reader
    if (response.statusCode == 200) {
      // return jokeModelFromJson(response.body);
      // print(response!.realUri);
      if (json.decode(response.data)['response']['code'] == 107) {
        print("107");
        throw Exception("Invalid login data(code 107)");
      } else {
        // String rawCookie = response.headers['set-cookie'] ?? _cookieData;
        print("rl Login");
        print(response.data);
        print(response.headers['set-cookie']);
        // client.accessToken = response.headers['set-cookie'].toString();
        print("rl Login");
        // final credential =
        // EmailAuthProvider.credential(email: LoginModelFromJson(response.data).response!.email!, password: LoginModelFromJson(response.data).response!.);
        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email!,
            password: password!,
          );
          print("crurrent user $userCredential");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
            try {
              UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email!,
                password: password!,
              );
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                print('The password provided is too weak.');
              } else if (e.code == 'email-already-in-use') {
                print('The account already exists for that email.');
              }
            } catch (e) {
              print(e);
            }
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
          print(e);
        }

        return LoginModelFromJson(response.data);
      }
    } else {
      throw Exception("Failed to login. Code ${response.statusCode}");
    }
  }

  Future<IncompleteLoginModel?> signInIncomplete() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Incomplete signIn");
    final getIt = GetIt.instance;
    Map data = {
      'f': 'incompleteReaderAdd',
    };

    var response = await getIt<ApiClient>().diofordata.post(
          ApiConstants.usersEndpoint,
          data: data,
        );
    // print(response!.data);
    print("User Incomplete login response: ${response.data}");
    if (response.statusCode == 200) {
      // return jokeModelFromJson(response.body);
      print(json.decode(response.data)['response']['code']);
      if (json.decode(response.data)['response']['code'] == 103) {
        throw Exception("Failed to login with code 103");
      } else {
        return IncompleteLoginModelFromJson(response.data);
      }
    } else {
      throw Exception("Failed to login");
    }
  }

  Future<void> signOut() async {
    Map data = {'f': 'readerLogin'};
    final response = await http.post(Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint), body: data);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', '');
      prefs.setString('pw', '');
      prefs.setString('cookie', '');
      return;
    } else {
      throw Exception("Failed to logout");
    }
  }
}