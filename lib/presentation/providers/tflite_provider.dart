import 'package:flutter/foundation.dart';
import '../../data/models/sensor_data.dart';
import '../../data/services/tflite_model_service.dart';

class TFLiteProvider extends ChangeNotifier {
  final TFLiteModelService _modelService = TFLiteModelService();
  List<dynamic>? _lastPrediction;
  bool _isLoading = false;
  String? _error;

  List<dynamic>? get lastPrediction => _lastPrediction;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initializeModels() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      await _modelService.loadModels();
    } catch (e) {
      _error = 'Failed to load models: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> predictGaitEvent(
    List<SensorData> sensorData,
    String footSide,
  ) async {
    if (sensorData.isEmpty) {
      _error = 'No sensor data available';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Convert SensorData to List<List<double>> for model input
      final sensorDataList = sensorData.map((data) {
        return [
          data.accX,
          data.accY,
          data.accZ,
          data.gyrX,
          data.gyrY,
          data.gyrZ,
        ];
      }).toList();

      _lastPrediction = await _modelService.runInference(
        sensorDataList,
        footSide,
      );
    } catch (e) {
      _error = 'Prediction failed: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getPredictionLabel() {
    if (_lastPrediction == null || _lastPrediction!.isEmpty) {
      return 'No prediction';
    }

    // Assuming the model outputs confidence scores for different gait events
    final scores = _lastPrediction as List<dynamic>;
    int maxIndex = 0;
    double maxScore = 0;

    for (int i = 0; i < scores.length; i++) {
      final score = (scores[i] as num).toDouble();
      if (score > maxScore) {
        maxScore = score;
        maxIndex = i;
      }
    }

    // Map index to gait event labels based on your model
    final gaitEvents = ['Heel Strike', 'Toe Off', 'Swing', 'Stance'];
    return gaitEvents.length > maxIndex ? gaitEvents[maxIndex] : 'Unknown';
  }

  double? getPredictionConfidence() {
    if (_lastPrediction == null || _lastPrediction!.isEmpty) {
      return null;
    }

    final scores = _lastPrediction as List<dynamic>;
    if (scores.isEmpty) return null;

    final maxScore = (scores.cast<num>().reduce((a, b) => a > b ? a : b)).toDouble();
    return maxScore;
  }

  void reset() {
    _lastPrediction = null;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _modelService.dispose();
    super.dispose();
  }
}
