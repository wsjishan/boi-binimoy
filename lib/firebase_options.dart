import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions is not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnGPIs5VFzJIfyTKI09siV8PgG1kHJCxI',
    appId: '1:867943037888:android:e72153da9f3a3f66e66625',
    messagingSenderId: '867943037888',
    projectId: 'boibinimoy-c0321',
    storageBucket: 'boibinimoy-c0321.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDYEAdabWofQdsChzI306n200P-8Lv1Sts',
    appId: '1:867943037888:ios:44fd516f77cbb6f1e66625',
    messagingSenderId: '867943037888',
    projectId: 'boibinimoy-c0321',
    storageBucket: 'boibinimoy-c0321.firebasestorage.app',
    iosBundleId: 'com.example.boiBinimoy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDYEAdabWofQdsChzI306n200P-8Lv1Sts',
    appId: '1:867943037888:ios:44fd516f77cbb6f1e66625',
    messagingSenderId: '867943037888',
    projectId: 'boibinimoy-c0321',
    storageBucket: 'boibinimoy-c0321.firebasestorage.app',
    iosBundleId: 'com.example.boiBinimoy',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAH3cvliuZcR62PpslAPeqwAthfyZhiaEM',
    appId: '1:867943037888:web:fb663d6d4a9a243ae66625',
    messagingSenderId: '867943037888',
    projectId: 'boibinimoy-c0321',
    authDomain: 'boibinimoy-c0321.firebaseapp.com',
    storageBucket: 'boibinimoy-c0321.firebasestorage.app',
    measurementId: 'G-VBMMZLJS4H',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAH3cvliuZcR62PpslAPeqwAthfyZhiaEM',
    appId: '1:867943037888:web:f37e8665bd05461ae66625',
    messagingSenderId: '867943037888',
    projectId: 'boibinimoy-c0321',
    authDomain: 'boibinimoy-c0321.firebaseapp.com',
    storageBucket: 'boibinimoy-c0321.firebasestorage.app',
    measurementId: 'G-HB5DT3G4EK',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyDMjocSFdxjT2SZ52vTftijHNilQ_pNQkY',
    appId: 'placeholder',
    messagingSenderId: '244153744298',
    projectId: 'boi-binimoy-141a6',
    storageBucket: 'boi-binimoy-141a6.firebasestorage.app',
  );
}