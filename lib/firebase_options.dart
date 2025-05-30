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
    apiKey: 'AIzaSyClPpdXw05BX3Zo9RIc-RlmhG4hpBzjAI8',
    appId: '1:1005029508161:web:a760338e976fb8550bf2c0',
    messagingSenderId: '1005029508161',
    projectId: 'loginregistration-cddbb',
    authDomain: 'loginregistration-cddbb.firebaseapp.com',
    storageBucket: 'loginregistration-cddbb.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXKHLgXrkurTh7y1qAq1m-6emEMcX5GeI',
    appId: '1:1005029508161:android:9428fa7a36adce570bf2c0',
    messagingSenderId: '1005029508161',
    projectId: 'loginregistration-cddbb',
    storageBucket: 'loginregistration-cddbb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAl-Y722ZuWucU6SO5bKgmHv7Oxi-Bw2hk',
    appId: '1:1005029508161:ios:becbd324a0f473210bf2c0',
    messagingSenderId: '1005029508161',
    projectId: 'loginregistration-cddbb',
    storageBucket: 'loginregistration-cddbb.firebasestorage.app',
    iosBundleId: 'com.example.mySecureNotes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAl-Y722ZuWucU6SO5bKgmHv7Oxi-Bw2hk',
    appId: '1:1005029508161:ios:becbd324a0f473210bf2c0',
    messagingSenderId: '1005029508161',
    projectId: 'loginregistration-cddbb',
    storageBucket: 'loginregistration-cddbb.firebasestorage.app',
    iosBundleId: 'com.example.mySecureNotes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyClPpdXw05BX3Zo9RIc-RlmhG4hpBzjAI8',
    appId: '1:1005029508161:web:0c8e09b21d4228590bf2c0',
    messagingSenderId: '1005029508161',
    projectId: 'loginregistration-cddbb',
    authDomain: 'loginregistration-cddbb.firebaseapp.com',
    storageBucket: 'loginregistration-cddbb.firebasestorage.app',
  );
}
