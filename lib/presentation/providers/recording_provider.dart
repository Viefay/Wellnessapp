import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/sensor_data.dart';
import '../../data/services/sensor_service.dart';

class RecordingProvider extends ChangeNotifier {
  final SensorService _sensorService = SensorService();

  String selectedFootSide = 'right';
  bool isRecording = false;
  int remainingSeconds = 30;
  List<SensorData> recordedData = [];

  Timer? _countdownTimer;
  StreamSubscription<SensorData>? _sensorSubscription;

  void selectFootSide(String side) {
    selectedFootSide = side;
    notifyListeners();
  }

  void startRecording() {
    if (isRecording) return;
    isRecording = true;
    remainingSeconds = 30;
    recordedData = [];
    notifyListeners();

    final stream = _sensorService.startRecording(selectedFootSide);
    _sensorSubscription = stream.listen((data) {
      recordedData.add(data);
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        stopRecording();
      }
    });
  }

  void stopRecording() {
    _countdownTimer?.cancel();
    _sensorSubscription?.cancel();
    _sensorService.stopRecording();
    isRecording = false;
    notifyListeners();
  }

  void reset() {
    stopRecording();
    selectedFootSide = 'right';
    remainingSeconds = 30;
    recordedData = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _sensorSubscription?.cancel();
    super.dispose();
  }
}
