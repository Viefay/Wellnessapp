import 'dart:math';
import '../models/sensor_data.dart';

class SensorProcessingService {
  // Normalization parameters
  static const double accelGain = 1.0 / 16384.0; // 16-bit resolution
  static const double gyroGain = 1.0 / 131.0; // 16-bit resolution for gyro

  /// Normalize raw sensor values to standard units (m/s² for accel, rad/s for gyro)
  static SensorData normalizeSensorData(SensorData raw) {
    return SensorData(
      timestamp: raw.timestamp,
      accX: raw.accX * accelGain,
      accY: raw.accY * accelGain,
      accZ: raw.accZ * accelGain,
      gyrX: raw.gyrX * gyroGain,
      gyrY: raw.gyrY * gyroGain,
      gyrZ: raw.gyrZ * gyroGain,
      footSide: raw.footSide,
    );
  }

  /// Calculate magnitude of acceleration vector
  static double getAccelMagnitude(SensorData data) {
    return sqrt(data.accX * data.accX + data.accY * data.accY + data.accZ * data.accZ);
  }

  /// Calculate magnitude of angular velocity vector
  static double getGyroMagnitude(SensorData data) {
    return sqrt(data.gyrX * data.gyrX + data.gyrY * data.gyrY + data.gyrZ * data.gyrZ);
  }

  /// Compute statistics for a series of sensor data
  static Map<String, double> computeStats(List<SensorData> data) {
    if (data.isEmpty) {
      return {};
    }

    // Acceleration stats
    final accelMags = data.map((d) => getAccelMagnitude(d)).toList();
    final accelMean = accelMags.reduce((a, b) => a + b) / accelMags.length;
    final accelStd = sqrt(
      accelMags
          .map((m) => (m - accelMean) * (m - accelMean))
          .reduce((a, b) => a + b) /
          accelMags.length,
    );

    // Gyro stats
    final gyroMags = data.map((d) => getGyroMagnitude(d)).toList();
    final gyroMean = gyroMags.reduce((a, b) => a + b) / gyroMags.length;
    final gyroStd = sqrt(
      gyroMags
          .map((m) => (m - gyroMean) * (m - gyroMean))
          .reduce((a, b) => a + b) /
          gyroMags.length,
    );

    return {
      'accel_mean': accelMean,
      'accel_std': accelStd,
      'accel_max': accelMags.reduce((a, b) => a > b ? a : b),
      'accel_min': accelMags.reduce((a, b) => a < b ? a : b),
      'gyro_mean': gyroMean,
      'gyro_std': gyroStd,
      'gyro_max': gyroMags.reduce((a, b) => a > b ? a : b),
      'gyro_min': gyroMags.reduce((a, b) => a < b ? a : b),
    };
  }

  /// Apply low-pass filter to smooth sensor data
  static List<SensorData> applyLowPassFilter(
    List<SensorData> data, {
    double alpha = 0.1,
  }) {
    if (data.isEmpty) return [];

    final filtered = <SensorData>[];
    SensorData prev = data[0];

    filtered.add(prev);

    for (int i = 1; i < data.length; i++) {
      final current = data[i];
      final smoothed = SensorData(
        timestamp: current.timestamp,
        accX: alpha * current.accX + (1 - alpha) * prev.accX,
        accY: alpha * current.accY + (1 - alpha) * prev.accY,
        accZ: alpha * current.accZ + (1 - alpha) * prev.accZ,
        gyrX: alpha * current.gyrX + (1 - alpha) * prev.gyrX,
        gyrY: alpha * current.gyrY + (1 - alpha) * prev.gyrY,
        gyrZ: alpha * current.gyrZ + (1 - alpha) * prev.gyrZ,
        footSide: current.footSide,
      );
      filtered.add(smoothed);
      prev = smoothed;
    }

    return filtered;
  }

  /// Prepare sensor data for model input with normalization and filtering
  static List<List<double>> prepareForModel(
    List<SensorData> rawData, {
    bool normalize = true,
    bool filter = true,
    double filterAlpha = 0.1,
  }) {
    var data = rawData;

    // Apply normalization
    if (normalize) {
      data = data.map((d) => normalizeSensorData(d)).toList();
    }

    // Apply low-pass filter
    if (filter) {
      data = applyLowPassFilter(data, alpha: filterAlpha);
    }

    // Convert to model input format
    return data
        .map((d) => [d.accX, d.accY, d.accZ, d.gyrX, d.gyrY, d.gyrZ])
        .toList();
  }
}
