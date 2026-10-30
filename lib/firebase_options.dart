import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';

class DefaultFirebaseOptions {
  static firebase_core.FirebaseOptions get currentPlatform {
    return web;
  }

  static const firebase_core.FirebaseOptions web = firebase_core.FirebaseOptions(
    apiKey: 'AIzaSyASHAc6jeaUsxAAcmj3yRASIHGi08hnSzw',
    appId: '1:835516163255:web:c38a4455714a449b7ed932',
    messagingSenderId: '835516163255',
    projectId: 'deck-news-25755',
    storageBucket: 'deck-news-25755.firebasestorage.app',
    authDomain: 'deck-news-25755.firebaseapp.com',
  );

  static const firebase_core.FirebaseOptions android = firebase_core.FirebaseOptions(
    apiKey: 'AIzaSyASHAc6jeaUsxAAcmj3yRASIHGi08hnSzw',
    appId: '1:835516163255:android:placeholder',
    messagingSenderId: '835516163255',
    projectId: 'deck-news-25755',
    storageBucket: 'deck-news-25755.firebasestorage.app',
  );

  static const firebase_core.FirebaseOptions ios = firebase_core.FirebaseOptions(
    apiKey: 'AIzaSyASHAc6jeaUsxAAcmj3yRASIHGi08hnSzw',
    appId: '1:835516163255:ios:placeholder',
    messagingSenderId: '835516163255',
    projectId: 'deck-news-25755',
    storageBucket: 'deck-news-25755.firebasestorage.app',
  );
}
