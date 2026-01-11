/// Model for caching university data in SQLite.
///
/// This stores university information for offline access.
class CachedUniversity {
  final int? id;
  final String odUniversity;
  final String name;
  final String? logoUrl;
  final String? campusName;
  final String? campusAddress;
  final String? city;
  final String? country;
  final DateTime updatedAt;

  const CachedUniversity({
    this.id,
    required this.odUniversity,
    required this.name,
    this.logoUrl,
    this.campusName,
    this.campusAddress,
    this.city,
    this.country,
    required this.updatedAt,
  });

  /// Creates from database map.
  factory CachedUniversity.fromMap(Map<String, dynamic> map) {
    return CachedUniversity(
      id: map['id'] as int?,
      odUniversity: map['uid'] as String,
      name: map['name'] as String,
      logoUrl: map['logo_url'] as String?,
      campusName: map['campus_name'] as String?,
      campusAddress: map['campus_address'] as String?,
      city: map['city'] as String?,
      country: map['country'] as String?,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Converts to database map.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'uid': odUniversity,
      'name': name,
      'logo_url': logoUrl,
      'campus_name': campusName,
      'campus_address': campusAddress,
      'city': city,
      'country': country,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Full campus location string.
  String get fullLocation {
    final parts = [
      if (campusName != null) campusName,
      if (city != null) city,
      if (country != null) country,
    ];
    return parts.join(', ');
  }

  /// Creates a copy with updated values.
  CachedUniversity copyWith({
    int? id,
    String? odUniversity,
    String? name,
    String? logoUrl,
    String? campusName,
    String? campusAddress,
    String? city,
    String? country,
    DateTime? updatedAt,
  }) {
    return CachedUniversity(
      id: id ?? this.id,
      odUniversity: odUniversity ?? this.odUniversity,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      campusName: campusName ?? this.campusName,
      campusAddress: campusAddress ?? this.campusAddress,
      city: city ?? this.city,
      country: country ?? this.country,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
