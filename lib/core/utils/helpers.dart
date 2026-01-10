/// Formats a DateTime to 'YYYY-MM-DD' string
String formatDate(DateTime date) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
}

/// Formats a DateTime to 'HH:mm' string
String formatTime(DateTime time) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return '${twoDigits(time.hour)}:${twoDigits(time.minute)}';
}

/// Formats a DateTime to 'YYYY-MM-DD HH:mm' string
String formatDateTime(DateTime dateTime) {
  return '${formatDate(dateTime)} ${formatTime(dateTime)}';
}
