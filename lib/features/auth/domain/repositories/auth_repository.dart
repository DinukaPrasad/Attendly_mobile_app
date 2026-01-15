import '../../../../core/utils/result.dart';
import '../entities/auth_user.dart';

/// Abstract repository interface for authentication operations.
///
/// This defines the contract that the data layer must implement.
/// The domain layer (use cases) depends only on this abstraction,
/// not on concrete implementations.
///
/// NOTE: This is pure Dart - no Flutter or Firebase imports allowed.
abstract class AuthRepository {
  /// Signs in a user with email and password.
  ///
  /// Returns [Result.success] with [AuthUser] on success.
  /// Returns [Result.failure] with appropriate [Failure] on error.
  Future<Result<AuthUser>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Signs in a user with Google OAuth.
  ///
  /// Returns [Result.success] with [AuthUser] on success.
  /// Returns [Result.failure] if cancelled or on error.
  Future<Result<AuthUser>> signInWithGoogle();

  /// Registers a new user with email and password.
  Future<Result<AuthUser>> registerWithEmailPassword({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  Future<Result<void>> signOut();

  /// Returns the currently authenticated user, or null if not signed in.
  AuthUser? get currentUser;

  /// Stream of authentication state changes.
  Stream<AuthUser?> authStateChanges();

  /// Check if a user is currently signed in.
  bool get isSignedIn;
}
