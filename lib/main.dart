import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';
import 'core/di/injection_container.dart';
import 'core/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first
  await _initializeFirebase();

  // Initialize dependency injection
  await initDependencies();

  // Load theme preference before showing the app
  await sl<ThemeController>().loadThemeMode();

  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  if (kIsWeb) {
    const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_APP_ID');
    const messagingSenderId =
        String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');

    final hasRequiredOptions = apiKey.isNotEmpty &&
        appId.isNotEmpty &&
        messagingSenderId.isNotEmpty &&
        projectId.isNotEmpty;

    if (!hasRequiredOptions) {
      debugPrint(
        'Skipping Firebase initialization on web: missing FirebaseOptions. '
        'Provide FIREBASE_API_KEY, FIREBASE_APP_ID, FIREBASE_MESSAGING_SENDER_ID, '
        'and FIREBASE_PROJECT_ID via --dart-define to enable Firebase.',
      );
      return;
    }

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
        storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
        measurementId: String.fromEnvironment('FIREBASE_MEASUREMENT_ID'),
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
}
