/// Model for caching notifications in SQLite.
///
/// This stores notifications for offline access and quick loading.
class CachedNotification {
  final int? id;
  final String odNotification;
  final String title;
  final String body;
  final bool isRead;
  final String? type;
  final String? payload;
  final DateTime createdAt;

  const CachedNotification({
    this.id,
    required this.odNotification,
    required this.title,
    required this.body,
    this.isRead = false,
    this.type,
    this.payload,
    required this.createdAt,
  });

  /// Creates from database map.
  factory CachedNotification.fromMap(Map<String, dynamic> map) {
    return CachedNotification(
      id: map['id'] as int?,
      odNotification: map['uid'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      isRead: (map['is_read'] as int) == 1,
      type: map['type'] as String?,
      payload: map['payload'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Converts to database map.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'uid': odNotification,
      'title': title,
      'body': body,
      'is_read': isRead ? 1 : 0,
      'type': type,
      'payload': payload,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Creates a copy with updated values.
  CachedNotification copyWith({
    int? id,
    String? odNotification,
    String? title,
    String? body,
    bool? isRead,
    String? type,
    String? payload,
    DateTime? createdAt,
  }) {
    return CachedNotification(
      id: id ?? this.id,
      odNotification: odNotification ?? this.odNotification,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
