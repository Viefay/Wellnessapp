import 'dart:async';
import 'dart:math';
import '../models/sensor_data.dart';

class SensorService {
  StreamController<SensorData>? _controller;
  Timer? _timer;
  final _rng = Random();

  Stream<SensorData> startRecording(String footSide) {
    _controller = StreamController<SensorData>.broadcast();
    int tick = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 8), (_) {
      // Synthetic sensor data — placeholder for real IMU
      final data = SensorData(
        timestamp: DateTime.now().millisecondsSinceEpoch,
        accX: _rng.nextDouble() * 0.4 - 0.2,
        accY: _rng.nextDouble() * 0.4 - 0.2,
        accZ: 9.8 + _rng.nextDouble() * 0.4 - 0.2,
        gyrX: _rng.nextDouble() * 0.2 - 0.1,
        gyrY: _rng.nextDouble() * 0.2 - 0.1,
        gyrZ: _rng.nextDouble() * 0.1 - 0.05,
        footSide: footSide,
      );
      _controller?.add(data);
      tick++;
    });

    return _controller!.stream;
  }

  Future<void> stopRecording() async {
    _timer?.cancel();
    await _controller?.close();
    _controller = null;
    _timer = null;
  }
}
