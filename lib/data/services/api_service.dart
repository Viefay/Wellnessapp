import 'dart:async';
import '../models/gait_result.dart';
import '../models/sensor_data.dart';
import '../../core/utils/dummy_data.dart';

class ApiService {
  Future<GaitResult> analyzeGaitSession({
    required List<SensorData> rightFootData,
    required List<SensorData> leftFootData,
  }) async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 3));
    return dummyResult;
  }
}
