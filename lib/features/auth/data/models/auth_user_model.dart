import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../domain/entities/auth_user.dart';

/// Data model for authenticated user.
///
/// This extends the domain entity to add data layer specific methods
/// like mapping from Firebase User.
class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    super.email,
    super.displayName,
    super.photoUrl,
    super.isEmailVerified,
    super.phoneNumber,
  });

  /// Create from Firebase User
  factory AuthUserModel.fromFirebaseUser(firebase.User user) {
    return AuthUserModel(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
    );
  }

  /// Create from JSON (for API responses)
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isEmailVerified': isEmailVerified,
      'phoneNumber': phoneNumber,
    };
  }

  /// Convert to domain entity
  AuthUser toEntity() => AuthUser(
    id: id,
    email: email,
    displayName: displayName,
    photoUrl: photoUrl,
    isEmailVerified: isEmailVerified,
    phoneNumber: phoneNumber,
  );
}
