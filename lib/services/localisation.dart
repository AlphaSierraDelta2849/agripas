import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionService {
  /// Ensures permissions for location and other services are granted
  Future<bool> ensurePermissions() async {
    // Request location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("Location permission denied.");
        return false;
      }
    }

    // Check additional permissions (optional)
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
    ].request();
    if (statuses[Permission.location] != PermissionStatus.granted) {
      print("Additional location permission denied.");
      return false;
    }

    return true;
  }

  /// Checks if location services are enabled
  Future<bool> areLocationServicesEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Opens location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Gets the current location
  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Error getting current location: $e");
      return null;
    }
  }

  /// Complete setup: Checks services, permissions, and fetches location
  Future<Position?> fetchLocation() async {
    bool serviceEnabled = await areLocationServicesEnabled();
    if (!serviceEnabled) {
      print("Location services disabled. Opening settings...");
      await openLocationSettings();
      return null;
    }

    bool permissionsGranted = await ensurePermissions();
    if (!permissionsGranted) {
      print("Permissions not granted.");
      return null;
    }

    return await getCurrentPosition();
  }
}
