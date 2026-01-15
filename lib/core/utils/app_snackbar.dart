import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

/// Global SnackBar utility using awesome_snackbar_content
///
/// Usage:
/// ```dart
/// AppSnackbar.showSuccess(context, title: 'Success!', message: 'Done!');
/// AppSnackbar.showError(context, title: 'Error!', message: 'Failed!');
/// AppSnackbar.showWarning(context, title: 'Warning!', message: 'Be careful!');
/// AppSnackbar.showInfo(context, title: 'Info', message: 'FYI...');
/// ```
class AppSnackbar {
  AppSnackbar._(); // Private constructor to prevent instantiation

  /// Show success snackbar (green with checkmark)
  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(context, title: title, message: message, type: ContentType.success);
  }

  /// Show error/failure snackbar (red with X)
  static void showError(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(context, title: title, message: message, type: ContentType.failure);
  }

  /// Show warning snackbar (orange with warning icon)
  static void showWarning(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(context, title: title, message: message, type: ContentType.warning);
  }

  /// Show info/help snackbar (blue with info icon)
  static void showInfo(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(context, title: title, message: message, type: ContentType.help);
  }

  /// Internal method to display snackbar
  static void _show(
    BuildContext context, {
    required String title,
    required String message,
    required ContentType type,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          width: screenWidth,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: type,
          ),
        ),
      );
  }
}
