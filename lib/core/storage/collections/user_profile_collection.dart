/// Model for caching user profile data in SQLite.
///
/// This stores non-sensitive profile information for offline access.
/// Sensitive data like tokens should NEVER be stored here.
class CachedUserProfile {
  final int? id;
  final String odUser;
  final String firstName;
  final String lastName;
  final String? title;
  final String email;
  final String? phone;
  final String? gender;
  final int? age;
  final String? universityId;
  final DateTime updatedAt;

  const CachedUserProfile({
    this.id,
    required this.odUser,
    required this.firstName,
    required this.lastName,
    this.title,
    required this.email,
    this.phone,
    this.gender,
    this.age,
    this.universityId,
    required this.updatedAt,
  });

  /// Creates from database map.
  factory CachedUserProfile.fromMap(Map<String, dynamic> map) {
    return CachedUserProfile(
      id: map['id'] as int?,
      odUser: map['uid'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      title: map['title'] as String?,
      email: map['email'] as String,
      phone: map['phone'] as String?,
      gender: map['gender'] as String?,
      age: map['age'] as int?,
      universityId: map['university_id'] as String?,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Converts to database map.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'uid': odUser,
      'first_name': firstName,
      'last_name': lastName,
      'title': title,
      'email': email,
      'phone': phone,
      'gender': gender,
      'age': age,
      'university_id': universityId,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Full display name.
  String get fullName {
    final parts = [if (title != null) title, firstName, lastName];
    return parts.join(' ');
  }

  /// Display name without title.
  String get displayName => '$firstName $lastName';

  /// Creates a copy with updated values.
  CachedUserProfile copyWith({
    int? id,
    String? odUser,
    String? firstName,
    String? lastName,
    String? title,
    String? email,
    String? phone,
    String? gender,
    int? age,
    String? universityId,
    DateTime? updatedAt,
  }) {
    return CachedUserProfile(
      id: id ?? this.id,
      odUser: odUser ?? this.odUser,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      title: title ?? this.title,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      universityId: universityId ?? this.universityId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
