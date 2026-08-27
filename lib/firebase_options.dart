// File generated to match the output of the FlutterFire CLI.
//
// This file is listed in .gitignore, so it is absent from fresh clones. It was
// reconstructed from values already committed to the repository:
//   * `android/app/google-services.json` - api key, sender id, storage bucket
//   * `firebase.json`                    - the per-platform Firebase app ids
// The `authDomain` below is the project's own authorised domain.
//
// If the Firebase project is ever reconfigured, regenerate this file rather than
// hand-editing it:
//
//   npm install -g firebase-tools && firebase login
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
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
          'run "flutterfire configure" to add them.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const String _apiKey = 'AIzaSyCUsh9vYt1zcs3oIgozKIV4LlSgCKp5F40';
  static const String _messagingSenderId = '755876834223';
  static const String _projectId = 'omnia-acm';
  static const String _storageBucket = 'omnia-acm.appspot.com';
  static const String _bundleId = 'com.example.omnia';

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _apiKey,
    appId: '1:755876834223:android:eb24e69536bb2ce1521d5a',
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: _apiKey,
    appId: '1:755876834223:ios:fb3c33ec8a83410e521d5a',
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
    iosBundleId: _bundleId,
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: _apiKey,
    appId: '1:755876834223:ios:fb3c33ec8a83410e521d5a',
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
    iosBundleId: _bundleId,
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: _apiKey,
    appId: '1:755876834223:web:1cd09cd55ea1c98e521d5a',
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    authDomain: 'omnia-acm.firebaseapp.com',
    storageBucket: _storageBucket,
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: _apiKey,
    appId: '1:755876834223:web:1030495ecc00b75a521d5a',
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    authDomain: 'omnia-acm.firebaseapp.com',
    storageBucket: _storageBucket,
  );
}
