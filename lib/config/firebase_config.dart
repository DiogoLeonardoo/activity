import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

// Configuração do Firebase para web
class FirebaseConfig {
  static const FirebaseOptions webOptions = FirebaseOptions(
    // Configuração Web
    apiKey: "AIzaSyDoYGxAYEwl6y6sQBA6sBpLcbCRWY16QPQ",
    authDomain: "activity-db71e.firebaseapp.com",
    projectId: "activity-db71e",
    storageBucket: "activity-db71e.appspot.com",
    messagingSenderId: "1093964330268",
    appId: "1:1093964330268:web:95fdc51f9016c00c62fbea",
    databaseURL: "https://activity-db71e-default-rtdb.firebaseio.com",
  );
  
  // Configuração do Firebase para Android
  static const FirebaseOptions androidOptions = FirebaseOptions(
    apiKey: "AIzaSyDoYGxAYEwl6y6sQBA6sBpLcbCRWY16QPQ",
    appId: "1:1093964330268:android:db10e7fd388d66f162fbea",
    messagingSenderId: "1093964330268",
    projectId: "activity-db71e",
    storageBucket: "activity-db71e.appspot.com",
    databaseURL: "https://activity-db71e-default-rtdb.firebaseio.com",
  );
  
  // Configuração do Firebase para iOS
  static const FirebaseOptions iosOptions = FirebaseOptions(
    apiKey: "AIzaSyDoYGxAYEwl6y6sQBA6sBpLcbCRWY16QPQ",
    appId: "1:1093964330268:ios:ecc0aee3de194b1662fbea",
    messagingSenderId: "1093964330268",
    projectId: "activity-db71e",
    storageBucket: "activity-db71e.appspot.com",
    iosBundleId: "com.example.gestaoAcademica",
    databaseURL: "https://activity-db71e-default-rtdb.firebaseio.com",
  );

  // Método para obter as opções de configuração apropriadas com base na plataforma
  static FirebaseOptions get currentPlatformOptions {
    if (kIsWeb) {
      return webOptions;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidOptions;
      case TargetPlatform.iOS:
        return iosOptions;
      default:
        return webOptions; // Para outras plataformas, use a configuração web
    }
  }
}
