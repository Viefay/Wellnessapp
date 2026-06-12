import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/gait_session.dart';
import '../models/user_profile.dart';

/// Firebase backend: Firestore for the subject profile + session history,
/// Cloud Storage for the exported CSV / PDF artifacts.
///
/// No authentication is used (per requirements). The Firestore security
/// rules for the `wellnessapp-bae7b` project must therefore allow
/// unauthenticated read/write on the `profile` and `sessions` collections
/// (test-mode rules), otherwise calls fail with `permission-denied` — the
/// callers treat that as non-fatal and fall back to local storage.
class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static const String _profileCollection = 'profile';
  static const String _profileDoc = 'current';
  static const String _sessionsCollection = 'sessions';

  // ---- Profile ----------------------------------------------------------

  Future<void> saveProfile(UserProfile profile) async {
    await _db
        .collection(_profileCollection)
        .doc(_profileDoc)
        .set(profile.toJson());
  }

  Future<UserProfile?> loadProfile() async {
    final snap =
        await _db.collection(_profileCollection).doc(_profileDoc).get();
    final data = snap.data();
    if (!snap.exists || data == null) return null;
    return UserProfile.fromJson(data);
  }

  // ---- Sessions ---------------------------------------------------------

  Future<void> saveSession(GaitSession session) async {
    await _db
        .collection(_sessionsCollection)
        .doc(session.id)
        .set(session.toJson());
  }

  Future<List<GaitSession>> loadSessions() async {
    final query = await _db
        .collection(_sessionsCollection)
        .orderBy('date', descending: true)
        .get();
    return query.docs
        .map((d) => GaitSession.fromJson(d.data()))
        .toList();
  }

  Future<void> deleteSession(String id) async {
    await _db.collection(_sessionsCollection).doc(id).delete();
  }

  // ---- Storage (CSV / PDF exports) --------------------------------------

  Future<String> uploadTimeseriesCsv(File file, String sessionId) async {
    final ref =
        _storage.ref('exports/$sessionId/timeseries.csv');
    await ref.putFile(
      file,
      SettableMetadata(contentType: 'text/csv'),
    );
    return ref.getDownloadURL();
  }

  Future<String> uploadReportPdf(
      Uint8List bytes, String sessionId) async {
    final ref = _storage.ref('exports/$sessionId/report.pdf');
    await ref.putData(
      bytes,
      SettableMetadata(contentType: 'application/pdf'),
    );
    return ref.getDownloadURL();
  }
}
