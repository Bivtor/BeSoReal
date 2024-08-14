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
    apiKey: 'AIzaSyDu2SzFHoZpzG9p_QKyPx6I9f3Wqv9SadI',
    appId: '1:697261533137:web:1124c053e47a73c2ec62f0',
    messagingSenderId: '697261533137',
    projectId: 'besoreal-f5fd5',
    authDomain: 'besoreal-f5fd5.firebaseapp.com',
    storageBucket: 'besoreal-f5fd5.appspot.com',
    measurementId: 'G-XRNV81R5YX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBIELS-Assjbhz9QjpbiU2elFBkN6n9aEQ',
    appId: '1:697261533137:android:b1f9ae2072f2cd7eec62f0',
    messagingSenderId: '697261533137',
    projectId: 'besoreal-f5fd5',
    storageBucket: 'besoreal-f5fd5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXayEPYD_6blPEPSvRwORoxwMS4acs07A',
    appId: '1:697261533137:ios:87a05398c755aa95ec62f0',
    messagingSenderId: '697261533137',
    projectId: 'besoreal-f5fd5',
    storageBucket: 'besoreal-f5fd5.appspot.com',
    iosBundleId: 'com.example.client',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCXayEPYD_6blPEPSvRwORoxwMS4acs07A',
    appId: '1:697261533137:ios:87a05398c755aa95ec62f0',
    messagingSenderId: '697261533137',
    projectId: 'besoreal-f5fd5',
    storageBucket: 'besoreal-f5fd5.appspot.com',
    iosBundleId: 'com.example.client',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDu2SzFHoZpzG9p_QKyPx6I9f3Wqv9SadI',
    appId: '1:697261533137:web:2b50e931e24e131bec62f0',
    messagingSenderId: '697261533137',
    projectId: 'besoreal-f5fd5',
    authDomain: 'besoreal-f5fd5.firebaseapp.com',
    storageBucket: 'besoreal-f5fd5.appspot.com',
    measurementId: 'G-FMPM69QS05',
  );

}