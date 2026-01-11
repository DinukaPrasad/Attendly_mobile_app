import '../storage/database_service.dart';
import '../storage/repositories/profile_local_repository.dart';
import '../storage/repositories/notification_local_repository.dart';
import '../storage/secure_storage_service.dart';
import '../storage/collections/user_profile_collection.dart';
import '../storage/collections/university_collection.dart';

/// Manages user session data across secure storage and SQLite.
///
/// Provides centralized methods for login/logout that properly
/// handle both token storage and cached data.
class SessionManager {
  final SecureStorageService _secureStorage;
  final ProfileLocalRepository _profileRepo;
  final NotificationLocalRepository _notificationRepo;

  SessionManager({
    required SecureStorageService secureStorage,
    required ProfileLocalRepository profileRepo,
    required NotificationLocalRepository notificationRepo,
  }) : _secureStorage = secureStorage,
       _profileRepo = profileRepo,
       _notificationRepo = notificationRepo;

  /// Saves session tokens and user ID after successful login.
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String odUser,
  }) async {
    await Future.wait([
      _secureStorage.saveAccessToken(accessToken),
      _secureStorage.saveRefreshToken(refreshToken),
      _secureStorage.saveUserId(odUser),
    ]);
  }

  /// Caches user profile data for offline access.
  Future<void> cacheUserProfile(CachedUserProfile profile) async {
    await _profileRepo.upsertProfile(profile);
  }

  /// Caches university data for offline access.
  Future<void> cacheUniversity(CachedUniversity university) async {
    await _profileRepo.upsertUniversity(university);
  }

  /// Retrieves the cached user profile.
  Future<CachedUserProfile?> getCachedProfile() async {
    return _profileRepo.getCurrentProfile();
  }

  /// Retrieves the current access token.
  Future<String?> getAccessToken() async {
    return _secureStorage.getAccessToken();
  }

  /// Retrieves the current refresh token.
  Future<String?> getRefreshToken() async {
    return _secureStorage.getRefreshToken();
  }

  /// Retrieves the current user ID.
  Future<String?> getUserId() async {
    return _secureStorage.getUserId();
  }

  /// Checks if there is an active session.
  Future<bool> hasActiveSession() async {
    final token = await _secureStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Updates tokens (e.g., after refresh).
  Future<void> updateTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _secureStorage.saveAccessToken(accessToken);
    if (refreshToken != null) {
      await _secureStorage.saveRefreshToken(refreshToken);
    }
  }

  /// Clears all session data and cached user data on logout.
  ///
  /// This safely clears:
  /// - All tokens from secure storage
  /// - User profile from SQLite
  /// - University data from SQLite
  /// - Notifications from SQLite
  Future<void> logout() async {
    try {
      // Clear secure storage first (most important)
      await _secureStorage.clearAll();

      // Clear cached data (non-critical, wrapped in try-catch)
      try {
        await _profileRepo.clearAll();
        await _notificationRepo.clearAll();
      } catch (_) {
        // Log but don't fail logout if cache clear fails
      }
    } catch (e) {
      // Ensure we at least try to clear database even if secure storage fails
      try {
        await DatabaseService.clearUserData();
      } catch (_) {}
      rethrow;
    }
  }

  /// Checks if biometric login is enabled.
  Future<bool> isBiometricEnabled() async {
    return _secureStorage.isBiometricEnabled();
  }

  /// Sets the biometric login preference.
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.setBiometricEnabled(enabled);
  }
}
