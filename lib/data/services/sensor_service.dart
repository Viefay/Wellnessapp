import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/sensor_data.dart';

class SensorService {
  /// Fixed output sampling rate for the recorded time series (Hz).
  /// The periodic timer samples the latest cached sensor reading at this
  /// rate, so the produced series is uniform regardless of the underlying
  /// platform sensor delivery rate. 100 Hz is a typical choice for gait.
  static const int samplingRateHz = 100;
  static const Duration _samplePeriod =
      Duration(microseconds: 1000000 ~/ samplingRateHz);

  StreamController<SensorData>? _controller;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  Timer? _timer;

  // Store latest sensor readings
  List<double> _currentAccel = [0.0, 0.0, 0.0];
  List<double> _currentGyro = [0.0, 0.0, 0.0];

  Stream<SensorData> startRecording(String footSide) {
    _controller = StreamController<SensorData>.broadcast();

    // Listen to accelerometer
    _accelSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      _currentAccel = [event.x, event.y, event.z];
    });

    // Listen to gyroscope
    _gyroSubscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      _currentGyro = [event.x, event.y, event.z];
    });

    // Emit data at a constant rate so the recorded series is uniform —
    // important for downstream models that expect a fixed sampling rate.
    _timer = Timer.periodic(_samplePeriod, (_) {
      if (_controller?.isClosed ?? true) return;

      final data = SensorData(
        timestamp: DateTime.now().millisecondsSinceEpoch,
        accX: _currentAccel[0],
        accY: _currentAccel[1],
        accZ: _currentAccel[2],
        gyrX: _currentGyro[0],
        gyrY: _currentGyro[1],
        gyrZ: _currentGyro[2],
        footSide: footSide,
      );
      _controller?.add(data);
    });

    return _controller!.stream;
  }

  Future<void> stopRecording() async {
    _timer?.cancel();
    await _accelSubscription?.cancel();
    await _gyroSubscription?.cancel();
    await _controller?.close();
    
    _timer = null;
    _accelSubscription = null;
    _gyroSubscription = null;
    _controller = null;
  }
}

