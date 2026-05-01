import '../constants/app_strings.dart';

class Validators {
  Validators._();

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.nameRequired;
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.emailRequired;
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return AppStrings.emailInvalid;
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    if (value.length < 6) return AppStrings.passwordShort;
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final passwordError = password(value);
    if (passwordError != null) return passwordError;
    if (value != original) return AppStrings.passwordMismatch;
    return null;
  }
}
