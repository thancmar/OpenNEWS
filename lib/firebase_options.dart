// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDP_hc7r_dadsVYGJWR9Tf9jmteU0htjj4',
    appId: '1:67186045229:web:702cb380afc6c49c1963a4',
    messagingSenderId: '67186045229',
    projectId: 'sharemagazines-flutter',
    authDomain: 'sharemagazines-flutter.firebaseapp.com',
    storageBucket: 'sharemagazines-flutter.appspot.com',
    measurementId: 'G-45M1NTFFWZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyMtHcSrgSzY2iVlJ7Fs3lQ7yJUrYICtE',
    appId: '1:67186045229:android:52323acf93d704681963a4',
    messagingSenderId: '67186045229',
    projectId: 'sharemagazines-flutter',
    storageBucket: 'sharemagazines-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5He432_5IPlxLObeUlHFES8KuUYOByAk',
    appId: '1:67186045229:ios:a9f6e1a32d57f5e51963a4',
    messagingSenderId: '67186045229',
    projectId: 'sharemagazines-flutter',
    storageBucket: 'sharemagazines-flutter.appspot.com',
    iosClientId: '67186045229-988ch9pnoebs8shhiccv4jpgiso3en4f.apps.googleusercontent.com',
    iosBundleId: 'com.shmagflutter.sharemagazines',
  );
}
