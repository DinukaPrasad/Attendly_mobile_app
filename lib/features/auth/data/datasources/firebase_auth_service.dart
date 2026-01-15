import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Firebase authentication service wrapper.
///
/// This class encapsulates all Firebase Auth and Google Sign-In operations.
/// It is used by [AuthRemoteDataSourceImpl] to perform authentication.
class FirebaseAuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Stream of authentication state changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Get ID token for current user
  Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return user.getIdToken();
  }

  // -------- Email/Password --------

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Register with email and password
  Future<UserCredential> registerWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  // -------- Google Sign-In --------

  /// Sign in with Google using the standard OAuth flow.
  ///
  /// Returns null if the user cancels the sign-in.
  /// Throws on other errors.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      developer.log('Starting Google Sign-In flow...', name: 'GoogleAuth');

      // Step 1: Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // User cancelled the sign-in
      if (googleUser == null) {
        developer.log('User cancelled Google Sign-In', name: 'GoogleAuth');
        return null;
      }

      developer.log(
        'Google account selected: ${googleUser.email}',
        name: 'GoogleAuth',
      );

      // Step 2: Get the authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Check for required tokens
      if (googleAuth.accessToken == null && googleAuth.idToken == null) {
        developer.log(
          'ERROR: Both accessToken and idToken are null',
          name: 'GoogleAuth',
        );
        throw FirebaseAuthException(
          code: 'missing-tokens',
          message: 'Failed to get authentication tokens from Google',
        );
      }

      developer.log(
        'Got tokens - accessToken: ${googleAuth.accessToken != null}, idToken: ${googleAuth.idToken != null}',
        name: 'GoogleAuth',
      );

      // Step 3: Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in to Firebase
      developer.log('Signing in to Firebase...', name: 'GoogleAuth');
      final userCredential = await _auth.signInWithCredential(credential);

      developer.log(
        'Firebase sign-in successful: ${userCredential.user?.email}',
        name: 'GoogleAuth',
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      developer.log(
        'FirebaseAuthException: ${e.code} - ${e.message}',
        name: 'GoogleAuth',
        error: e,
      );
      rethrow;
    } catch (e, stackTrace) {
      developer.log(
        'Google Sign-In error: $e',
        name: 'GoogleAuth',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // -------- Phone --------

  /// Send phone verification code
  Future<void> sendPhoneCode({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        // Android can auto-verify sometimes
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        onError(e.message ?? 'Phone verification failed');
      },
      codeSent: (verificationId, resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  /// Verify SMS code
  Future<UserCredential> verifySmsCode({
    required String verificationId,
    required String smsCode,
  }) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(credential);
  }

  // -------- Logout --------

  /// Sign out from all providers
  Future<void> logout() async {
    await _auth.signOut();

    // Disconnect revokes access and signs out
    try {
      await _googleSignIn.disconnect();
    } catch (_) {
      // If not connected, ignore
    }
  }
}
