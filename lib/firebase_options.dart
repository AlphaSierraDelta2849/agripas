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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBzz9M62cHu4zjARTFM824sqaC6PCBgOl8',
    appId: '1:903050467548:web:43fb05b17c1347d57afc19',
    messagingSenderId: '903050467548',
    projectId: 'agripas-3c752',
    authDomain: 'agripas-3c752.firebaseapp.com',
    storageBucket: 'agripas-3c752.firebasestorage.app',
    measurementId: 'G-97Q090KQS3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLrSywNvM2zeG1pSKw65w6ToYSSpCWll8',
    appId: '1:903050467548:android:2cc631edec0c62c87afc19',
    messagingSenderId: '903050467548',
    projectId: 'agripas-3c752',
    storageBucket: 'agripas-3c752.firebasestorage.app',
  );

}