// Firebase client config for project `azeem-book-app` (same shape the
// FlutterFire CLI generates). These values are public client identifiers that
// ship inside every app build — not secrets.
//
// iOS isn't registered yet: it needs the app's real bundle id (still the
// `com.example.azeemBookApp` placeholder) and an APNs key in Firebase. Until
// then `currentPlatform` is null on iOS and push is simply disabled there.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions? get currentPlatform {
    if (kIsWeb) return null;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      _ => null,
    };
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjxL9qU1l_iN3J1rnHxCRugBDFuhujwHc',
    appId: '1:2154052341:android:97f507f2f4f15b26b763bc',
    messagingSenderId: '2154052341',
    projectId: 'azeem-book-app',
    storageBucket: 'azeem-book-app.firebasestorage.app',
  );
}
