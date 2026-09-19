import 'dart:io' show Platform;

/// Where the `measurement/` Django backend lives.
///
/// Override it when running against a real machine or a deployed host:
///
///   flutter run --dart-define=MEASUREMENT_API=http://192.168.1.20:8000
///
/// With no override, the default points at the host running the app: an
/// Android emulator reaches its host through 10.0.2.2, while the iOS
/// simulator, macOS and desktop share the host's own loopback.
class ApiConfig {
  static const String _override =
      String.fromEnvironment('MEASUREMENT_API', defaultValue: '');

  static String get measurementBaseUrl {
    if (_override.isNotEmpty) return _override;
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    } catch (_) {
      // Platform is unavailable on web; fall through to loopback.
    }
    return 'http://localhost:8000';
  }

  static Uri get liveMeasurement =>
      Uri.parse('$measurementBaseUrl/api/measurement/live/');
}
