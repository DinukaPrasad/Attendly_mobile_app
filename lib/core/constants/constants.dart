/// API and network constants
class ApiConstants {
  ApiConstants._();

  // Base URLs
  static const String baseUrl =
      'http://10.191.77.198:8080/api/'; // Replace with your API
  // static const String apiVersion = '/v1';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}

/// Storage keys for secure storage
class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
}

/// Validation constants
class ValidationConstants {
  ValidationConstants._();

  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int maxEmailLength = 254;

  /// Email regex pattern
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Phone number regex (international format)
  static final RegExp phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
}

/// App-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Attendly';
  static const String appVersion = '1.0.0';

  // Feature flags
  static const bool enableBiometricAuth = true;
  static const bool enableGoogleSignIn = true;
  static const bool enablePhoneSignIn = true;
}

/// Route constants (kept for backwards compatibility)
/// Prefer using AppRoutes from core/routing/app_router.dart
class RouteConstants {
  RouteConstants._();
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String scan = '/scan';
  static const String confirm = '/confirm';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String permissions = '/permissions';
}
