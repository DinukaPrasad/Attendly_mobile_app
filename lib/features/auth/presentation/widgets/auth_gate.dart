import 'package:flutter/material.dart';

import '../../injection.dart';
import '../pages/login_screen.dart';

/// Widget that listens to Firebase auth state and routes accordingly.
///
/// - If user is signed in → shows [child] (the main app screen)
/// - If user is signed out → shows [LoginScreen]
///
/// This should be used as the home widget in MaterialApp to ensure
/// the correct screen is shown on app startup based on auth state.
class AuthGate extends StatelessWidget {
  /// The widget to show when user is authenticated.
  final Widget child;

  const AuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthDI.firebaseAuthService.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while waiting for auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check if user is signed in
        final user = snapshot.data;

        // Clear any SnackBars queued from previous screen (prevents login errors showing on QR screen)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final messenger = ScaffoldMessenger.maybeOf(context);
          messenger?.clearSnackBars();
          messenger?.hideCurrentSnackBar();
        });

        if (user != null) {
          // User is signed in - show the main app
          return child;
        } else {
          // User is not signed in - show login
          return const LoginScreen();
        }
      },
    );
  }
}
