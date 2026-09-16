import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

/// Wraps Hive boxes used for offline-first local storage.
///
/// We deliberately store plain `Map<String, dynamic>` records (not custom
/// Hive TypeAdapter classes) so there is no code-generation step required
/// to run this project — simpler for a non-programmer to build.
///
/// Data is namespaced per logged-in user (uid) so that switching Google
/// accounts on the same device never mixes data between users.
class LocalDbService {
  static Box? _customerBox;
  static Box? _transactionBox;
  static Box? _pendingSyncBox;
  static Box? _userBox;
  static Box? _settingsBox;

  static String? _currentUid;

  static Future<void> init() async {
    await Hive.initFlutter();
    _userBox = await Hive.openBox(AppConstants.userBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
  }

  /// Call this right after a user logs in, so all per-user boxes
  /// (customers/transactions/pending sync) are isolated by uid.
  static Future<void> openUserBoxes(String uid) async {
    _currentUid = uid;
    _customerBox = await Hive.openBox('${AppConstants.customerBox}_$uid');
    _transactionBox = await Hive.openBox('${AppConstants.transactionBox}_$uid');
    _pendingSyncBox = await Hive.openBox('${AppConstants.pendingSyncBox}_$uid');
  }

  static Future<void> closeUserBoxes() async {
    await _customerBox?.close();
    await _transactionBox?.close();
    await _pendingSyncBox?.close();
    _customerBox = null;
    _transactionBox = null;
    _pendingSyncBox = null;
    _currentUid = null;
  }

  static Box get customerBox {
    if (_customerBox == null) {
      throw StateError('LocalDbService.openUserBoxes(uid) must be called after login');
    }
    return _customerBox!;
  }

  static Box get transactionBox {
    if (_transactionBox == null) {
      throw StateError('LocalDbService.openUserBoxes(uid) must be called after login');
    }
    return _transactionBox!;
  }

  /// Queue of pending sync operations. Key = a unique op id.
  /// Value = { 'entity': 'customer'|'transaction', 'id': ..., 'action': 'upsert'|'delete' }
  static Box get pendingSyncBox {
    if (_pendingSyncBox == null) {
      throw StateError('LocalDbService.openUserBoxes(uid) must be called after login');
    }
    return _pendingSyncBox!;
  }

  static Box get userBox => _userBox!;
  static Box get settingsBox => _settingsBox!;

  static String? get currentUid => _currentUid;
}
