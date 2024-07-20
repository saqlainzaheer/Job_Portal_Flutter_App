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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBZmoSmTTBvOE5VeqOIE7GkALTcLybfF5Y',
    appId: '1:47755496192:web:5f0b62a390c34a0af281e5',
    messagingSenderId: '47755496192',
    projectId: 'jobportal-575c2',
    authDomain: 'jobportal-575c2.firebaseapp.com',
    storageBucket: 'jobportal-575c2.appspot.com',
    measurementId: 'G-HZYV0MV3YD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKpttk5AASkaJjHq2PuA1RlnzrxtAr7m0',
    appId: '1:47755496192:android:b082fa60d2889ed2f281e5',
    messagingSenderId: '47755496192',
    projectId: 'jobportal-575c2',
    storageBucket: 'jobportal-575c2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBmq3AtEtYLB43kefSKGWfClVw9bnFxDUM',
    appId: '1:47755496192:ios:0128d5a020e94f15f281e5',
    messagingSenderId: '47755496192',
    projectId: 'jobportal-575c2',
    storageBucket: 'jobportal-575c2.appspot.com',
    iosBundleId: 'com.example.jobPortal',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBZmoSmTTBvOE5VeqOIE7GkALTcLybfF5Y',
    appId: '1:47755496192:web:dd9d0d9c330ad415f281e5',
    messagingSenderId: '47755496192',
    projectId: 'jobportal-575c2',
    authDomain: 'jobportal-575c2.firebaseapp.com',
    storageBucket: 'jobportal-575c2.appspot.com',
    measurementId: 'G-G18KJFLWZR',
  );
}
