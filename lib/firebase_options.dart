// File generated normally by the FlutterFire CLI.
//
// ============================================================================
// ⚠️  IMPORTANT — REPLACE THIS ENTIRE FILE WITH YOUR OWN ⚠️
// ============================================================================
// This is a PLACEHOLDER so the project compiles out of the box. It contains
// FAKE values and will NOT connect to any real Firebase project.
//
// To generate the real file:
//   1. Install the FlutterFire CLI:
//        dart pub global activate flutterfire_cli
//   2. Make sure you're logged into the Firebase CLI:
//        firebase login
//   3. From the root of this project, run:
//        flutterfire configure
//      -> select (or create) your Firebase project
//      -> select "android" as a platform
//      -> enter your Android package name (see android/app/build.gradle,
//         applicationId — default in this project is: com.example.amarkhata)
//   4. This will OVERWRITE this file with your real firebase_options.dart
//      and also drop google-services.json into android/app/.
//
// See README.md → "Firebase Setup" section for the complete walkthrough.
// ============================================================================

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform. '
          'Run `flutterfire configure` to add support.',
        );
    }
  }

  /// ⚠️ REPLACE ALL VALUES BELOW with the ones from your own Firebase
  /// project (Project Settings → Your apps → Android app → google-services.json).

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCR-Xh_-7xlVJpXz1GpzsoTDk9IJDkarbk',
    appId: '1:467883410916:android:b65a972c95e4b757d473f1',
    messagingSenderId: '467883410916',
    projectId: 'lenden-215f1',
    databaseURL: 'https://lenden-215f1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'lenden-215f1.firebasestorage.app',
  );
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBC_WD_EHT6UBiIzwnU8SnXZYGxDxqe_H4',
    appId: '1:467883410916:web:6a9171152d38bd46d473f1',
    messagingSenderId: '467883410916',
    projectId: 'lenden-215f1',
    authDomain: 'lenden-215f1.firebaseapp.com',
    databaseURL: 'https://lenden-215f1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'lenden-215f1.firebasestorage.app',
    measurementId: 'G-JT9NYWE8C0',
  );
}
