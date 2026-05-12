import '../models/gait_session.dart';
import '../../core/utils/dummy_data.dart';

class LocalStorageService {
  // In-memory storage — replace with shared_preferences or Hive for persistence
  final List<GaitSession> _sessions = List.from(dummySessions);

  Future<void> saveSession(GaitSession session) async {
    _sessions.insert(0, session);
  }

  Future<List<GaitSession>> loadHistory() async {
    return List.unmodifiable(_sessions);
  }

  Future<void> clearHistory() async {
    _sessions.clear();
  }
}
