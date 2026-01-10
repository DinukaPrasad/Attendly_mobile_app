import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of [AuthRepository].
///
/// This connects the domain layer to the data layer by implementing
/// the abstract repository interface and delegating to the data source.
///
/// All exceptions from the data source are caught and mapped to [Failure]s.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<AuthUser>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      return Result.success(userModel.toEntity());
    } on AuthException catch (e) {
      return Result.failure(_mapAuthException(e));
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Result<AuthUser>> signInWithGoogle() async {
    try {
      final userModel = await _remoteDataSource.signInWithGoogle();
      return Result.success(userModel.toEntity());
    } on AuthException catch (e) {
      if (e.code == 'cancelled') {
        return Result.failure(AuthFailure.cancelled());
      }
      return Result.failure(_mapAuthException(e));
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Result<AuthUser>> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.registerWithEmailPassword(
        email: email,
        password: password,
      );
      return Result.success(userModel.toEntity());
    } on AuthException catch (e) {
      return Result.failure(_mapAuthException(e));
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return Result.success(null);
    } on AuthException catch (e) {
      return Result.failure(_mapAuthException(e));
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  AuthUser? get currentUser => _remoteDataSource.currentUser?.toEntity();

  @override
  Stream<AuthUser?> authStateChanges() {
    return _remoteDataSource.authStateChanges().map(
      (model) => model?.toEntity(),
    );
  }

  @override
  bool get isSignedIn => currentUser != null;

  /// Maps AuthException to appropriate Failure type
  Failure _mapAuthException(AuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthFailure.userNotFound();
      case 'wrong-password':
        return AuthFailure.wrongPassword();
      case 'invalid-credential':
        return AuthFailure.invalidCredentials();
      case 'invalid-email':
        return const ValidationFailure(
          message: 'Invalid email address',
          code: 'invalid-email',
        );
      case 'user-disabled':
        return AuthFailure.userDisabled();
      case 'too-many-requests':
        return AuthFailure.tooManyRequests();
      case 'email-already-in-use':
        return AuthFailure.emailAlreadyInUse();
      case 'weak-password':
        return AuthFailure.weakPassword();
      case 'operation-not-allowed':
        return AuthFailure.operationNotAllowed();
      case 'network-request-failed':
        return const NetworkFailure();
      case 'cancelled':
        return AuthFailure.cancelled();
      default:
        return AuthFailure(message: e.message, code: e.code);
    }
  }
}
