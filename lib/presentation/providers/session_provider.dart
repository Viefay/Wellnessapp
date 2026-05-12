import 'package:flutter/foundation.dart';
import '../../data/models/gait_result.dart';
import '../../data/models/gait_session.dart';
import '../../data/services/local_storage_service.dart';
import '../../core/utils/dummy_data.dart';

class SessionProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();

  GaitResult? currentResult;
  List<GaitSession> history = List.from(dummySessions);

  void setResult(GaitResult result) {
    currentResult = result;
    notifyListeners();
  }

  Future<void> saveSession() async {
    final result = currentResult;
    if (result == null) return;

    final session = GaitSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      classification: result.classification,
      severity: result.severity,
      result: result,
    );
    await _storage.saveSession(session);
    history = await _storage.loadHistory();
    notifyListeners();
  }

  Future<void> loadHistory() async {
    history = await _storage.loadHistory();
    notifyListeners();
  }
}
