import 'package:local_auth/local_auth.dart';

import '../errors/failures.dart';
import '../utils/result.dart';

/// Biometric authentication failure
class BiometricFailure extends Failure {
  const BiometricFailure({required super.message, super.code});

  factory BiometricFailure.notAvailable() => const BiometricFailure(
    message: 'Biometric authentication is not available on this device',
    code: 'not-available',
  );

  factory BiometricFailure.notEnrolled() => const BiometricFailure(
    message:
        'No biometrics enrolled. Please set up fingerprint or face ID in your device settings',
    code: 'not-enrolled',
  );

  factory BiometricFailure.cancelled() => const BiometricFailure(
    message: 'Authentication was cancelled',
    code: 'cancelled',
  );

  factory BiometricFailure.failed() => const BiometricFailure(
    message: 'Authentication failed. Please try again',
    code: 'failed',
  );

  factory BiometricFailure.lockedOut() => const BiometricFailure(
    message: 'Too many failed attempts. Please try again later',
    code: 'locked-out',
  );
}

/// Abstract interface for biometric authentication service.
///
/// This abstraction allows for easy testing and follows Clean Architecture
/// by keeping platform-specific code out of the domain/presentation layers.
abstract class BiometricAuthService {
  /// Checks if biometric authentication is available on this device.
  /// Returns true if the device has biometric hardware and at least one
  /// biometric is enrolled.
  Future<bool> isAvailable();

  /// Prompts the user to authenticate using biometrics.
  ///
  /// [reason] - The message to display to the user explaining why
  /// authentication is needed.
  ///
  /// Returns [Result.success(true)] if authentication succeeded.
  /// Returns [Result.failure] with appropriate [BiometricFailure] on error.
  Future<Result<bool>> authenticate({required String reason});
}

/// Implementation of [BiometricAuthService] using the local_auth package.
class BiometricAuthServiceImpl implements BiometricAuthService {
  final LocalAuthentication _localAuth;

  BiometricAuthServiceImpl({LocalAuthentication? localAuth})
    : _localAuth = localAuth ?? LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    try {
      // Check if device supports biometrics
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        return false;
      }

      // Check if any biometrics are enrolled
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Result<bool>> authenticate({required String reason}) async {
    try {
      // First check availability
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        return Result.failure(BiometricFailure.notAvailable());
      }

      // Check if biometrics are enrolled
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return Result.failure(BiometricFailure.notEnrolled());
      }

      // Attempt authentication
      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allow PIN/pattern as fallback
        ),
      );

      if (authenticated) {
        return const Result.success(true);
      } else {
        return Result.failure(BiometricFailure.cancelled());
      }
    } catch (e) {
      // Handle specific local_auth exceptions
      final errorString = e.toString().toLowerCase();

      if (errorString.contains('locked') || errorString.contains('too many')) {
        return Result.failure(BiometricFailure.lockedOut());
      }
      if (errorString.contains('cancel')) {
        return Result.failure(BiometricFailure.cancelled());
      }
      if (errorString.contains('not available') ||
          errorString.contains('not enrolled')) {
        return Result.failure(BiometricFailure.notAvailable());
      }

      return Result.failure(BiometricFailure.failed());
    }
  }
}
