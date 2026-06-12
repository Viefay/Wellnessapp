import 'package:flutter/foundation.dart';
import '../../data/models/user_profile.dart';
import '../../data/services/profile_service.dart';
import '../../data/services/firebase_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _local = ProfileService();
  final FirebaseService _firebase = FirebaseService();

  UserProfile _profile = const UserProfile();
  bool _loaded = false;

  UserProfile get profile => _profile;
  bool get loaded => _loaded;
  bool get isComplete => _profile.isComplete;

  /// Loads the local copy first (fast, offline-safe), then refreshes from
  /// Firestore when reachable. Firestore is best-effort: failures (e.g. no
  /// network or restrictive rules) keep the local profile.
  Future<void> load() async {
    final stored = await _local.load();
    if (stored != null) _profile = stored;
    _loaded = true;
    notifyListeners();

    try {
      final remote = await _firebase.loadProfile();
      if (remote != null && remote.toJson().toString() !=
          _profile.toJson().toString()) {
        _profile = remote;
        await _local.save(remote);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Firestore profile load skipped: $e');
    }
  }

  Future<void> update(UserProfile profile) async {
    _profile = profile;
    notifyListeners();
    await _local.save(profile);
    try {
      await _firebase.saveProfile(profile);
    } catch (e) {
      debugPrint('Firestore profile save skipped: $e');
    }
  }
}
