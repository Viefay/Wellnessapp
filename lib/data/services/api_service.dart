import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gait_result.dart';
import '../models/sensor_data.dart';
import '../models/user_profile.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

/// Talks to the Python Flask gait-analysis backend (see `backend/`).
///
/// Base URL is overridable at build time:
///   flutter run --dart-define=API_BASE_URL=http://192.168.1.20:5000
/// Defaults to `10.0.2.2:5000` — the Android emulator's alias for the host
/// machine where `python app.py` runs. For a physical device use the PC's
/// LAN IP; for iOS simulator use 127.0.0.1.
class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );

  Future<GaitResult> analyzeGaitSession({
    required List<SensorData> timeseries,
    required UserProfile profile,
    int samplingRateHz = 100,
  }) async {
    final uri = Uri.parse('$baseUrl/analyze');
    final payload = jsonEncode({
      'samplingRateHz': samplingRateHz,
      'profile': profile.toJson(),
      'timeseries': timeseries.map((s) => s.toJson()).toList(),
    });

    http.Response resp;
    try {
      resp = await http
          .post(uri,
              headers: const {'Content-Type': 'application/json'},
              body: payload)
          .timeout(const Duration(seconds: 90));
    } catch (e) {
      throw ApiException(
          'Cannot reach analysis server at $baseUrl ($e)');
    }

    if (resp.statusCode != 200) {
      throw ApiException(
          'Server returned ${resp.statusCode}: ${resp.body}');
    }
    final map = jsonDecode(resp.body) as Map<String, dynamic>;
    if (map.containsKey('error')) {
      throw ApiException(map['error'].toString());
    }
    return GaitResult.fromJson(map);
  }

  Future<bool> healthCheck() async {
    try {
      final r = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      return r.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
