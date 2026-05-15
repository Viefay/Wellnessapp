import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteModelService {
  Interpreter? _leftFootInterpreter;
  Interpreter? _rightFootInterpreter;
  bool _isInitialized = false;

  Future<void> loadModels() async {
    try {
      _leftFootInterpreter = await Interpreter.fromAsset(
        'assets/models/best_left_gait_event_model.tflite',
      );
      _rightFootInterpreter = await Interpreter.fromAsset(
        'assets/models/best_right_gait_event_model.tflite',
      );
      _isInitialized = true;
    } catch (e) {
      print('Error loading TFLite models: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> runInference(
    List<List<double>> sensorData,
    String footSide,
  ) async {
    if (!_isInitialized) {
      await loadModels();
    }

    try {
      final interpreter = footSide == 'left'
          ? _leftFootInterpreter
          : _rightFootInterpreter;

      if (interpreter == null) {
        throw Exception('Model interpreter not initialized for $footSide foot');
      }

      // Prepare input: reshape sensor data to model input shape
      final input = _prepareInput(sensorData);

      // Get output tensor info
      final outputTensor = interpreter.getOutputTensors()[0];
      List<dynamic> output = List.filled(
        outputTensor.shape.reduce((a, b) => a * b),
        0,
      ).reshape(outputTensor.shape);

      // Run inference
      interpreter.run(input, output);

      return output as List<dynamic>;
    } catch (e) {
      print('Error running inference: $e');
      rethrow;
    }
  }

  List<List<double>> _prepareInput(List<List<double>> sensorData) {
    // Reshape and normalize sensor data according to model input requirements
    // Adjust dimensions based on your model's expected input shape
    // This is a placeholder - adjust based on your actual model input format
    return sensorData;
  }

  void dispose() {
    _leftFootInterpreter?.close();
    _rightFootInterpreter?.close();
    _isInitialized = false;
  }
}
