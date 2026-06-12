import 'package:flutter/foundation.dart';
import '../../data/models/gait_result.dart';
import '../../data/models/gait_session.dart';
import '../../data/models/sensor_data.dart';
import '../../data/models/user_profile.dart';
import '../../data/services/firebase_service.dart';
import '../../data/services/export_service.dart';

class SessionProvider extends ChangeNotifier {
  final FirebaseService _firebase = FirebaseService();
  final ExportService _export = ExportService();

  GaitResult? currentResult;
  List<GaitSession> history = [];
  bool loadingHistory = false;
  String? lastNotice;

  void setResult(GaitResult result) {
    currentResult = result;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    loadingHistory = true;
    notifyListeners();
    try {
      history = await _firebase.loadSessions();
      lastNotice = null;
    } catch (e) {
      lastNotice = 'Offline — showing local sessions only';
      debugPrint('Firestore loadSessions skipped: $e');
    } finally {
      loadingHistory = false;
      notifyListeners();
    }
  }

  /// Persists the current result. The recorded [timeseries] is exported to
  /// CSV and the report to PDF, both uploaded to Firebase Storage; their
  /// URLs are attached to the Firestore session document. Every cloud step
  /// is best-effort so the session is still kept locally when offline.
  Future<void> saveSession({
    List<SensorData>? timeseries,
    UserProfile? profile,
  }) async {
    final result = currentResult;
    if (result == null) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    var session = GaitSession(
      id: id,
      date: DateTime.now(),
      classification: result.classification,
      severity: result.severity,
      result: result,
    );

    try {
      if (timeseries != null && timeseries.isNotEmpty) {
        final csv =
            await _export.buildTimeseriesCsv(timeseries, sessionId: id);
        final url = await _firebase.uploadTimeseriesCsv(csv, id);
        session = session.copyWith(csvUrl: url);
      }
      if (profile != null) {
        final pdf = await _export.buildReportPdf(
            result: result, profile: profile, date: session.date);
        final pdfUrl = await _firebase.uploadReportPdf(pdf, id);
        session = session.copyWith(pdfUrl: pdfUrl);
      }
    } catch (e) {
      lastNotice = 'Export upload skipped (offline)';
      debugPrint('Storage upload skipped: $e');
    }

    try {
      await _firebase.saveSession(session);
    } catch (e) {
      lastNotice = 'Saved locally (cloud unavailable)';
      debugPrint('Firestore saveSession skipped: $e');
    }

    // Reflect immediately so the UI updates even when offline.
    history = [session, ...history];
    notifyListeners();

    // Refresh from the cloud when reachable.
    try {
      history = await _firebase.loadSessions();
      notifyListeners();
    } catch (_) {}
  }
}
