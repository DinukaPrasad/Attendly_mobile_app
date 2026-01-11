import 'package:sqflite/sqflite.dart';

import '../collections/notification_collection.dart';
import '../database_service.dart';

/// Repository for local notification data operations.
///
/// This handles caching and retrieval of notifications from SQLite.
abstract class NotificationLocalRepository {
  Future<List<CachedNotification>> getAllNotifications();
  Future<List<CachedNotification>> getUnreadNotifications();
  Future<CachedNotification?> getNotification(String odNotification);
  Future<void> upsertNotification(CachedNotification notification);
  Future<void> upsertNotifications(List<CachedNotification> notifications);
  Future<void> markAsRead(String odNotification);
  Future<void> markAllAsRead();
  Future<int> getUnreadCount();
  Future<void> deleteNotification(String odNotification);
  Future<void> clearAll();
}

/// Implementation of [NotificationLocalRepository] using SQLite.
class NotificationLocalRepositoryImpl implements NotificationLocalRepository {
  Database get _db => DatabaseService.instance;

  @override
  Future<List<CachedNotification>> getAllNotifications() async {
    final results = await _db.query(
      'notifications',
      orderBy: 'created_at DESC',
    );

    return results.map(CachedNotification.fromMap).toList();
  }

  @override
  Future<List<CachedNotification>> getUnreadNotifications() async {
    final results = await _db.query(
      'notifications',
      where: 'is_read = ?',
      whereArgs: [0],
      orderBy: 'created_at DESC',
    );

    return results.map(CachedNotification.fromMap).toList();
  }

  @override
  Future<CachedNotification?> getNotification(String odNotification) async {
    final results = await _db.query(
      'notifications',
      where: 'uid = ?',
      whereArgs: [odNotification],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return CachedNotification.fromMap(results.first);
  }

  @override
  Future<void> upsertNotification(CachedNotification notification) async {
    await _db.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> upsertNotifications(
    List<CachedNotification> notifications,
  ) async {
    final batch = _db.batch();
    for (final notification in notifications) {
      batch.insert(
        'notifications',
        notification.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> markAsRead(String odNotification) async {
    await _db.update(
      'notifications',
      {'is_read': 1},
      where: 'uid = ?',
      whereArgs: [odNotification],
    );
  }

  @override
  Future<void> markAllAsRead() async {
    await _db.update(
      'notifications',
      {'is_read': 1},
      where: 'is_read = ?',
      whereArgs: [0],
    );
  }

  @override
  Future<int> getUnreadCount() async {
    final result = await _db.rawQuery(
      'SELECT COUNT(*) as count FROM notifications WHERE is_read = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<void> deleteNotification(String odNotification) async {
    await _db.delete(
      'notifications',
      where: 'uid = ?',
      whereArgs: [odNotification],
    );
  }

  @override
  Future<void> clearAll() async {
    await _db.delete('notifications');
  }
}
