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
    apiKey: 'AIzaSyDdUJ0u_mE7XQ20Ylyfbf-rNj9KL8IheFY',
    appId: '1:716530621601:web:eb34ff27d20e26d21be4e0',
    messagingSenderId: '716530621601',
    projectId: 'find-jobs-6651e',
    authDomain: 'find-jobs-6651e.firebaseapp.com',
    storageBucket: 'find-jobs-6651e.firebasestorage.app',
    measurementId: 'G-GNW65B2ESL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLJnQrcxOI0s0BG0Vq_FtaVKgWtGoMqcA',
    appId: '1:716530621601:android:9481fd3f75265d981be4e0',
    messagingSenderId: '716530621601',
    projectId: 'find-jobs-6651e',
    storageBucket: 'find-jobs-6651e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMuNOB1TA1VpErym0_b5efp98EznOQPDs',
    appId: '1:716530621601:ios:665a5d3f03ca4d2b1be4e0',
    messagingSenderId: '716530621601',
    projectId: 'find-jobs-6651e',
    storageBucket: 'find-jobs-6651e.firebasestorage.app',
    iosBundleId: 'com.example.findjobs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAMuNOB1TA1VpErym0_b5efp98EznOQPDs',
    appId: '1:716530621601:ios:665a5d3f03ca4d2b1be4e0',
    messagingSenderId: '716530621601',
    projectId: 'find-jobs-6651e',
    storageBucket: 'find-jobs-6651e.firebasestorage.app',
    iosBundleId: 'com.example.findjobs',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDdUJ0u_mE7XQ20Ylyfbf-rNj9KL8IheFY',
    appId: '1:716530621601:web:2197a9be06668b9b1be4e0',
    messagingSenderId: '716530621601',
    projectId: 'find-jobs-6651e',
    authDomain: 'find-jobs-6651e.firebaseapp.com',
    storageBucket: 'find-jobs-6651e.firebasestorage.app',
    measurementId: 'G-84ZGV5V66Z',
  );
}
