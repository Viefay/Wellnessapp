import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/sensor_data.dart';
import '../../data/services/sensor_service.dart';
import '../../data/services/sensor_processing_service.dart';
import '../../data/services/tflite_model_service.dart';

class RecordingProvider extends ChangeNotifier {
  final SensorService _sensorService = SensorService();
  final TFLiteModelService _modelService = TFLiteModelService();

  /// Suggested minimum walk duration shown as guidance (not enforced).
  static const int recommendedSeconds = 20;

  String selectedFootSide = 'right';
  bool isRecording = false;
  int elapsedSeconds = 0;
  List<SensorData> recordedData = [];
  List<dynamic>? predictionResult;
  bool isPredicting = false;

  Timer? _elapsedTimer;
  StreamSubscription<SensorData>? _sensorSubscription;

  /// Effective output sampling rate of the recorded time series.
  int get samplingRateHz => SensorService.samplingRateHz;

  void selectFootSide(String side) {
    selectedFootSide = side;
    notifyListeners();
  }

  /// Start a recording that runs until the user finishes or cancels it.
  void startRecording() {
    if (isRecording) return;
    isRecording = true;
    elapsedSeconds = 0;
    recordedData = [];
    predictionResult = null;
    notifyListeners();

    final stream = _sensorService.startRecording(selectedFootSide);
    _sensorSubscription = stream.listen((data) {
      recordedData.add(data);
    });

    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds++;
      notifyListeners();
    });
  }

  void _teardown() {
    _elapsedTimer?.cancel();
    _sensorSubscription?.cancel();
    _sensorService.stopRecording();
    _elapsedTimer = null;
    _sensorSubscription = null;
  }

  /// Finish the recording and run analysis on the captured data.
  void finishRecording() {
    if (!isRecording) return;
    _teardown();
    isRecording = false;
    notifyListeners();

    _runModelPrediction();
  }

  /// Abort the recording and discard everything captured so far.
  void cancelRecording() {
    _teardown();
    isRecording = false;
    elapsedSeconds = 0;
    recordedData = [];
    predictionResult = null;
    notifyListeners();
  }

  Future<void> _runModelPrediction() async {
    if (recordedData.isEmpty) return;

    try {
      isPredicting = true;
      notifyListeners();

      // Process sensor data: normalize, filter, and prepare for model
      final processedData = SensorProcessingService.prepareForModel(
        recordedData,
        normalize: true,
        filter: true,
        filterAlpha: 0.15,
      );

      debugPrint(
        'Processing ${recordedData.length} samples for $selectedFootSide foot '
        '(${processedData.length} feature vectors)',
      );

      predictionResult = await _modelService.runInference(
        processedData,
        selectedFootSide,
      );
      debugPrint(
        'Prediction complete for $selectedFootSide foot: $predictionResult',
      );
    } catch (e) {
      debugPrint('Error running prediction: $e');
    } finally {
      isPredicting = false;
      notifyListeners();
    }
  }

  String getPredictionFootSide() {
    return selectedFootSide == 'left' ? 'Left Foot' : 'Right Foot';
  }

  String getModelName() {
    return selectedFootSide == 'left'
        ? 'best_left_gait_event_model.tflite'
        : 'best_right_gait_event_model.tflite';
  }

  /// Get statistics about accumulated sensor data
  Map<String, double> getSensorStats() {
    if (recordedData.isEmpty) {
      return {};
    }
    return SensorProcessingService.computeStats(recordedData);
  }

  /// Get human-readable summary of recorded data
  String getRecordingSummary() {
    if (recordedData.isEmpty) return 'No data recorded';
    
    final duration = recordedData.isNotEmpty
        ? (recordedData.last.timestamp - recordedData.first.timestamp) / 1000
        : 0;
    final stats = getSensorStats();
    
    return 'Recorded ${recordedData.length} samples in ${duration.toStringAsFixed(2)}s\n'
        'Accel range: ${stats['accel_min']?.toStringAsFixed(2) ?? 'N/A'} to ${stats['accel_max']?.toStringAsFixed(2) ?? 'N/A'} m/s²';
  }

  void reset() {
    _teardown();
    isRecording = false;
    selectedFootSide = 'right';
    elapsedSeconds = 0;
    recordedData = [];
    predictionResult = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _teardown();
    _modelService.dispose();
    super.dispose();
  }
}
