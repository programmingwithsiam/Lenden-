import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import 'local_db_service.dart';

/// Central offline-sync engine.
///
/// STRATEGY (simple + safe, good enough for a single-user multi-device app):
/// 1. Every local write (add/edit/delete of a customer or transaction) is
///    saved to Hive immediately (so the UI works instantly, online or not)
///    AND queued in `pendingSyncBox`.
/// 2. Whenever we have connectivity, we drain the pending queue and push
///    each queued record to Firebase Realtime Database at
///    `users/{uid}/customers/{id}` or `users/{uid}/transactions/{id}`.
/// 3. We also keep a live listener on the same Firebase paths. Any remote
///    record is merged into the local Hive cache using
///    "last write wins" by comparing `updatedAt` timestamps — but a record
///    that still has local unsynced changes (`pendingSync = true`) is never
///    overwritten by an older/equal remote value, so in-flight edits are
///    never lost.
/// 4. Every write uses the same generated `id`, so re-sending a queued item
///    twice simply overwrites the same Firebase node (no duplicates).
class SyncService {
  final DatabaseReference _rootRef;
  final String uid;

  final ValueNotifier<String> syncStatus = ValueNotifier(AppConstants.syncStatusSynced);

  StreamSubscription<DatabaseEvent>? _customerSub;
  StreamSubscription<DatabaseEvent>? _transactionSub;
  StreamSubscription<DatabaseEvent>? _connectedSub;

  bool _firebaseConnected = false;
  Timer? _debouncePush;

  /// Callback the UI layer (providers) can hook into to refresh screens
  /// whenever local data changes because of a remote sync.
  VoidCallback? onRemoteDataChanged;

  SyncService({required this.uid})
      : _rootRef = FirebaseDatabase.instance.ref('users/$uid');

  Future<void> start() async {
    _updatePendingStatus();

    // Firebase's special connection state reference - the most reliable
    // "am I actually connected to Firebase right now" signal.
    _connectedSub = FirebaseDatabase.instance
        .ref('.info/connected')
        .onValue
        .listen((event) {
      _firebaseConnected = event.snapshot.value == true;
      if (_firebaseConnected) {
        pushPendingChanges();
      }
    });

    _listenRemoteCustomers();
    _listenRemoteTransactions();
  }

  void dispose() {
    _customerSub?.cancel();
    _transactionSub?.cancel();
    _connectedSub?.cancel();
    _debouncePush?.cancel();
  }

  // ---------------------------------------------------------------------
  // PUSH: local -> Firebase
  // ---------------------------------------------------------------------

  /// Queues an entity for upload. Called by repositories right after every
  /// local write. Debounced slightly so rapid edits don't spam the network.
  Future<void> enqueue({required String entity, required String id}) async {
    final opId = '${entity}_$id';
    await LocalDbService.pendingSyncBox.put(opId, {
      'entity': entity, // 'customer' | 'transaction'
      'id': id,
    });
    _updatePendingStatus();

    _debouncePush?.cancel();
    _debouncePush = Timer(const Duration(milliseconds: 400), pushPendingChanges);
  }

  Future<void> pushPendingChanges() async {
    final queue = LocalDbService.pendingSyncBox;
    if (queue.isEmpty) {
      syncStatus.value = AppConstants.syncStatusSynced;
      return;
    }

    if (!_firebaseConnected) {
      syncStatus.value = AppConstants.syncStatusPending;
      return;
    }

    syncStatus.value = AppConstants.syncStatusSyncing;

    final keys = queue.keys.toList();
    for (final key in keys) {
      final op = queue.get(key);
      if (op == null) continue;
      final entity = op['entity'] as String;
      final id = op['id'] as String;

      try {
        if (entity == 'customer') {
          final data = LocalDbService.customerBox.get(id);
          if (data != null) {
            await _rootRef.child('${AppConstants.dbCustomers}/$id').set(
                  Map<String, dynamic>.from(data),
                );
          }
        } else if (entity == 'transaction') {
          final data = LocalDbService.transactionBox.get(id);
          if (data != null) {
            await _rootRef.child('${AppConstants.dbTransactions}/$id').set(
                  Map<String, dynamic>.from(data),
                );
          }
        }
        // Mark local record as no longer pending, and remove from queue.
        await _clearPendingFlag(entity, id);
        await queue.delete(key);
      } catch (_) {
        // Leave in queue - will retry on next connectivity event.
        syncStatus.value = AppConstants.syncStatusPending;
        return;
      }
    }

    _updatePendingStatus();
  }

  Future<void> _clearPendingFlag(String entity, String id) async {
    if (entity == 'customer') {
      final data = LocalDbService.customerBox.get(id);
      if (data != null) {
        final map = Map<String, dynamic>.from(data);
        map['pendingSyncLocal'] = false;
        await LocalDbService.customerBox.put(id, map);
      }
    } else if (entity == 'transaction') {
      final data = LocalDbService.transactionBox.get(id);
      if (data != null) {
        final map = Map<String, dynamic>.from(data);
        map['pendingSyncLocal'] = false;
        await LocalDbService.transactionBox.put(id, map);
      }
    }
  }

  void _updatePendingStatus() {
    if (LocalDbService.pendingSyncBox.isEmpty) {
      syncStatus.value = AppConstants.syncStatusSynced;
    } else if (syncStatus.value != AppConstants.syncStatusSyncing) {
      syncStatus.value = AppConstants.syncStatusPending;
    }
  }

  // ---------------------------------------------------------------------
  // PULL: Firebase -> local (merge, last-write-wins on updatedAt)
  // ---------------------------------------------------------------------

  void _listenRemoteCustomers() {
    _customerSub = _rootRef.child(AppConstants.dbCustomers).onValue.listen((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) return;
      value.forEach((key, raw) {
        if (raw is! Map) return;
        _mergeRemoteRecord(
          box: LocalDbService.customerBox,
          id: key.toString(),
          remote: Map<String, dynamic>.from(raw),
        );
      });
      onRemoteDataChanged?.call();
    });
  }

  void _listenRemoteTransactions() {
    _transactionSub = _rootRef.child(AppConstants.dbTransactions).onValue.listen((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) return;
      value.forEach((key, raw) {
        if (raw is! Map) return;
        _mergeRemoteRecord(
          box: LocalDbService.transactionBox,
          id: key.toString(),
          remote: Map<String, dynamic>.from(raw),
        );
      });
      onRemoteDataChanged?.call();
    });
  }

  void _mergeRemoteRecord({
    required Box box,
    required String id,
    required Map<String, dynamic> remote,
  }) {
    final local = box.get(id);
    final remoteUpdatedAt = (remote['updatedAt'] as num?)?.toInt() ?? 0;

    if (local == null) {
      final map = Map<String, dynamic>.from(remote);
      map['pendingSyncLocal'] = false;
      box.put(id, map);
      return;
    }

    final localMap = Map<String, dynamic>.from(local);
    final isLocalPending = localMap['pendingSyncLocal'] == true;
    final localUpdatedAt = (localMap['updatedAt'] as num?)?.toInt() ?? 0;

    // Never clobber an unsynced local edit.
    if (isLocalPending) return;

    // Last write wins.
    if (remoteUpdatedAt >= localUpdatedAt) {
      final map = Map<String, dynamic>.from(remote);
      map['pendingSyncLocal'] = false;
      box.put(id, map);
    }
  }
}
