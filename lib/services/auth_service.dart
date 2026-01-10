import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      // Use singleton instance for GoogleSignIn (7.x API)
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return user.getIdToken();
  }

  // -------- Email/Password --------
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  // -------- Google Sign-In (7.x API) --------
  Future<UserCredential?> signInWithGoogle() async {
    // Try lightweight (silent) auth first, fall back to interactive
    GoogleSignInAccount? googleUser = await _googleSignIn
        .attemptLightweightAuthentication();

    googleUser ??= await _googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;

    // Request access token via authorization client
    final clientAuth = await _googleSignIn.authorizationClient
        .authorizationForScopes(<String>['email', 'profile']);

    final credential = GoogleAuthProvider.credential(
      accessToken: clientAuth?.accessToken,
      idToken: googleAuth.idToken,
    );

    return _auth.signInWithCredential(credential);
  }

  // -------- Phone --------
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
