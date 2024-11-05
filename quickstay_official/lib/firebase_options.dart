// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyADVbmO2pl_NDrHQkSYgciaTEesnmfUYAg',
    appId: '1:531597869449:web:75bc8f896356c748952158',
    messagingSenderId: '531597869449',
    projectId: 'quickstay-ab4ec',
    authDomain: 'quickstay-ab4ec.firebaseapp.com',
    storageBucket: 'quickstay-ab4ec.appspot.com',
    measurementId: 'G-70R4ZMV1ZC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdS5E7RuiyP1Jz0a7Nuxb76WIVMDP7SVY',
    appId: '1:531597869449:android:f4d31f288ffc9e43952158',
    messagingSenderId: '531597869449',
    projectId: 'quickstay-ab4ec',
    storageBucket: 'quickstay-ab4ec.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBoMRSnJavl7W0iiWFda90GHKeD8v6SXhE',
    appId: '1:531597869449:ios:805537d57bb96127952158',
    messagingSenderId: '531597869449',
    projectId: 'quickstay-ab4ec',
    storageBucket: 'quickstay-ab4ec.appspot.com',
    iosBundleId: 'com.example.quickstayOfficial',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBoMRSnJavl7W0iiWFda90GHKeD8v6SXhE',
    appId: '1:531597869449:ios:805537d57bb96127952158',
    messagingSenderId: '531597869449',
    projectId: 'quickstay-ab4ec',
    storageBucket: 'quickstay-ab4ec.appspot.com',
    iosBundleId: 'com.example.quickstayOfficial',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyADVbmO2pl_NDrHQkSYgciaTEesnmfUYAg',
    appId: '1:531597869449:web:7e45f1457a8c4965952158',
    messagingSenderId: '531597869449',
    projectId: 'quickstay-ab4ec',
    authDomain: 'quickstay-ab4ec.firebaseapp.com',
    storageBucket: 'quickstay-ab4ec.appspot.com',
    measurementId: 'G-9HRPYEX1N2',
  );
}
