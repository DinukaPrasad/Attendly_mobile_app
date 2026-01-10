import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../services/auth_service.dart';
import '../models/auth_user_model.dart';

/// Remote data source for authentication operations.
///
/// This wraps the existing [AuthService] (which uses Firebase Auth and Google Sign-In)
/// and provides a clean interface for the repository layer.
///
/// All methods throw [AppException] subclasses on failure.
abstract class AuthRemoteDataSource {
  /// Signs in with email and password.
  /// Throws [AuthException] on failure.
  Future<AuthUserModel> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Signs in with Google OAuth.
  /// Throws [AuthException] on failure or if cancelled.
  Future<AuthUserModel> signInWithGoogle();

  /// Registers a new user with email and password.
  /// Throws [AuthException] on failure.
  Future<AuthUserModel> registerWithEmailPassword({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  /// Throws [AuthException] on failure.
  Future<void> signOut();

  /// Gets the current user model, or null if not signed in.
  AuthUserModel? get currentUser;

  /// Stream of auth state changes as user models.
  Stream<AuthUserModel?> authStateChanges();
}

/// Implementation of [AuthRemoteDataSource] using [AuthService].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthService _authService;

  AuthRemoteDataSourceImpl(this._authService);

  @override
  Future<AuthUserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.signInWithEmailPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException(
          message: 'Sign in failed - no user returned',
          code: 'no-user',
        );
      }
      return AuthUserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Authentication failed',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'An unexpected error occurred',
        originalError: e,
      );
    }
  }

  @override
  Future<AuthUserModel> signInWithGoogle() async {
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential == null) {
        throw const AuthException(
          message: 'Google sign-in was cancelled',
          code: 'cancelled',
        );
      }
      final user = credential.user;
      if (user == null) {
        throw const AuthException(
          message: 'Sign in failed - no user returned',
          code: 'no-user',
        );
      }
      return AuthUserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Google sign-in failed',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: 'Google sign-in failed', originalError: e);
    }
  }

  @override
  Future<AuthUserModel> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.registerWithEmailPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException(
          message: 'Registration failed - no user returned',
          code: 'no-user',
        );
      }
      return AuthUserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Registration failed',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'An unexpected error occurred',
        originalError: e,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authService.logout();
    } catch (e) {
      throw AuthException(message: 'Sign out failed', originalError: e);
    }
  }

  @override
  AuthUserModel? get currentUser {
    final user = _authService.currentUser;
    if (user == null) return null;
    return AuthUserModel.fromFirebaseUser(user);
  }

  @override
  Stream<AuthUserModel?> authStateChanges() {
    return _authService.authStateChanges().map((user) {
      if (user == null) return null;
      return AuthUserModel.fromFirebaseUser(user);
    });
  }
}
