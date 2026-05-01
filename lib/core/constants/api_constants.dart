import 'package:flutter/foundation.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.58.45.198:8080';
    }
    return 'http://localhost:8080';
  }

  static const Duration timeout = Duration(seconds: 30);

  // Endpoints
  static const String health = '/api/health';
  static const String login = '/api/auth/login';
  static const String register = '/api/users';

  // Attendance endpoints
  static const String attendance = '/api/attendance';
  static const String attendanceByUser = '/api/attendance/user';
  static const String attendanceByProgramme = '/api/attendance/programme';

  // Session endpoints
  static const String sessions = '/api/sessions';

  // Notification endpoints
  static const String notifications = '/api/notifications';
  static const String notificationsRecipient = '/api/notifications/recipient';
  static const String notificationsRead = '/api/notifications';
}
