import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Status result for permission checks
enum PermissionCheckStatus {
  /// Permission granted
  granted,

  /// Permission denied (can be requested again)
  denied,

  /// Permission permanently denied (must go to settings)
  permanentlyDenied,

  /// Service is disabled (e.g., location services off)
  serviceDisabled,

  /// Permission not supported on this platform
  notSupported,
}

/// Storage key for permission gate completion
const String kPermissionsGateDone = 'permissions_gate_done';

/// Manages runtime permissions for the app
///
/// Provides methods to check and request:
/// - Network connectivity
/// - Location permission and services
/// - Notification permission
class PermissionManager {
  final SharedPreferences _prefs;
  final Connectivity _connectivity;

  PermissionManager({
    required SharedPreferences prefs,
    Connectivity? connectivity,
  }) : _prefs = prefs,
       _connectivity = connectivity ?? Connectivity();

  // ============================================
  // Permission Gate Persistence
  // ============================================

  /// Check if the permission gate has been completed
  bool get isPermissionGateDone =>
      _prefs.getBool(kPermissionsGateDone) ?? false;

  /// Mark the permission gate as completed
  Future<bool> markPermissionGateDone() async {
    return _prefs.setBool(kPermissionsGateDone, true);
  }

  /// Reset the permission gate (for testing or re-onboarding)
  Future<bool> resetPermissionGate() async {
    return _prefs.remove(kPermissionsGateDone);
  }

  // ============================================
  // Network Connectivity
  // ============================================

  /// Check current network connectivity status
  ///
  /// Returns [PermissionCheckStatus.granted] if connected to any network,
  /// [PermissionCheckStatus.serviceDisabled] if no network available
  Future<PermissionCheckStatus> checkNetwork() async {
    try {
      final results = await _connectivity.checkConnectivity();

      // Check if connected to any network
      final hasConnection = results.any(
        (result) =>
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.ethernet,
      );

      return hasConnection
          ? PermissionCheckStatus.granted
          : PermissionCheckStatus.serviceDisabled;
    } catch (e) {
      return PermissionCheckStatus.serviceDisabled;
    }
  }

  /// Stream of network connectivity changes
  Stream<bool> get networkStatusStream {
    return _connectivity.onConnectivityChanged.map((results) {
      return results.any(
        (result) =>
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.ethernet,
      );
    });
  }

  // ============================================
  // Location Permission
  // ============================================

  /// Check current location permission and service status
  ///
  /// Returns appropriate [PermissionCheckStatus] based on:
  /// - Whether location services are enabled
  /// - Current permission state (granted/denied/permanentlyDenied)
  Future<PermissionCheckStatus> checkLocationStatus() async {
    try {
      // First check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return PermissionCheckStatus.serviceDisabled;
      }

      // Check permission status
      final permission = await Geolocator.checkPermission();

      switch (permission) {
        case LocationPermission.always:
        case LocationPermission.whileInUse:
          return PermissionCheckStatus.granted;
        case LocationPermission.denied:
          return PermissionCheckStatus.denied;
        case LocationPermission.deniedForever:
          return PermissionCheckStatus.permanentlyDenied;
        case LocationPermission.unableToDetermine:
          return PermissionCheckStatus.denied;
      }
    } catch (e) {
      return PermissionCheckStatus.notSupported;
    }
  }

  /// Request location permission from the user
  ///
  /// Returns the resulting [PermissionCheckStatus] after the request
  Future<PermissionCheckStatus> requestLocationPermission() async {
    try {
      // Check if service is enabled first
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Try to open location settings
        await Geolocator.openLocationSettings();
        return PermissionCheckStatus.serviceDisabled;
      }

      // Check current permission
      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        // Open app settings so user can manually enable
        await openAppSettings();
        return PermissionCheckStatus.permanentlyDenied;
      }

      switch (permission) {
        case LocationPermission.always:
        case LocationPermission.whileInUse:
          return PermissionCheckStatus.granted;
        case LocationPermission.denied:
          return PermissionCheckStatus.denied;
        case LocationPermission.deniedForever:
          return PermissionCheckStatus.permanentlyDenied;
        case LocationPermission.unableToDetermine:
          return PermissionCheckStatus.denied;
      }
    } catch (e) {
      return PermissionCheckStatus.notSupported;
    }
  }

  /// Open device location settings
  Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  // ============================================
  // Notification Permission
  // ============================================

  /// Check current notification permission status
  ///
  /// Returns appropriate [PermissionCheckStatus]
  Future<PermissionCheckStatus> checkNotificationStatus() async {
    try {
      // Notifications only require explicit permission on iOS and Android 13+
      if (!Platform.isIOS && !Platform.isAndroid) {
        return PermissionCheckStatus.notSupported;
      }

      final status = await Permission.notification.status;

      if (status.isGranted) {
        return PermissionCheckStatus.granted;
      } else if (status.isDenied) {
        return PermissionCheckStatus.denied;
      } else if (status.isPermanentlyDenied) {
        return PermissionCheckStatus.permanentlyDenied;
      } else {
        return PermissionCheckStatus.denied;
      }
    } catch (e) {
      return PermissionCheckStatus.notSupported;
    }
  }

  /// Request notification permission from the user
  ///
  /// Returns the resulting [PermissionCheckStatus] after the request
  Future<PermissionCheckStatus> requestNotificationPermission() async {
    try {
      if (!Platform.isIOS && !Platform.isAndroid) {
        return PermissionCheckStatus.notSupported;
      }

      // Check current status first
      var status = await Permission.notification.status;

      if (status.isPermanentlyDenied) {
        // Open app settings
        await openAppSettings();
        return PermissionCheckStatus.permanentlyDenied;
      }

      if (!status.isGranted) {
        // Request permission
        status = await Permission.notification.request();
      }

      if (status.isGranted) {
        return PermissionCheckStatus.granted;
      } else if (status.isPermanentlyDenied) {
        return PermissionCheckStatus.permanentlyDenied;
      } else {
        return PermissionCheckStatus.denied;
      }
    } catch (e) {
      return PermissionCheckStatus.notSupported;
    }
  }

  // ============================================
  // Utility Methods
  // ============================================

  /// Check all permissions at once
  ///
  /// Returns a map of permission type to status
  Future<Map<String, PermissionCheckStatus>> checkAllPermissions() async {
    final results = await Future.wait([
      checkNetwork(),
      checkLocationStatus(),
      checkNotificationStatus(),
    ]);

    return {
      'network': results[0],
      'location': results[1],
      'notification': results[2],
    };
  }

  /// Check if all required permissions are granted
  Future<bool> areAllPermissionsGranted() async {
    final statuses = await checkAllPermissions();
    return statuses.values.every(
      (status) =>
          status == PermissionCheckStatus.granted ||
          status == PermissionCheckStatus.notSupported,
    );
  }
}
