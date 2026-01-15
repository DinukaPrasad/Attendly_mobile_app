/// Mock data for development and testing purposes.
library;

/// Weekly attendance data for charts
class MockChartData {
  MockChartData._();

  /// Weekly attendance data (day index -> attendance percentage)
  static const List<double> weeklyAttendance = [85, 92, 78, 95, 88, 72, 90];

  /// Day labels for the week
  static const List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  /// Attendance stats
  static const int totalClasses = 42;
  static const int attendedClasses = 38;
  static const int missedClasses = 4;

  /// Monthly attendance breakdown
  static const Map<String, double> monthlyBreakdown = {
    'Present': 85.0,
    'Excused': 10.0,
    'Absent': 5.0,
  };

  /// Course-wise attendance
  static const List<Map<String, dynamic>> courseAttendance = [
    {'name': 'Data Structures', 'percentage': 95, 'classes': 12},
    {'name': 'Database Systems', 'percentage': 88, 'classes': 10},
    {'name': 'Software Engineering', 'percentage': 82, 'classes': 11},
    {'name': 'Computer Networks', 'percentage': 78, 'classes': 9},
  ];
}

/// Mock notification count
class MockNotificationData {
  MockNotificationData._();

  static int unreadCount = 3;
}
