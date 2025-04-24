import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAP8Jq96CySgpAEcYU13vMiw95vTlKYAEA",
    authDomain: "gardeniatoday-82e68.firebaseapp.com",
    projectId: "gardeniatoday-82e68",
    storageBucket: "gardeniatoday-82e68.firebasestorage.app",
    messagingSenderId: "79911467145",
    appId: "1:79911467145:web:34adee95f50ac65e4eae58",
    measurementId: "G-0KWN75E378",
  );
}