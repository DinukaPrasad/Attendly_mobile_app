import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user.
///
/// This is a pure Dart class with no Flutter/Firebase dependencies.
/// It contains only the data we need in the domain/presentation layers.
class AuthUser extends Equatable {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isEmailVerified;
  final String? phoneNumber;

  const AuthUser({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.isEmailVerified = false,
    this.phoneNumber,
  });

  /// Check if user has a display name
  bool get hasDisplayName => displayName != null && displayName!.isNotEmpty;

  /// Check if user has a photo
  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// Get initials for avatar placeholder
  String get initials {
    if (hasDisplayName) {
      final parts = displayName!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    if (email != null && email!.isNotEmpty) {
      return email![0].toUpperCase();
    }
    return '?';
  }

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoUrl,
    isEmailVerified,
    phoneNumber,
  ];
}
