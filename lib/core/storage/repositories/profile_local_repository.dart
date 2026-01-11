import 'package:sqflite/sqflite.dart';

import '../collections/user_profile_collection.dart';
import '../collections/university_collection.dart';
import '../database_service.dart';

/// Repository for local user profile data operations.
///
/// This handles caching and retrieval of user profile data from SQLite.
/// No sensitive data should pass through this repository.
abstract class ProfileLocalRepository {
  Future<CachedUserProfile?> getProfile(String odUser);
  Future<CachedUserProfile?> getCurrentProfile();
  Future<void> upsertProfile(CachedUserProfile profile);
  Future<void> clearProfile();
  Future<CachedUniversity?> getUniversity(String odUniversity);
  Future<void> upsertUniversity(CachedUniversity university);
  Future<void> clearUniversity();
  Future<void> clearAll();
}

/// Implementation of [ProfileLocalRepository] using SQLite.
class ProfileLocalRepositoryImpl implements ProfileLocalRepository {
  Database get _db => DatabaseService.instance;

  @override
  Future<CachedUserProfile?> getProfile(String odUser) async {
    final results = await _db.query(
      'user_profiles',
      where: 'uid = ?',
      whereArgs: [odUser],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return CachedUserProfile.fromMap(results.first);
  }

  @override
  Future<CachedUserProfile?> getCurrentProfile() async {
    final results = await _db.query('user_profiles', limit: 1);

    if (results.isEmpty) return null;
    return CachedUserProfile.fromMap(results.first);
  }

  @override
  Future<void> upsertProfile(CachedUserProfile profile) async {
    await _db.insert(
      'user_profiles',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> clearProfile() async {
    await _db.delete('user_profiles');
  }

  @override
  Future<CachedUniversity?> getUniversity(String odUniversity) async {
    final results = await _db.query(
      'universities',
      where: 'uid = ?',
      whereArgs: [odUniversity],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return CachedUniversity.fromMap(results.first);
  }

  @override
  Future<void> upsertUniversity(CachedUniversity university) async {
    await _db.insert(
      'universities',
      university.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> clearUniversity() async {
    await _db.delete('universities');
  }

  @override
  Future<void> clearAll() async {
    await _db.delete('user_profiles');
    await _db.delete('universities');
  }
}
