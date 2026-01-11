import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Service for managing SQLite database instance.
///
/// Opens database once at app startup and provides access to the single instance.
/// Use this for all non-sensitive cached data.
class DatabaseService {
  static Database? _instance;
  static const String _dbName = 'attendly_cache.db';
  static const int _dbVersion = 1;

  DatabaseService._();

  /// Gets the database instance. Must call [initialize] first.
  static Database get instance {
    if (_instance == null) {
      throw StateError(
        'Database not initialized. Call DatabaseService.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Whether database has been initialized.
  static bool get isInitialized => _instance != null;

  /// Initializes SQLite database.
  ///
  /// Call this once at app startup before using any local repositories.
  static Future<void> initialize() async {
    if (_instance != null) return;

    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, _dbName);

    _instance = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // User profile table
    await db.execute('''
      CREATE TABLE user_profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT UNIQUE NOT NULL,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        title TEXT,
        email TEXT NOT NULL,
        phone TEXT,
        gender TEXT,
        age INTEGER,
        university_id TEXT,
        updated_at TEXT NOT NULL
      )
    ''');

    // University table
    await db.execute('''
      CREATE TABLE universities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        logo_url TEXT,
        campus_name TEXT,
        campus_address TEXT,
        city TEXT,
        country TEXT,
        updated_at TEXT NOT NULL
      )
    ''');

    // Notifications table
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT UNIQUE NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0,
        type TEXT,
        payload TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Create indexes
    await db.execute(
      'CREATE INDEX idx_notifications_is_read ON notifications(is_read)',
    );
    await db.execute(
      'CREATE INDEX idx_notifications_created_at ON notifications(created_at)',
    );
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Handle migrations here as needed
  }

  /// Closes the database instance.
  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }

  /// Clears all user-related data from database.
  ///
  /// Call this on logout to remove cached user data.
  static Future<void> clearUserData() async {
    if (_instance == null) return;

    await _instance!.delete('user_profiles');
    await _instance!.delete('universities');
    await _instance!.delete('notifications');
  }
}
