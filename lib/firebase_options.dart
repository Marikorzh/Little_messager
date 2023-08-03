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
        return macos;
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
    apiKey: 'AIzaSyAb3eFsAuSik0sLDTi3vrzShyDRKyQk3ek',
    appId: '1:227117818426:web:56952a4639ec5b86890b03',
    messagingSenderId: '227117818426',
    projectId: 'first-try-d2b03',
    authDomain: 'first-try-d2b03.firebaseapp.com',
    storageBucket: 'first-try-d2b03.appspot.com',
    measurementId: 'G-60XXCC002B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsB7paVrd9RwO2Gt7xW-eq4vGs5rdrSds',
    appId: '1:227117818426:android:cabb682ece8bf4db890b03',
    messagingSenderId: '227117818426',
    projectId: 'first-try-d2b03',
    storageBucket: 'first-try-d2b03.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDq2JaQKDH22uP6XMe5b8zL5Tk2EGuuB4A',
    appId: '1:227117818426:ios:bb90f346ddd48646890b03',
    messagingSenderId: '227117818426',
    projectId: 'first-try-d2b03',
    storageBucket: 'first-try-d2b03.appspot.com',
    iosClientId: '227117818426-24pel72jj6v7it5fs4pk3gv8r730g0eo.apps.googleusercontent.com',
    iosBundleId: 'com.example.messager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDq2JaQKDH22uP6XMe5b8zL5Tk2EGuuB4A',
    appId: '1:227117818426:ios:bb90f346ddd48646890b03',
    messagingSenderId: '227117818426',
    projectId: 'first-try-d2b03',
    storageBucket: 'first-try-d2b03.appspot.com',
    iosClientId: '227117818426-24pel72jj6v7it5fs4pk3gv8r730g0eo.apps.googleusercontent.com',
    iosBundleId: 'com.example.messager',
  );
}
